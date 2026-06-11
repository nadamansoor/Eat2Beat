import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/data/datasources/order_remote_datasource.dart';
import 'package:eat2beat/features/admin/domain/repo/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrders({
    required String token,
    required int limit,
    required String time,
    required String? status,
    required String? cursor,
    required int offset,
  }) async {
    try {
      final data = await remoteDataSource.getOrders(
        token: token,
        limit: limit,
        time: time,
        status: status,
        cursor: cursor,
        offset: offset,
      );
      return right(data);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading orders. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updateOrderStatus(
        token: token,
        orderId: orderId,
        status: status,
      );
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while updating order status. Please try again.'));
    }
  }
}
