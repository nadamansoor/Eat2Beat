
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.volunteer_activism_outlined,
              size: 64, color: AppColors.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('No donations found',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}