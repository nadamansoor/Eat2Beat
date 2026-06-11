import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_meal_usecase.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'edit_meal_state.dart';

class EditMealCubit extends Cubit<EditMealState> {
  final AuthRepo authRepo;
  final UpdateMealUseCase updateMealUseCase;
  final ImagePicker _picker = ImagePicker();
  
  String? _pickedImageBase64;
  String? _pickedImagePath;

  String? get pickedImagePath => _pickedImagePath;
  String? get pickedImageBase64 => _pickedImageBase64;

  EditMealCubit({
    required this.authRepo,
    required this.updateMealUseCase,
  }) : super(EditMealInitial());

  /// Detect MIME type from file extension (supports jpg, jpeg, png, webp).
  String _mimeTypeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compressing for smaller payload
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        final mimeType = _mimeTypeFromPath(image.path);
        final rawBase64 = base64Encode(bytes);
        // Build Data URI exactly like Angular's FileReader.readAsDataURL()
        _pickedImageBase64 = 'data:$mimeType;base64,$rawBase64';
        _pickedImagePath = image.path;
        emit(MealImagePicked(imagePath: image.path, base64Data: _pickedImageBase64!));
      }
    } catch (e) {
      emit(EditMealError(message: 'Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> updateMeal({
    required String mealId,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String? originalImageUrl,
  }) async {
    emit(EditMealLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(EditMealError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    final result = await updateMealUseCase(
      token: token,
      mealId: mealId,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      expiryTime: expiryTime,
      category: category,
      mealImgBase64: _pickedImageBase64,
      mealImgUrl: _pickedImageBase64 != null ? null : originalImageUrl,
    );

    result.fold(
      (failure) => emit(EditMealError(message: failure.message)),
      (_) => emit(EditMealSuccess()),
    );
  }
}
