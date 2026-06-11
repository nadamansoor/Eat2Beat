import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/demand_repo.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

class GetDemandDashboardUseCase {
  final DemandRepository repository;

  GetDemandDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardData>> call({
    required String token,
    required String restaurantId,
    int days = 7,
  }) {
    return repository.getDashboardData(
      token: token,
      restaurantId: restaurantId,
      days: days,
    );
  }
}
