import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class UpdateRestaurantImageUseCase {
  final MealRepo repository;

  UpdateRestaurantImageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String token,
    required String imgUrl,
  }) {
    return repository.updateRestaurantImage(
      token: token,
      imgUrl: imgUrl,
    );
  }
}
