class AdminDonationItem {
  final String id;
  final String donationId;
  final String itemName;
  final int quantity;
  final String donationItemImg;
  final String? description;

  AdminDonationItem({
    required this.id,
    required this.donationId,
    required this.itemName,
    required this.quantity,
    required this.donationItemImg,
    this.description,
  });

  factory AdminDonationItem.fromJson(Map<String, dynamic> json) {
    return AdminDonationItem(
      id: json['id']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      donationItemImg: json['donation_item_img']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

class AdminDonation {
  final String id;
  final String restaurantId;
  final String createdAt;
  final String donationImgUrl;
  final String pickedUp;
  final bool isAvailable;
  final String? description;
  final String? pickupLocation;
  final List<AdminDonationItem>? items;

  AdminDonation({
    required this.id,
    required this.restaurantId,
    required this.createdAt,
    required this.donationImgUrl,
    required this.pickedUp,
    required this.isAvailable,
    this.description,
    this.pickupLocation,
    this.items,
  });

  factory AdminDonation.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>?;
    List<AdminDonationItem>? parsedItems = itemsList != null
        ? itemsList.map((item) => AdminDonationItem.fromJson(item)).toList()
        : null;

    return AdminDonation(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      donationImgUrl: json['donation_img_url']?.toString() ?? '',
      pickedUp: json['picked_up']?.toString() ?? 'pending',
      isAvailable: json['is_available'] as bool? ?? true,
      description: json['description']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      items: parsedItems,
    );
  }
}

class AdminPickupRequest {
  final String id;
  final String status; // pending / approved / rejected
  final String createdAt;
  final String updatedAt;
  final String donationId;
  final String? charityId;
  final String? charityName;
  final String? donationImgUrl;
  final String? pickedUp;
  final bool? isAvailable;
  final String? description;
  final String? pickupLocation;

  AdminPickupRequest({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.donationId,
    this.charityId,
    this.charityName,
    this.donationImgUrl,
    this.pickedUp,
    this.isAvailable,
    this.description,
    this.pickupLocation,
  });

  factory AdminPickupRequest.fromJson(Map<String, dynamic> json) {
    return AdminPickupRequest(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? json['created_at']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? '',
      charityId: json['charity_id']?.toString(),
      charityName: json['charity_name']?.toString(),
      donationImgUrl: json['donation_img_url']?.toString(),
      pickedUp: json['picked_up']?.toString(),
      isAvailable: json['is_available'] as bool?,
      description: json['description']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
    );
  }
}

class AdminPickupSchedule {
  final String id;
  final String scheduledAt;
  final String? notes;
  final String status;
  final String? confirmedAt;
  final String createdAt;
  final String updatedAt;
  final String? donationId;
  final String? pickupId;
  final String? donationImgUrl;
  final String? description;
  final String? pickupLocation;
  final String? charityId;
  final String? charityName;

  AdminPickupSchedule({
    required this.id,
    required this.scheduledAt,
    this.notes,
    required this.status,
    this.confirmedAt,
    required this.createdAt,
    required this.updatedAt,
    this.donationId,
    this.pickupId,
    this.donationImgUrl,
    this.description,
    this.pickupLocation,
    this.charityId,
    this.charityName,
  });

  factory AdminPickupSchedule.fromJson(Map<String, dynamic> json) {
    final pr = json['pickup_requests'] as Map<String, dynamic>?;
    final don = pr?['donations'] as Map<String, dynamic>?;
    // Note: the backend might not always join charity profile inside this object directly.
    // If it does, we extract it.
    final charityName = pr?['charity_name']?.toString() ?? json['charity_name']?.toString();
    final charityId = pr?['charity_id']?.toString() ?? json['charity_id']?.toString();

    return AdminPickupSchedule(
      id: json['id']?.toString() ?? '',
      scheduledAt: json['scheduled_at']?.toString() ?? '',
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      confirmedAt: json['confirmed_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      donationId: don?['id']?.toString() ?? pr?['donation_id']?.toString(),
      pickupId: pr?['id']?.toString(),
      donationImgUrl: don?['donation_img_url']?.toString(),
      description: don?['description']?.toString(),
      pickupLocation: don?['pickup_location']?.toString(),
      charityId: charityId,
      charityName: charityName,
    );
  }
}

class AdminCharityProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? logoUrl;
  final String? website;
  final String createdAt;

  AdminCharityProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.logoUrl,
    this.website,
    required this.createdAt,
  });

  factory AdminCharityProfile.fromJson(Map<String, dynamic> json) {
    // Search endpoint returns charity info directly or nested inside a charity map
    final charityMap = json['charity'] as Map<String, dynamic>?;
    
    return AdminCharityProfile(
      id: json['profile_id']?.toString() ?? json['id']?.toString() ?? '',
      name: charityMap?['name']?.toString() ?? json['name']?.toString() ?? json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? charityMap?['email']?.toString(),
      phone: charityMap?['phone']?.toString() ?? json['phone']?.toString(),
      address: charityMap?['address']?.toString() ?? json['address']?.toString(),
      description: charityMap?['description']?.toString() ?? json['description']?.toString(),
      logoUrl: json['charity_img_url']?.toString() ?? charityMap?['charity_img_url']?.toString() ?? json['logo_url']?.toString(),
      website: charityMap?['website']?.toString() ?? json['website']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class AdminNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? linkPath;
  final String? readAt;
  final String createdAt;

  AdminNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.linkPath,
    this.readAt,
    required this.createdAt,
  });

  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    return AdminNotification(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      linkPath: json['link_path']?.toString(),
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
