import '../domain/food_item.dart';

class FoodModel extends FoodItem {
  FoodModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.rating,
    required super.time,
    required super.description,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      rating: json['rating'],
      time: json['time'],
      description: json['description'],
    );
  }
}
