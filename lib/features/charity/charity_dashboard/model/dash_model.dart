import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';

class DashboardSummary {
  final int totalRequests;
  final int approved;
  final int pending;
  final int rejected;
  final int confirmed;

  const DashboardSummary({
    required this.totalRequests,
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.confirmed,
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