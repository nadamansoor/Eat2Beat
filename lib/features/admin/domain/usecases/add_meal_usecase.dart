import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class AddMealUseCase {
  final MealRepo repository;

  AddMealUseCase(this.repository);

  Future<Either<Failure, MealEntity>> call({
    required String token,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String mealImgBase64,
  }) {
    return repository.addMeal(
      token: token,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      expiryTime: expiryTime,
      category: category,
      mealImgBase64: mealImgBase64,
    );
  }
}
