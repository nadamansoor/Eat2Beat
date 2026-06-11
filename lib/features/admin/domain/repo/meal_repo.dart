import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';

abstract class MealRepo {
  Future<Either<Failure, List<MealEntity>>> getMeals(String token);
  
  Future<Either<Failure, MealEntity>> addMeal({
    required String token,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String mealImgBase64,
  });

  Future<Either<Failure, MealEntity>> updateMeal({
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
  });

  Future<Either<Failure, void>> deleteMeal({
    required String token,
    required String mealId,
  });

  Future<Either<Failure, String>> updateRestaurantImage({
    required String token,
    required String imgUrl,
  });
}
