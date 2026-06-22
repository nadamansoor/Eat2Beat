class ProfileModel {
  final String organizationName;
  final String organizationType;
  final String avatarAsset;

  const ProfileModel({
    required this.organizationName,
    required this.organizationType,
    this.avatarAsset = '',
  });
}

enum ProfileMenuItem {
  organizationInfo,
  teamMembers,
  settings,
  helpSupport,
  logout,
}