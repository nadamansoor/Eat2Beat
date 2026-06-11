import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/admin/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMeals(String token);
  
  Future<MealModel> addMeal({
    required String token,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String mealImgBase64,
  });

  Future<MealModel> updateMeal({
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
  });

  Future<void> deleteMeal({
    required String token,
    required String mealId,
  });

  Future<String> updateRestaurantImage({
    required String token,
    required String imgUrl,
  });
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final ApiService apiService;

  MealRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<MealModel>> getMeals(String token) async {
    final rawMeals = await apiService.getMeals(token);
    return rawMeals.map((m) => MealModel.fromJson(m)).toList();
  }

  @override
  Future<MealModel> addMeal({
    required String token,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String expiryTime,
    required String category,
    required String mealImgBase64,
  }) async {
    final body = {
      'title': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'expiry_time': expiryTime,
      'meal_img_base64': mealImgBase64,
      'category': category,
    };
    final rawMeal = await apiService.addMeal(token, body);
    return MealModel.fromJson(rawMeal);
  }

  @override
  Future<MealModel> updateMeal({
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
    final body = <String, dynamic>{
      'meal_id': mealId,
      'quantity': quantity,
      'price': price,
      'expiry_time': expiryTime.isNotEmpty ? expiryTime : null,
      'meal_img_url': mealImgBase64 ?? mealImgUrl,
      'title': name,
      'category': category,
    };
    final rawMeal = await apiService.updateMeal(token, body);

    // Worker may return {} or a partial response — reconstruct from request data
    // so the cubit always receives a valid entity.
    final merged = <String, dynamic>{
      'id': mealId,
      'title': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'expiry_time': expiryTime,
      'category': category,
      'meal_img_url': mealImgUrl ?? '',
      ...rawMeal, // override with whatever the server returned
    };
    return MealModel.fromJson(merged);
  }

  @override
  Future<void> deleteMeal({
    required String token,
    required String mealId,
  }) async {
    await apiService.deleteMeal(token, mealId);
  }

  @override
  Future<String> updateRestaurantImage({
    required String token,
    required String imgUrl,
  }) async {
    return await apiService.updateRestaurantImage(token, imgUrl);
  }
}
