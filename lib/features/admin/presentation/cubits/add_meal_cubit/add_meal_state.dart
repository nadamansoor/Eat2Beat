sealed class AddMealState {}

class AddMealInitial extends AddMealState {}

class AddMealLoading extends AddMealState {}

class AddMealSuccess extends AddMealState {}

class AddMealError extends AddMealState {
  final String message;
  AddMealError({required this.message});
}

class AddMealImagePicked extends AddMealState {
  final String imagePath;
  final String base64Data;
  AddMealImagePicked({required this.imagePath, required this.base64Data});
}
