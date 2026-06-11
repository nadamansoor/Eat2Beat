import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_status_chip.dart';
import 'package:flutter/material.dart';
import '../../charity_resturants/widgets/colors_res.dart';

class DonationListTile extends StatelessWidget {
  final DonationCharityModel donation;
  final VoidCallback onTap;

  const DonationListTile({
    super.key,
    required this.donation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                donation.imageAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.fastfood_outlined,
                      color: AppColors.primary, size: 26),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donation.itemName,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(donation.restaurantName,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('${donation.meals} meals  •  ${donation.timeLabel}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            DonationStatusChip(status: donation.status),
          ],
        ),
      ),
    );
  }
}