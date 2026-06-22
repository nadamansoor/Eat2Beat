
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class HeroAppBar extends StatelessWidget {
  final DonationCharityModel donation;
  const HeroAppBar({required this.donation});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
      ),
      title: const Text('Donation Details',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18)),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Image.asset(
            donation.imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.primaryLight,
              child: const Icon(Icons.fastfood_outlined,
                  color: AppColors.primary, size: 64),
            ),
          ),
        ),
      ),
    );
  }
}