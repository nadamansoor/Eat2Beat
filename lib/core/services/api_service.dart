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

    print('➡️ CALLING PROFILE API');
    print('EXPECTED ROLE SENT: $expectedRole');
    print('URL: $uri');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');
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
}
