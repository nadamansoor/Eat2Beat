
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5))),
        ],
      );
}