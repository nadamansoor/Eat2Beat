class FoodModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final String sale;
  final double rate;
  final String time;
  int quantity;
  final String description;
  final String size;
  final String restruanteName;
  final String restauranteIcon;

  FoodModel({
    required this.restruanteName,
    required this.restauranteIcon,
    required this.size,
    required this.id,
    required this.name,
    required this.quantity,
    required this.image,
    required this.price,
    required this.sale,
    required this.rate,
    required this.description,
    required this.time,
  });
  double get totalPrice => price * quantity;
}
