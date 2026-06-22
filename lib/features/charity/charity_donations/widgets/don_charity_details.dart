import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_app_bar.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_info_bar.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_section_title.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_status_chip.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/statues_badge_bar.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class DonationDetailPage extends StatelessWidget {
  final DonationCharityModel donation;
  const DonationDetailPage({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          HeroAppBar(donation: donation),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Status badge
                StatusBadgeRow(status: donation.status),
                const SizedBox(height: 16),

                // Title block
                Text(donation.itemName,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22)),
                const SizedBox(height: 6),
                Text(donation.restaurantName,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 6),

                // Date + meals row
                Row(
                  children: [
                    Expanded(
                      child: Text(donation.timeLabel,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${donation.meals} meals',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Pickup details
                if (donation.pickupAddress.isNotEmpty) ...[
                  SectionTitle('Pickup Details'),
                  const SizedBox(height: 12),
                  InfoRow(
                      icon: Icons.location_on_outlined,
                      text: donation.pickupAddress),
                  const SizedBox(height: 8),
                  InfoRow(
                      icon: Icons.access_time_rounded,
                      text: donation.pickupHours),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                ],

                // Notes
                if (donation.notes.isNotEmpty) ...[
                  SectionTitle('Notes from Restaurant'),
                  const SizedBox(height: 10),
                  Text(donation.notes,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                ],

                // Received by
                if (donation.receivedBy.isNotEmpty) ...[
                  SectionTitle('Received by'),
                  const SizedBox(height: 10),
                  InfoRow(
                      icon: Icons.person_outline_rounded,
                      text: donation.receivedBy),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add this static helper to DonationStatusChip so detail page can reuse it
extension DonationStatusLabelExt on DonationStatusChip {
  static String statusLabel(DonationStatus s) => switch (s) {
        DonationStatus.received => 'Received',
        DonationStatus.pending => 'Pending',
        DonationStatus.cancelled => 'Cancelled',
      };
}