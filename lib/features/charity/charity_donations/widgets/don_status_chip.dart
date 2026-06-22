import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:flutter/material.dart';
import '../../charity_resturants/widgets/colors_res.dart';

abstract class DonationStatusHelper {
  static String label(DonationStatus s) => switch (s) {
        DonationStatus.received => 'Received',
        DonationStatus.pending => 'Pending',
        DonationStatus.cancelled => 'Cancelled',
      };

  static Color color(DonationStatus s) => switch (s) {
        DonationStatus.received => AppColors.statusActive,
        DonationStatus.pending => AppColors.statusPending,
        DonationStatus.cancelled => AppColors.statusInactive,
      };
}

class DonationStatusChip extends StatelessWidget {
  final DonationStatus status;
  const DonationStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      DonationStatusHelper.label(status),
      style: TextStyle(
        color: DonationStatusHelper.color(status),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}