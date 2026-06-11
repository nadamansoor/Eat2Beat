import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';

sealed class MealsState {}

class MealsInitial extends MealsState {}

class MealsLoading extends MealsState {}

class MealsLoaded extends MealsState {
  final List<MealEntity> meals;
  final String restaurantImageUrl;
  MealsLoaded({required this.meals, this.restaurantImageUrl = ''});
}

class MealsError extends MealsState {
  final String message;
  MealsError({required this.message});
}

class MealDeleting extends MealsLoaded {
  final String mealId;
  MealDeleting({required super.meals, super.restaurantImageUrl = '', required this.mealId});
}

class MealDeleteSuccess extends MealsLoaded {
  MealDeleteSuccess({required super.meals, super.restaurantImageUrl = ''});
}

class MealDeleteError extends MealsLoaded {
  final String message;
  MealDeleteError({required super.meals, super.restaurantImageUrl = '', required this.message});
}
