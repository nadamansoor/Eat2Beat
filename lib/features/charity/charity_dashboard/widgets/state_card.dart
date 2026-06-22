import 'package:eat2beat/features/charity/charity_dashboard/model/dash_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final DashboardSummary summary;
  const StatsRow({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 32 - 10) / 2;
    final fullWidth = width - 32;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: cardWidth,
          child: StatCard(
            value: '${summary.totalRequests}',
            label: 'Total Requests',
            color: AppColors.primary,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: StatCard(
            value: '${summary.approved}',
            label: 'Approved',
            color: const Color(0xFF00C853),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: StatCard(
            value: '${summary.pending}',
            label: 'Pending',
            color: const Color(0xFFFFC833),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: StatCard(
            value: '${summary.rejected}',
            label: 'Rejected',
            color: const Color(0xFFFF4D4D),
          ),
        ),
        SizedBox(
          width: fullWidth,
          child: StatCard(
            value: '${summary.confirmed}',
            label: 'Confirmed Pickups',
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  const StatCard({super.key, required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color ?? AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 24)),
          const SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }
}
