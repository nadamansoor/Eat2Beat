import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/order_repo.dart';

class GetOrdersUseCase {
  final OrderRepo repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String token,
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  }) {
    return repository.getOrders(
      token: token,
      limit: limit,
      time: time,
      status: status,
      cursor: cursor,
      offset: offset,
    );
  }
}
