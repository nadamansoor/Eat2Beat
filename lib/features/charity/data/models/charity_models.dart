class CharityProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? logoUrl;
  final String? website;

  CharityProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.logoUrl,
    this.website,
  });

  factory CharityProfile.fromJson(Map<String, dynamic> json) {
    final charityJson = json['charity'] as Map<String, dynamic>?;
    return CharityProfile(
      id: json['profile_id']?.toString() ?? '',
      name: charityJson?['name']?.toString() ?? json['full_name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: charityJson?['phone']?.toString(),
      address: charityJson?['address']?.toString(),
      description: charityJson?['description']?.toString(),
      logoUrl: charityJson?['charity_img_url']?.toString(),
      website: charityJson?['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (description != null) 'description': description,
      if (logoUrl != null) 'charity_img_url': logoUrl,
      if (website != null) 'website': website,
    };
  }
}

class DonationItem {
  final String itemId;
  final String donationId;
  final String itemName;
  final int quantity;
  final String donationItemImg;
  final String? description;

  DonationItem({
    required this.itemId,
    required this.donationId,
    required this.itemName,
    required this.quantity,
    required this.donationItemImg,
    this.description,
  });

  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      itemId: json['item_id']?.toString() ?? json['id']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      donationItemImg: json['donation_item_img']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

class AvailableDonation {
  final String id;
  final String restaurantId;
  final String createdAt;
  final String donationImgUrl;
  final String pickedUp;
  final bool isAvailable;
  final String? description;
  final String? pickupLocation;
  final String? restaurantName;
  final List<DonationItem>? items;

  AvailableDonation({
    required this.id,
    required this.restaurantId,
    required this.createdAt,
    required this.donationImgUrl,
    required this.pickedUp,
    required this.isAvailable,
    this.description,
    this.pickupLocation,
    this.restaurantName,
    this.items,
  });

  factory AvailableDonation.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>?;
    List<DonationItem>? parsedItems = itemsList != null
        ? itemsList.map((item) => DonationItem.fromJson(item)).toList()
        : null;

    return AvailableDonation(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      donationImgUrl: json['donation_img_url']?.toString() ?? '',
      pickedUp: json['picked_up']?.toString() ?? 'pending',
      isAvailable: json['is_available'] as bool? ?? true,
      description: json['description']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      restaurantName: json['restaurant_name']?.toString(),
      items: parsedItems,
    );
  }
}

class PickupRequest {
  final String id;
  final String status; // pending / approved / rejected
  final String createdAt;
  final String updatedAt;
  final String donationId;
  final String? donationImgUrl;
  final String? restaurantId;
  final String? pickedUp;
  final bool? isAvailable;
  final String? description;
  final String? pickupLocation;
  final String? restaurantName;

  PickupRequest({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.donationId,
    this.donationImgUrl,
    this.restaurantId,
    this.pickedUp,
    this.isAvailable,
    this.description,
    this.pickupLocation,
    this.restaurantName,
  });

  factory PickupRequest.fromJson(Map<String, dynamic> json) {
    return PickupRequest(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? json['created_at']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? '',
      donationImgUrl: json['donation_img_url']?.toString(),
      restaurantId: json['restaurant_id']?.toString(),
      pickedUp: json['picked_up']?.toString(),
      isAvailable: json['is_available'] as bool?,
      description: json['description']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      restaurantName: json['restaurant_name']?.toString(),
    );
  }
}

class PickupSchedule {
  final String id;
  final String scheduledAt;
  final String? notes;
  final String status;
  final String? confirmedAt;
  final String createdAt;
  final String updatedAt;
  final String? restaurantName;
  final String? description;
  final String? pickupLocation;

  PickupSchedule({
    required this.id,
    required this.scheduledAt,
    this.notes,
    required this.status,
    this.confirmedAt,
    required this.createdAt,
    required this.updatedAt,
    this.restaurantName,
    this.description,
    this.pickupLocation,
  });

  factory PickupSchedule.fromJson(Map<String, dynamic> json) {
    final pr = json['pickup_requests'] as Map<String, dynamic>?;
    final don = pr?['donations'] as Map<String, dynamic>?;
    final rest = don?['restaurants'] as Map<String, dynamic>?;

    return PickupSchedule(
      id: json['id']?.toString() ?? '',
      scheduledAt: json['scheduled_at']?.toString() ?? '',
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      confirmedAt: json['confirmed_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      restaurantName: rest?['name']?.toString(),
      description: don?['description']?.toString(),
      pickupLocation: don?['pickup_location']?.toString(),
    );
  }
}

class CharityStats {
  final int totalRequests;
  final int totalApproved;
  final int totalRejected;
  final int totalPending;
  final int totalConfirmed;

  CharityStats({
    required this.totalRequests,
    required this.totalApproved,
    required this.totalRejected,
    required this.totalPending,
    required this.totalConfirmed,
  });

  factory CharityStats.fromJson(Map<String, dynamic> json) {
    return CharityStats(
      totalRequests: json['total_requests'] as int? ?? 0,
      totalApproved: json['total_approved'] as int? ?? 0,
      totalRejected: json['total_rejected'] as int? ?? 0,
      totalPending: json['total_pending'] as int? ?? 0,
      totalConfirmed: json['total_confirmed'] as int? ?? 0,
    );
  }
}

class PartnerRestaurant {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final String? imgUrl;
  final bool acceptingOrders;
  final List<AvailableDonation>? donations;

  PartnerRestaurant({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.imgUrl,
    required this.acceptingOrders,
    this.donations,
  });

  factory PartnerRestaurant.fromJson(Map<String, dynamic> json) {
    var dons = json['donations'] as List<dynamic>?;
    List<AvailableDonation>? parsedDons = dons != null
        ? dons.map((d) => AvailableDonation.fromJson(d)).toList()
        : null;

    return PartnerRestaurant(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      imgUrl: json['img_url']?.toString() ?? json['rest_img_url']?.toString(),
      acceptingOrders: json['accepting_orders'] as bool? ?? true,
      donations: parsedDons,
    );
  }
}
