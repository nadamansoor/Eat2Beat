import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';

abstract class OrderRepo {
  Future<Either<Failure, Map<String, dynamic>>> getOrders({
    required String token,
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  });

  Future<Either<Failure, void>> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  });
}
