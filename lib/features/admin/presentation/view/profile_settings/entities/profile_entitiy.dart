// lib/features/admin/domain/entities/profile_entity.dart

class ProfileEntity {
  final String restaurantName;
  final String email;
  final String phone;
  final String address;
  final bool isOpen;
  final bool notificationsEnabled;
  final String openTime;
  final String closeTime;
  final String language;
  final String? avatarPath;

  const ProfileEntity({
    required this.restaurantName,
    required this.email,
    required this.phone,
    required this.address,
    required this.isOpen,
    required this.notificationsEnabled,
    required this.openTime,
    required this.closeTime,
    required this.language,
    this.avatarPath,
  });

  ProfileEntity copyWith({
    String? restaurantName,
    String? email,
    String? phone,
    String? address,
    bool? isOpen,
    bool? notificationsEnabled,
    String? openTime,
    String? closeTime,
    String? language,
    String? avatarPath,
  }) {
    return ProfileEntity(
      restaurantName: restaurantName ?? this.restaurantName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isOpen: isOpen ?? this.isOpen,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      language: language ?? this.language,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}