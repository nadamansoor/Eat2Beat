import 'package:eat2beat/core/services/api_service.dart';

abstract class DemandRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData({
    required String token,
    required String restaurantId,
    int days = 7,
  });
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
}
