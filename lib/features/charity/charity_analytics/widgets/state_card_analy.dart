import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const StatCard({
    required this.value,
    required this.label,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 22)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}