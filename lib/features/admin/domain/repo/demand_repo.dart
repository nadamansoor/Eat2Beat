import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

abstract class DemandRepository {
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String token,
    required String restaurantId,
    int days = 7,
  });
}
