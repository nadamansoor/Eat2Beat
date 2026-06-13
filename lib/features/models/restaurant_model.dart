class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String image;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['restaurant_id']?.toString() ?? '';
    final name = json['name']?.toString() ??
        json['full_name']?.toString() ??
        json['restaurant_name']?.toString() ??
        'Restaurant';
    final description = json['description']?.toString() ??
        json['rest_description']?.toString() ??
        '';
    final imgUrl = json['img_url']?.toString() ?? '';
    final restImgUrl = json['rest_img_url']?.toString() ?? '';
    final image = imgUrl.isNotEmpty ? imgUrl : (restImgUrl.isNotEmpty ? restImgUrl : '');

    return RestaurantModel(
      id: id,
      name: name,
      description: description,
      image: image,
    );
  }
}
