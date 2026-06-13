class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final bool isOpen;
  final String openTime;
  final String closeTime;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  bool get isCurrentlyOpen => checkIsRestaurantOpen(
        isOpen: isOpen,
        openTime: openTime,
        closeTime: closeTime,
      );

  static int? parseTimeToMinutes(String timeStr) {
    try {
      timeStr = timeStr.trim().toUpperCase();
      final isPm = timeStr.contains('PM');
      final isAm = timeStr.contains('AM');

      String cleanStr = timeStr.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = cleanStr.split(':');
      if (parts.length < 2) return null;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (isPm && hour != 12) {
        hour += 12;
      } else if (isAm && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  static bool checkIsRestaurantOpen({
    required bool isOpen,
    required String openTime,
    required String closeTime,
  }) {
    if (!isOpen) return false;

    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;

    final openMin = parseTimeToMinutes(openTime);
    final closeMin = parseTimeToMinutes(closeTime);

    if (openMin == null || closeMin == null) {
      return isOpen;
    }

    if (closeMin >= openMin) {
      return nowMin >= openMin && nowMin <= closeMin;
    } else {
      // Overnight shift
      return nowMin >= openMin || nowMin <= closeMin;
    }
  }

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

    final isOpenVal = json['is_open'] ?? json['isOpen'];
    final bool isOpen;
    if (isOpenVal == null) {
      isOpen = true;
    } else {
      isOpen = isOpenVal == true ||
          isOpenVal == 1 ||
          isOpenVal?.toString() == 'true' ||
          isOpenVal?.toString() == '1';
    }

    final openTime = json['open_time']?.toString() ?? json['openTime']?.toString() ?? '09:00 AM';
    final closeTime = json['close_time']?.toString() ?? json['closeTime']?.toString() ?? '11:00 PM';

    return RestaurantModel(
      id: id,
      name: name,
      description: description,
      image: image,
      isOpen: isOpen,
      openTime: openTime,
      closeTime: closeTime,
    );
  }
}
