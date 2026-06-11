import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class DeleteMealUseCase {
  final MealRepo repository;

  DeleteMealUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String mealId,
  }) {
    return repository.deleteMeal(
      token: token,
      mealId: mealId,
    );
  }
}
