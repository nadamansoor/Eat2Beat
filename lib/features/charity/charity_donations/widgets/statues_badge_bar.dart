
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_status_chip.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class StatusBadgeRow extends StatelessWidget {
  final DonationStatus status;
  const StatusBadgeRow({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == DonationStatus.received
        ? AppColors.statusActive
        : status == DonationStatus.pending
            ? AppColors.statusPending
            : AppColors.statusInactive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == DonationStatus.received
                ? Icons.check_circle_outline_rounded
                : status == DonationStatus.pending
                    ? Icons.hourglass_top_rounded
                    : Icons.cancel_outlined,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
               DonationStatusHelper.label(status),
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}