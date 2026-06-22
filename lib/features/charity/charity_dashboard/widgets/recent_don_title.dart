
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_charity_details.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class RecentDonationTile extends StatelessWidget {
  final DonationCharityModel donation;
  const RecentDonationTile({required this.donation});

  static Color _color(DonationStatus s) => switch (s) {
        DonationStatus.received => AppColors.statusActive,
        DonationStatus.pending => AppColors.statusPending,
        DonationStatus.cancelled => AppColors.statusInactive,
      };

  static String _label(DonationStatus s) => switch (s) {
        DonationStatus.received => 'Received',
        DonationStatus.pending => 'Pending',
        DonationStatus.cancelled => 'Cancelled',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DonationDetailPage(donation: donation))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                donation.imageAsset,
                width: 58, height: 58, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 58, height: 58, color: AppColors.primaryLight,
                  child: const Icon(Icons.fastfood_outlined,
                      color: AppColors.primary, size: 24),
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
            Text(_label(donation.status),
                style: TextStyle(
                    color: _color(donation.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}