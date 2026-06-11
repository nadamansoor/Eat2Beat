enum DonationStatus { received, pending, cancelled }

class DonationCharityModel {
  final String id;
  final String itemName;
  final String restaurantName;
  final String imageAsset;
  final int meals;
  final String timeLabel;
  final DonationStatus status;

  // Detail-only fields
  final String pickupAddress;
  final String pickupHours;
  final String notes;
  final String receivedBy;

  const DonationCharityModel({
    required this.id,
    required this.itemName,
    required this.restaurantName,
    required this.imageAsset,
    required this.meals,
    required this.timeLabel,
    required this.status,
    this.pickupAddress = '',
    this.pickupHours = '',
    this.notes = '',
    this.receivedBy = '',
  });
}