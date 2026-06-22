class MealEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String expiryTime;
  final String category;
  final String imageUrl;
  final String? cuisine;
  final List<String>? tags;
  final bool hasActiveOffer;

  const MealEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.expiryTime,
    required this.category,
    required this.imageUrl,
    this.cuisine,
    this.tags,
    this.hasActiveOffer = false,
  });
}
