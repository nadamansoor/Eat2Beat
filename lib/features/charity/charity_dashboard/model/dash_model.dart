import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';

class DashboardSummary {
  final int activeRestaurants;
  final int todaysDonations;
  final int mealsReceived;

  const DashboardSummary({
    required this.activeRestaurants,
    required this.todaysDonations,
    required this.mealsReceived,
  });
}

class DashboardData {
  final DashboardSummary summary;
  final List<DonationCharityModel> recentDonations;

  const DashboardData({
    required this.summary,
    required this.recentDonations,
  });
}