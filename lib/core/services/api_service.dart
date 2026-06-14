import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eat2beat/core/errors/exceptions.dart';

class ApiService {
  final String _workerBaseUrl = 'https://e.eat2beatt.workers.dev';

  Future<Map<String, dynamic>> getProfile(
    String token,
    String expectedRole,
  ) async {
    final uri = Uri.parse(
      '$_workerBaseUrl/profile/me?expected_role=${Uri.encodeComponent(expectedRole)}',
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final responseText = response.body;

    if (response.statusCode == 200 && responseText.isNotEmpty) {
      final data = json.decode(responseText) as Map<String, dynamic>;
      return data;
    }

    if (response.statusCode != 200) {
      if (responseText.contains('ROLE_MISMATCH')) {
        throw RoleMismatchException();
      }

      if (responseText.contains('PROFILE_NOT_FOUND')) {
        throw ProfileNotFoundException();
      }
      throw CustomExceptions(
        message:
            responseText.isNotEmpty
                ? responseText
                : 'profile_me_failed_${response.statusCode}',
      );
    }

    return {};
  }

  Future<void> createProfile(
    String token,
    String fullName,
    String email,
    String workerRole, {
    Map<String, String>? restaurantDetails,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/signup/create-profile');

    final body = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'role': workerRole,
    };

    // Add restaurant-specific fields if provided
    if (restaurantDetails != null) {
      body.addAll(restaurantDetails);
    }

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final responseText = response.body;
      throw CustomExceptions(
        message:
            responseText.isNotEmpty
                ? responseText
                : 'create_profile_failed_${response.statusCode}',
      );
    }
  }

  Future<void> updateProfile(
    String token, {
    String? restaurantName,
    String? phone,
    String? address,
    String? openTime,
    String? closeTime,
    bool? isOpen,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/profile/update');
    final body = <String, dynamic>{};
    if (restaurantName != null) body['restaurant_name'] = restaurantName;
    if (phone != null) body['phone'] = phone;
    if (address != null) body['address'] = address;
    if (openTime != null) {
      body['open_time'] = openTime;
      body['openTime'] = openTime;
    }
    if (closeTime != null) {
      body['close_time'] = closeTime;
      body['closeTime'] = closeTime;
    }
    if (isOpen != null) {
      body['is_open'] = isOpen;
      body['isOpen'] = isOpen;
    }

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty ? response.body : 'Update failed (${response.statusCode})',
      );
    }
  }

  // ── Meal CRUD API Methods ──────────────────────────────────────────

  Future<List<dynamic>> getMeals(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/meals');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      } else if (data is Map && data['meals'] is List) {
        return data['meals'];
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load meals from server (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> addMeal(
      String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/add-meal');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final raw = response.body.trim();
      if (raw.isNotEmpty && raw.startsWith('{')) {
        final data = json.decode(raw);
        if (data is Map<String, dynamic>) return data;
      }
      return {};
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to add meal (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> updateMeal(
      String token, Map<String, dynamic> body) async {
    // Try primary endpoint first; fall back to alternate if Worker returns 404.
    final endpoints = [
      '$_workerBaseUrl/restaurant/edit-meal',
      '$_workerBaseUrl/restaurant/update-meal',
    ];

    http.Response? lastResponse;
    for (final endpoint in endpoints) {
      final uri = Uri.parse(endpoint);
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );
      lastResponse = response;

      // If the worker says route not found, try the next endpoint.
      if (response.statusCode == 404 ||
          response.body.toLowerCase().contains('route not found') ||
          response.body.toLowerCase().contains('not found')) {
        continue;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final raw = response.body.trim();
        if (raw.isNotEmpty && raw.startsWith('{')) {
          final data = json.decode(raw);
          if (data is Map<String, dynamic>) return data;
        }
        return {};
      }

      // Any other non-success code (401, 400, 500, etc.) — throw immediately.
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to update meal (${response.statusCode})',
      );
    }

    // All endpoints exhausted — throw with last response body.
    throw CustomExceptions(
      message: lastResponse?.body.isNotEmpty == true
          ? lastResponse!.body
          : 'Update meal endpoint not found on server',
    );
  }

  Future<void> deleteMeal(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/delete-meal');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'meal_id': mealId}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to delete meal (${response.statusCode})',
      );
    }
  }

  Future<String> updateRestaurantImage(String token, String imgUrl) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/update-image');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'img_url': imgUrl}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['restaurant_img_url']?.toString() ?? data['img_url']?.toString() ?? imgUrl;
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to update restaurant image (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> getOrders(
    String token, {
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  }) async {
    final Map<String, String> queryParams = {
      'limit': limit.toString(),
      'time': time,
      'tz_offset_minutes': DateTime.now().timeZoneOffset.inMinutes.toString(),
    };
    if (status != null && status.trim().isNotEmpty) {
      queryParams['status'] = status;
    }
    if (cursor != null && cursor.trim().isNotEmpty) {
      queryParams['cursor'] = cursor;
    } else {
      queryParams['offset'] = offset.toString();
    }

    final uri = Uri.parse('$_workerBaseUrl/restaurant/history/orders').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> orders = data is List
          ? data
          : (data is Map && data['orders'] is List ? data['orders'] : []);
      return {
        'orders': orders,
        'headers': response.headers,
      };
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load orders (${response.statusCode})',
    );
  }

  Future<void> updateOrderStatus(
    String token, {
    required String orderId,
    required String status,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/orders/update-status');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'order_id': orderId,
        'status': status,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
          ? response.body
          : 'Failed to update order status (${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>> getDashboardData(
    String token,
    String restaurantId, {
    int days = 7,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/demand/dashboard-data/$restaurantId?days=$days');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load dashboard data (${response.statusCode})',
    );
  }

  Future<String> getRestaurantId(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/meals?include_hidden=true&limit=1&offset=0');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> rows = body is List
          ? body
          : (body is Map && body['meals'] is List ? body['meals'] : []);
      if (rows.isNotEmpty) {
        final row = rows[0];
        final rid = row['restaurant_id']?.toString() ?? row['restaurants_id']?.toString() ?? '';
        if (rid.isNotEmpty) return rid;
      }
    }
    throw CustomExceptions(message: 'Missing restaurant_id or failed to fetch');
  }

  Future<List<dynamic>> getUserRestaurants(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/restaurants?limit=50');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load restaurants (${response.statusCode})',
    );
  }

  Future<List<dynamic>> getRestaurantMeals(String token, String restaurantId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/restaurant-meals?restaurant_id=$restaurantId&limit=50');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load restaurant meals (${response.statusCode})',
    );
  }

  Future<void> favoriteMeal(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/favorite');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'meal_id': mealId}),
    );

    if (response.statusCode != 200 && response.statusCode != 204 && response.statusCode != 201) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to favorite meal (${response.statusCode})',
      );
    }
  }

  Future<void> unfavoriteMeal(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/unfavorite');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'meal_id': mealId}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to unfavorite meal (${response.statusCode})',
      );
    }
  }

  Future<List<dynamic>> getFavoriteMealIds(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/favorites');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load favorite meal IDs (${response.statusCode})',
    );
  }

  Future<List<dynamic>> getFavoriteMealsList(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/favorites/list');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load favorite meals (${response.statusCode})',
    );
  }

  Future<List<dynamic>> getCart(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load cart (${response.statusCode})',
    );
  }

  Future<void> setCartItem(String token, String mealId, int quantity) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart/set-item');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'meal_id': mealId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to update cart item quantity (${response.statusCode})',
      );
    }
  }

  Future<void> removeCartItem(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart/remove-item');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'meal_id': mealId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to remove cart item (${response.statusCode})',
      );
    }
  }

  Future<void> clearCart(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart/clear');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to clear cart (${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>> checkoutCart(
    String token, {
    required String address,
    required String area,
    required String name,
    required String phone,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/user/checkout');
    final idempotencyKey = '${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}';
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Idempotency-Key': idempotencyKey,
      },
      body: json.encode({
        'address': address,
        'area': area,
        'customer_name': name,
        'customer_phone': phone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {};
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to place order (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> getUserOrderHistoryPage(
    String token, {
    int limit = 10,
    String? cursor,
    int offset = 0,
    String time = 'all',
    String status = '',
  }) async {
    final Map<String, String> queryParams = {
      'limit': limit.toString(),
      'time': time,
      'tz_offset_minutes': DateTime.now().timeZoneOffset.inMinutes.toString(),
    };
    if (status.trim().isNotEmpty) {
      queryParams['status'] = status.trim();
    }
    if (cursor != null && cursor.trim().isNotEmpty) {
      queryParams['cursor'] = cursor.trim();
    } else {
      queryParams['offset'] = offset.toString();
    }

    final uri = Uri.parse('$_workerBaseUrl/user/history/orders').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> rows = data is List
          ? data
          : (data is Map && data['orders'] is List
              ? data['orders']
              : (data is Map && data['data'] is List ? data['data'] : [data]));
      final nextCursor = response.headers['x-next-cursor'] ?? response.headers['X-Next-Cursor'];
      return {
        'rows': rows,
        'nextCursor': nextCursor?.trim().isNotEmpty == true ? nextCursor!.trim() : null,
      };
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load order history (${response.statusCode})',
    );
  }
}

