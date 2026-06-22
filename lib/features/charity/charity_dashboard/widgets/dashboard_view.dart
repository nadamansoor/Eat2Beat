import 'package:eat2beat/features/charity/charity_dashboard/controllers/dash_controller.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/dash_header.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/recent_don_title.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/search_don.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/state_card.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const DashboardView({this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DashboardController>();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: ctrl.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: ctrl.refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  children: [
                    Header(ctrl: ctrl, onProfileTap: onProfileTap),
                    const SizedBox(height: 20),
                    SearchCharityBar(onChanged: ctrl.setSearchQuery),
                    const SizedBox(height: 20),
                    StatsRow(summary: ctrl.data!.summary),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Recent Donations',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => ctrl.onViewAllDonations(context),
                          child: const Text('View all',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...ctrl.data!.recentDonations
                        .map((d) => RecentDonationTile(donation: d)),
                  ],
                ),
              ),
      ),
    );
  }
}