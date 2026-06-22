enum RestaurantStatus { active, pending, inactive }

class RestaurantModel {
  final String id;
  final String name;
  final String location;
  final int mealsDoanted;
  final RestaurantStatus status;
  final String imageAsset; // e.g. 'assets/images/cafe.jpg'

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.location,
    required this.mealsDoanted,
    required this.status,
    required this.imageAsset,
  });
}