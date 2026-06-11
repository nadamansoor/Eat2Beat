import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/admin/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<Map<String, dynamic>> getOrders({
    required String token,
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  });

  Future<void> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;

  OrderRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> getOrders({
    required String token,
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  }) async {
    final result = await apiService.getOrders(
      token,
      limit: limit,
      time: time,
      status: status,
      cursor: cursor,
      offset: offset,
    );

    final List<dynamic> rawOrders = result['orders'];
    final orders = rawOrders.map((o) => OrderModel.fromJson(o)).toList();
    final headers = result['headers'] as Map<String, String>;

    final rawCursor = headers['x-next-cursor'] ?? headers['X-Next-Cursor'] ?? '';
    final nextCursor = rawCursor.trim().isNotEmpty ? rawCursor.trim() : null;

    return {
      'orders': orders,
      'nextCursor': nextCursor,
    };
  }

  @override
  Future<void> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  }) async {
    await apiService.updateOrderStatus(token, orderId: orderId, status: status);
  }
}
