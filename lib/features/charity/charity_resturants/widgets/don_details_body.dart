import 'package:eat2beat/features/charity/charity_resturants/controllers/res_details_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_details_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/don_details_widgets_collection.dart';
import 'package:flutter/material.dart';

class DetailBody extends StatelessWidget {
  final RestaurantDetail detail;
  final RestaurantDetailController ctrl;
  const DetailBody({required this.detail, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final r = detail.restaurant;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // ── Hero card ──────────────────────────────────────────────────────
        HeroCard(detail: detail),
        const SizedBox(height: 14),

        // ── Stats row ──────────────────────────────────────────────────────
        StatsRow(detail: detail),
        const SizedBox(height: 14),

        // ── About ──────────────────────────────────────────────────────────
        SectionCard(
          title: 'About',
          child: Text(detail.about,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5)),
        ),
        const SizedBox(height: 10),

        // ── Pickup Information ─────────────────────────────────────────────
        SectionCard(
          title: 'Pickup Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconRow(
                  icon: Icons.access_time_rounded,
                  text: detail.pickupSchedule),
              const SizedBox(height: 8),
              IconRow(
                  icon: Icons.location_on_outlined, text: detail.address),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Contact ────────────────────────────────────────────────────────
        SectionCard(
          title: 'Contact Person',
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.contactName,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(detail.contactPhone,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: ctrl.callContact,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_rounded,
                      color: AppColors.primary, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Recent Donations ───────────────────────────────────────────────
        SectionCard(
          title: 'Recent Donations',
          trailing: TextButton(
            onPressed: ctrl.onViewAllDonations,
            child: const Text('View all',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
          child: detail.recentDonations.isEmpty
              ? const Text('No donations yet.',
                  style: TextStyle(color: AppColors.textSecondary))
              : Column(
                  children: detail.recentDonations
                      .map((d) => DonationTile(donation: d))
                      .toList(),
                ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
