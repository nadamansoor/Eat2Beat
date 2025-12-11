import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/food_model.dart';

class FoodService {
  Future<List<FoodModel>> getFoods() async {
    final jsonString = await rootBundle.loadString("assets/data.json");
    final List list = json.decode(jsonString);
    return list.map((e) => FoodModel.fromJson(e)).toList();
  }

  Future<FoodModel> getFoodDetails(String id) async {
    final foods = await getFoods();
    return foods.firstWhere((element) => element.id == id);
  }

  Future<List<FoodModel>> search(String q) async {
    final foods = await getFoods();
    return foods
        .where((f) => f.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
  }
}
