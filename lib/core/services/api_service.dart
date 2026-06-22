import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eat2beat/core/errors/exceptions.dart';

class ApiService {
  final String _workerBaseUrl = 'https://e.eat2beatt.workers.dev';
  List<dynamic>? _cachedRestaurants;

  List<dynamic>? get cachedRestaurants => _cachedRestaurants;

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

  Future<void> createRestaurantOffer(
      String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/offers/create');
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
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to create offer (${response.statusCode})',
      );
    }
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

  Future<List<dynamic>> getForecast(
    String token,
    String restaurantId, {
    int days = 7,
    bool save = false,
  }) async {
    final uri = Uri.parse(
      '$_workerBaseUrl/demand/forecast/${Uri.encodeComponent(restaurantId)}?days=$days&save=${save ? 1 : 0}',
    );
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
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load forecast data (${response.statusCode})',
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

  Future<List<dynamic>> getUserRestaurants(String token, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedRestaurants != null && _cachedRestaurants!.isNotEmpty) {
      return _cachedRestaurants!;
    }
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
        _cachedRestaurants = data;
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

  Future<void> setCartItem(String token, String mealId, int quantity, {bool isOffer = false}) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart/set-item');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        isOffer ? 'offer_id' : 'meal_id': mealId,
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

  Future<void> removeCartItem(String token, String mealId, {bool isOffer = false}) async {
    final uri = Uri.parse('$_workerBaseUrl/user/cart/remove-item');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        isOffer ? 'offer_id' : 'meal_id': mealId,
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

  Future<Map<String, dynamic>> getMealReviews(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/reviews?meal_id=${Uri.encodeComponent(mealId)}');
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
          : 'Failed to load meal reviews (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>?> getMyMealRating(String token, String mealId) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/my-rating?meal_id=${Uri.encodeComponent(mealId)}');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) return null;
      final decoded = json.decode(response.body);
      if (decoded == null) return null;
      return decoded as Map<String, dynamic>;
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load my meal rating (${response.statusCode})',
    );
  }

  Future<void> rateMeal(
    String token, {
    required String mealId,
    required double rating,
    String? reviewText,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/user/meals/rating');
    final body = <String, dynamic>{
      'meal_id': mealId,
      'rating': rating,
    };
    if (reviewText != null && reviewText.trim().isNotEmpty) {
      body['review_text'] = reviewText.trim();
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
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to submit rating (${response.statusCode})',
      );
    }
  }

  Future<List<dynamic>> getRecommendedMeals(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/recommend');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['recommendations'] is List) {
        return decoded['recommendations'] as List<dynamic>;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load recommendations (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> getRestaurantOrderability(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/orderability');
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
          : 'Failed to load restaurant orderability (${response.statusCode})',
    );
  }

  Future<void> updateRestaurantOrderability(
    String token, {
    required bool isAcceptingOrders,
    String? pauseReason,
  }) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/orderability/update');
    final body = <String, dynamic>{
      'is_accepting_orders': isAcceptingOrders,
    };
    if (pauseReason != null) {
      body['pause_reason'] = pauseReason;
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
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to update orderability (${response.statusCode})',
      );
    }
  }

  Future<List<dynamic>> getRestaurantOpeningHours(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/opening-hours');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load opening hours (${response.statusCode})',
    );
  }

  Future<void> upsertRestaurantOpeningHours(
    String token,
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/opening-hours/upsert');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to update opening hours (${response.statusCode})',
      );
    }
  }

  Future<List<dynamic>> getUserOffers(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/user/offers');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map && decoded['offers'] is List) {
        return decoded['offers'] as List<dynamic>;
      } else if (decoded is Map && decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      } else if (decoded is Map && decoded['rows'] is List) {
        return decoded['rows'] as List<dynamic>;
      }
      return [];
    }

    throw CustomExceptions(
      message: response.body.isNotEmpty
          ? response.body
          : 'Failed to load offers (${response.statusCode})',
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  // CHARITY-SIDE APIS
  // ═════════════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getCharityProfile(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/profile');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded[0] as Map<String, dynamic>;
      }
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load profile');
  }

  Future<void> updateCharityProfile(String token, Map<String, dynamic> payload) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/profile/update');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Update profile failed');
    }
  }

  Future<List<dynamic>> getAvailableDonations(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/donations/available?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load donations');
  }

  Future<List<dynamic>> getDonationItems(String token, String donationId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/donation-items?donation_id=${Uri.encodeComponent(donationId)}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load donation items');
  }

  Future<List<dynamic>> getCharityPickupsAll(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickups/all?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load pickup requests');
  }

  Future<List<dynamic>> getCharityPickupsApproved(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickups/approved?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load approved requests');
  }

  Future<List<dynamic>> getCharityPickupsPickedUp(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickups/picked-up?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load picked up requests');
  }

  Future<List<dynamic>> getCharityPickupsRejected(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickups/rejected?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load rejected requests');
  }

  Future<Map<String, dynamic>> requestPickup(String token, String donationId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickup/request');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'donation_id': donationId}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded[0] as Map<String, dynamic>;
      }
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Request pickup failed');
  }

  Future<void> cancelPickup(String token, String pickupId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickup/cancel');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'pickup_id': pickupId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Cancel pickup failed');
    }
  }

  Future<void> confirmPickup(String token, String pickupId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickup/confirm');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'pickup_id': pickupId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Confirm pickup failed');
    }
  }

  Future<Map<String, dynamic>> getCharityStats(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/stats');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded[0] as Map<String, dynamic>;
      }
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load stats');
  }

  Future<List<dynamic>> getCharityHistory(
    String token, {
    String time = 'all',
    String? from,
    String? to,
    int? tzOffsetMinutes,
  }) async {
    var urlStr = '$_workerBaseUrl/charity/history?limit=50&time=$time';
    if (from != null) {
      urlStr += '&from=${Uri.encodeComponent(from)}';
    }
    if (to != null) {
      urlStr += '&to=${Uri.encodeComponent(to)}';
    }
    if (tzOffsetMinutes != null) {
      urlStr += '&tzOffsetMinutes=$tzOffsetMinutes';
    }
    final uri = Uri.parse(urlStr);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load history');
  }

  Future<List<dynamic>> getCharitySchedules(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/schedules');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load schedules');
  }

  Future<void> confirmSchedule(String token, String scheduleId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickup/schedule/confirm');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'schedule_id': scheduleId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Confirm schedule failed');
    }
  }

  Future<void> cancelSchedule(String token, String scheduleId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/pickup/schedule/cancel');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'schedule_id': scheduleId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Cancel schedule failed');
    }
  }

  Future<List<dynamic>> searchRestaurants(String token, {String query = '', bool availableOnly = false}) async {
    final qString = query.isNotEmpty ? 'q=${Uri.encodeComponent(query)}&' : '';
    final availString = availableOnly ? 'available_only=true' : '';
    final uri = Uri.parse('$_workerBaseUrl/charity/search/restaurants?${qString}${availString}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to search restaurants');
  }

  Future<Map<String, dynamic>> getRestaurantProfile(String token, String restaurantId) async {
    final uri = Uri.parse('$_workerBaseUrl/charity/restaurants/${Uri.encodeComponent(restaurantId)}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load restaurant profile');
  }

  Future<List<dynamic>> getRestaurantDonations(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/donations?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load restaurant donations');
  }

  Future<List<dynamic>> getRestaurantDonationItems(String token, String donationId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/donation-items?donation_id=$donationId');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded['data'] is List) return decoded['data'] as List<dynamic>;
      return [];
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load donation items');
  }

  Future<Map<String, dynamic>> addRestaurantDonation(String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/add-donation');
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
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) return decoded[0] as Map<String, dynamic>;
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to add donation');
  }

  Future<void> removeRestaurantDonation(String token, String donationId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/remove-donation');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'donation_id': donationId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to remove donation');
    }
  }

  Future<Map<String, dynamic>> addRestaurantDonationItem(String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/donation-items/add');
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
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) return decoded[0] as Map<String, dynamic>;
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to add donation item');
  }

  Future<void> removeRestaurantDonationItem(String token, String itemId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/donation-items/remove');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'item_id': itemId}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to remove donation item');
    }
  }

  Future<List<dynamic>> getAdminPickupRequests(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/pickup-requests?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load pickup requests');
  }

  Future<void> approvePickupRequest(String token, String pickupId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/pickup/approve');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'pickup_id': pickupId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to approve pickup request');
    }
  }

  Future<void> rejectPickupRequest(String token, String pickupId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/pickup/reject');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'pickup_id': pickupId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to reject pickup request');
    }
  }

  Future<Map<String, dynamic>> schedulePickup(String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/pickup/schedule');
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
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) return decoded[0] as Map<String, dynamic>;
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to schedule pickup');
  }

  Future<Map<String, dynamic>> reschedulePickup(String token, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/pickup/reschedule');
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
      final decoded = json.decode(response.body);
      if (decoded is List && decoded.isNotEmpty) return decoded[0] as Map<String, dynamic>;
      return decoded as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to reschedule pickup');
  }

  Future<List<dynamic>> getAdminSchedules(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/schedules');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load schedules');
  }

  Future<List<dynamic>> getAdminDonationHistory(String token) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/history/donations?limit=50');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load history');
  }

  Future<List<dynamic>> searchCharities(String token, String query) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/search/charities?q=${Uri.encodeComponent(query)}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to search charities');
  }

  Future<Map<String, dynamic>> getAdminCharityProfile(String token, String charityId) async {
    final uri = Uri.parse('$_workerBaseUrl/restaurant/charity/${Uri.encodeComponent(charityId)}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load charity profile');
  }

  Future<List<dynamic>> getNotifications(String token, {bool unreadOnly = false}) async {
    final qs = unreadOnly ? '?unread=true' : '';
    final uri = Uri.parse('$_workerBaseUrl/notifications$qs');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to load notifications');
  }

  Future<void> markNotificationsAsRead(String token, {List<String>? ids}) async {
    final uri = Uri.parse('$_workerBaseUrl/notifications/read');
    final body = ids != null && ids.isNotEmpty ? {'ids': ids} : {};
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
      throw CustomExceptions(message: response.body.isNotEmpty ? response.body : 'Failed to mark notifications as read');
    }
  }
}


