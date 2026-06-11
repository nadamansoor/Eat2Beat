
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final dynamic summary;
  const StatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(value: '${summary.activeRestaurants}', label: 'Active\nRestaurants'),
        const SizedBox(width: 10),
        StatCard(value: '${summary.todaysDonations}', label: "Today's\nDonations"),
        const SizedBox(width: 10),
        StatCard(value: '${summary.mealsReceived}', label: 'Meals\nReceived'),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  const StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 24)),
            const SizedBox(height: 5),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
