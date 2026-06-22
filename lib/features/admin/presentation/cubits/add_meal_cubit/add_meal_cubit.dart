import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eat2beat/features/admin/domain/usecases/add_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/add_offer_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_restaurant_meals_usecase.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'add_meal_state.dart';

class AddMealCubit extends Cubit<AddMealState> {
  final AuthRepo authRepo;
  final AddMealUseCase addMealUseCase;
  final AddOfferUseCase addOfferUseCase;
  final GetRestaurantMealsUseCase getMealsUseCase;
  final ImagePicker _picker = ImagePicker();

  String? _pickedImageBase64;
  String? _pickedImagePath;
  List<MealEntity> _meals = [];

  String? get pickedImagePath => _pickedImagePath;
  String? get pickedImageBase64 => _pickedImageBase64;
  List<MealEntity> get meals => _meals;

  AddMealCubit({
    required this.authRepo,
    required this.addMealUseCase,
    required this.addOfferUseCase,
    required this.getMealsUseCase,
  }) : super(AddMealInitial());

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
        imageQuality: 70,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final mimeType = _mimeTypeFromPath(image.path);
        final rawBase64 = base64Encode(bytes);
        // Build Data URI exactly like Angular's FileReader.readAsDataURL()
        _pickedImageBase64 = 'data:$mimeType;base64,$rawBase64';
        _pickedImagePath = image.path;
        emit(AddMealImagePicked(imagePath: image.path, base64Data: _pickedImageBase64!));
      }
    } catch (e) {
      emit(AddMealError(message: 'Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> addMeal({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    String? cuisine,
    List<String>? tags,
  }) async {
    if (_pickedImageBase64 == null) {
      emit(AddMealError(message: 'Please pick a meal image before publishing.'));
      return;
    }

    emit(AddMealLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(AddMealError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    final result = await addMealUseCase(
      token: token,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      expiryTime: expiryTime,
      category: category,
      mealImgBase64: _pickedImageBase64!,
      cuisine: cuisine,
      tags: tags,
    );

    result.fold(
      (failure) => emit(AddMealError(message: failure.message)),
      (_) => emit(AddMealSuccess()),
    );
  }

  Future<void> fetchMeals() async {
    emit(AddMealsLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(AddMealError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    final result = await getMealsUseCase(token);
    result.fold(
      (failure) => emit(AddMealError(message: failure.message)),
      (mealsList) {
        _meals = mealsList;
        emit(AddMealMealsLoaded(mealsList));
      },
    );
  }

  Future<void> addOffer({
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
  }) async {
    emit(AddMealLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(AddMealError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    final imgUrlToSend = _pickedImageBase64 ?? offerImgUrl;

    final result = await addOfferUseCase(
      token: token,
      mealId: mealId,
      title: title,
      description: description,
      offerImgUrl: imgUrlToSend,
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

    result.fold(
      (failure) => emit(AddMealError(message: failure.message)),
      (_) => emit(AddOfferSuccess()),
    );
  }

  void reset() {
    _pickedImageBase64 = null;
    _pickedImagePath = null;
    emit(AddMealInitial());
  }
}
