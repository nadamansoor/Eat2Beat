import 'package:eat2beat/features/charity/charity_analytics/controllers/analy_charity_controllers.dart';
import 'package:eat2beat/features/charity/charity_analytics/widgets/data_range.dart';
import 'package:eat2beat/features/charity/charity_analytics/widgets/meals_line_draw.dart';
import 'package:eat2beat/features/charity/charity_analytics/widgets/state_card_analy.dart';
import 'package:eat2beat/features/charity/charity_analytics/widgets/top_res.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final AnalyticsController ctrl;
  const Body({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final data = ctrl.data!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        // ── Date range picker ───────────────────────────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: DateRangeDropdown(ctrl: ctrl),
        ),
        const SizedBox(height: 16),

        // ── Summary stats row ───────────────────────────────────────────────
        Row(
          children: [
            StatCard(
                value: '${data.summary.totalDonations}',
                label: 'Total Donations'),
            const SizedBox(width: 10),
            StatCard(
                value: '${data.summary.totalMeals}',
                label: 'Total Meals',
                valueColor: AppColors.primary),
            const SizedBox(width: 10),
            StatCard(
                value: '${data.summary.activeRestaurants}',
                label: 'Active Restaurants'),
          ],
        ),
        const SizedBox(height: 16),

        // ── Chart card ──────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Meals Received Over Time',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: MealsLineChart(
                    key: ValueKey(ctrl.selectedRange),
                    points: data.chartPoints),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Top Restaurants ─────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top Restaurants',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              const SizedBox(height: 12),
              ...data.topRestaurants
                  .asMap()
                  .entries
                  .map((e) => TopRestaurantRow(
                      rank: e.key + 1, restaurant: e.value)),
            ],
          ),
        ),
      ],
    );
  }
}