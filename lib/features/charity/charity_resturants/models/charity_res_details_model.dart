
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';

class RecentDonation {
  final String id;
  final String itemName;
  final String imageAsset;
  final int meals;
  final String timeLabel; // e.g. "Today, 5:30 PM"
  final bool received;

  const RecentDonation({
    required this.id,
    required this.itemName,
    required this.imageAsset,
    required this.meals,
    required this.timeLabel,
    required this.received,
  });
}

class RestaurantDetail {
  final RestaurantModel restaurant;
  final int mealsThisMonth;
  final int reliabilityPercent;
  final String about;
  final String pickupSchedule;   // e.g. "Daily  5:00 PM – 7:00 PM"
  final String address;
  final String contactName;
  final String contactPhone;
  final String joinedDate;       // e.g. "May 2024"
  final List<RecentDonation> recentDonations;

  const RestaurantDetail({
    required this.restaurant,
    required this.mealsThisMonth,
    required this.reliabilityPercent,
    required this.about,
    required this.pickupSchedule,
    required this.address,
    required this.contactName,
    required this.contactPhone,
    required this.joinedDate,
    required this.recentDonations,
  });
}