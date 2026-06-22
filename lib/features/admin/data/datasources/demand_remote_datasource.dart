import 'package:eat2beat/core/services/api_service.dart';

abstract class DemandRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData({
    required String token,
    required String restaurantId,
    int days = 7,
  });

  Future<List<dynamic>> getForecast({
    required String token,
    required String restaurantId,
    int days = 7,
    bool save = false,
  });

  Future<List<dynamic>> getMeals(String token);
  Future<List<dynamic>> getRestaurantDonations(String token);
}

class DemandRemoteDataSourceImpl implements DemandRemoteDataSource {
  final ApiService apiService;

  DemandRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> getDashboardData({
    required String token,
    required String restaurantId,
    int days = 7,
  }) async {
    return await apiService.getDashboardData(token, restaurantId, days: days);
  }

  @override
  Future<List<dynamic>> getForecast({
    required String token,
    required String restaurantId,
    int days = 7,
    bool save = false,
  }) async {
    return await apiService.getForecast(token, restaurantId, days: days, save: save);
  }

  @override
  Future<List<dynamic>> getMeals(String token) async {
    return await apiService.getMeals(token);
  }

  @override
  Future<List<dynamic>> getRestaurantDonations(String token) async {
    return await apiService.getRestaurantDonations(token);
  }
}


