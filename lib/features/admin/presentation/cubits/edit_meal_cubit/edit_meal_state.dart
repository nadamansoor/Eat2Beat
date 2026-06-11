sealed class EditMealState {}

class EditMealInitial extends EditMealState {}

class EditMealLoading extends EditMealState {}

class EditMealSuccess extends EditMealState {}

class EditMealError extends EditMealState {
  final String message;
  EditMealError({required this.message});
}

class MealImagePicked extends EditMealState {
  final String imagePath;
  final String base64Data;
  MealImagePicked({required this.imagePath, required this.base64Data});
}
