import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/order_repo.dart';

class UpdateOrderStatusUseCase {
  final OrderRepo repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String orderId,
    required String status,
  }) {
    return repository.updateOrderStatus(
      token: token,
      orderId: orderId,
      status: status,
    );
  }
}
