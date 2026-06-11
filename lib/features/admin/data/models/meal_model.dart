import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.quantity,
    required super.expiryTime,
    required super.category,
    required super.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else {
        parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
      }
    }

    int parsedQuantity = 0;
    if (json['quantity'] != null) {
      if (json['quantity'] is num) {
        parsedQuantity = (json['quantity'] as num).toInt();
      } else {
        parsedQuantity = int.tryParse(json['quantity'].toString()) ?? 0;
      }
    }

    return MealModel(
      id: json['id']?.toString() ?? json['meal_id']?.toString() ?? '',
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parsedPrice,
      quantity: parsedQuantity,
      expiryTime: json['expiry_time']?.toString() ?? json['expiryTime']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      imageUrl: json['meal_img_url']?.toString() ?? json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'expiry_time': expiryTime,
      'category': category,
      'meal_img_url': imageUrl,
    };
  }
}
