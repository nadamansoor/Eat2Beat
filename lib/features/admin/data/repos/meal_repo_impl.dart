import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/data/datasources/meal_remote_datasource.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class MealRepoImpl implements MealRepo {
  final MealRemoteDataSource remoteDataSource;

  MealRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals(String token) async {
    try {
      final meals = await remoteDataSource.getMeals(token);
      return right(meals);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading meals. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, MealEntity>> addMeal({
    required String token,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String mealImgBase64,
  }) async {
    try {
      final meal = await remoteDataSource.addMeal(
        token: token,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        expiryTime: expiryTime,
        category: category,
        mealImgBase64: mealImgBase64,
      );
      return right(meal);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while adding the meal. Please try again.'));
    }
  }

  @override
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
  }) async {
    try {
      final meal = await remoteDataSource.updateMeal(
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
      return right(meal);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while updating the meal. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMeal({
    required String token,
    required String mealId,
  }) async {
    try {
      await remoteDataSource.deleteMeal(token: token, mealId: mealId);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while deleting the meal. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, String>> updateRestaurantImage({
    required String token,
    required String imgUrl,
  }) async {
    try {
      final newUrl = await remoteDataSource.updateRestaurantImage(token: token, imgUrl: imgUrl);
      return right(newUrl);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while updating restaurant image. Please try again.'));
    }
  }
}
