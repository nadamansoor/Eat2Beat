import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';

sealed class AddMealState {}

class AddMealInitial extends AddMealState {}

class AddMealLoading extends AddMealState {}

class AddMealSuccess extends AddMealState {}

class AddOfferSuccess extends AddMealState {}

class AddMealsLoading extends AddMealState {}

class AddMealMealsLoaded extends AddMealState {
  final List<MealEntity> meals;
  AddMealMealsLoaded(this.meals);
}

class AddMealError extends AddMealState {
  final String message;
  AddMealError({required this.message});
}

class AddMealImagePicked extends AddMealState {
  final String imagePath;
  final String base64Data;
  AddMealImagePicked({required this.imagePath, required this.base64Data});
}
