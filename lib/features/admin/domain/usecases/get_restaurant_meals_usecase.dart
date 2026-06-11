import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class GetRestaurantMealsUseCase {
  final MealRepo repository;

  GetRestaurantMealsUseCase(this.repository);

  Future<Either<Failure, List<MealEntity>>> call(String token) {
    return repository.getMeals(token);
  }
}
