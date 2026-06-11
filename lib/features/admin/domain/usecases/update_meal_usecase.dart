import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class UpdateMealUseCase {
  final MealRepo repository;

  UpdateMealUseCase(this.repository);

  Future<Either<Failure, MealEntity>> call({
    required String token,
    required String mealId,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String? mealImgBase64,
    required String? mealImgUrl,
  }) {
    return repository.updateMeal(
      token: token,
      mealId: mealId,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      expiryTime: expiryTime,
      category: category,
      mealImgBase64: mealImgBase64,
      mealImgUrl: mealImgUrl,
    );
  }
}
