import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';

class AddOfferUseCase {
  final MealRepo repository;

  AddOfferUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    String? mealId,
    required String title,
    String? description,
    String? offerImgUrl,
    required double originalPrice,
    required double offerPrice,
    int? quantity,
    required bool isActive,
    String? category,
    String? cuisine,
    List<String>? tags,
    String? startsAt,
    String? expiresAt,
  }) {
    return repository.addOffer(
      token: token,
      mealId: mealId,
      title: title,
      description: description,
      offerImgUrl: offerImgUrl,
      originalPrice: originalPrice,
      offerPrice: offerPrice,
      quantity: quantity,
      isActive: isActive,
      category: category,
      cuisine: cuisine,
      tags: tags,
      startsAt: startsAt,
      expiresAt: expiresAt,
    );
  }
}
