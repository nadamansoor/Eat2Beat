import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_restaurant_meals_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/delete_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_restaurant_image_usecase.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  final AuthRepo authRepo;
  final GetRestaurantMealsUseCase getRestaurantMealsUseCase;
  final DeleteMealUseCase deleteMealUseCase;
  final UpdateRestaurantImageUseCase updateRestaurantImageUseCase;

  MealsCubit({
    required this.authRepo,
    required this.getRestaurantMealsUseCase,
    required this.deleteMealUseCase,
    required this.updateRestaurantImageUseCase,
  }) : super(MealsInitial());

  Future<void> loadMeals() async {
    emit(MealsLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(MealsError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    final result = await getRestaurantMealsUseCase(token);
    result.fold(
      (failure) => emit(MealsError(message: failure.message)),
      (meals) => emit(MealsLoaded(meals: meals)),
    );
  }

  Future<void> deleteMeal(String mealId) async {
    final currentState = state;
    if (currentState is! MealsLoaded) return;

    final currentMeals = currentState.meals;
    final currentImgUrl = currentState.restaurantImageUrl;

    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(MealDeleteError(
        meals: currentMeals,
        restaurantImageUrl: currentImgUrl,
        message: 'Authentication failed. Please sign in again.',
      ));
      return;
    }

    emit(MealDeleting(
      meals: currentMeals,
      restaurantImageUrl: currentImgUrl,
      mealId: mealId,
    ));
    final result = await deleteMealUseCase(token: token, mealId: mealId);

    result.fold(
      (failure) => emit(MealDeleteError(
        meals: currentMeals,
        restaurantImageUrl: currentImgUrl,
        message: failure.message,
      )),
      (_) async {
        final updatedMeals = currentMeals.where((m) => m.id != mealId).toList();
        emit(MealDeleteSuccess(
          meals: updatedMeals,
          restaurantImageUrl: currentImgUrl,
        ));
        // Reload meals after successful deletion to ensure complete sync
        await loadMeals();
      },
    );
  }

  Future<void> updateRestaurantImage(String imgUrl) async {
    final currentState = state;
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final result = await updateRestaurantImageUseCase(token: token, imgUrl: imgUrl);
    result.fold(
      (failure) {
        // Silently fail or ignore for simple update
      },
      (newUrl) {
        if (currentState is MealsLoaded) {
          emit(MealsLoaded(meals: currentState.meals, restaurantImageUrl: newUrl));
        }
      },
    );
  }
}
