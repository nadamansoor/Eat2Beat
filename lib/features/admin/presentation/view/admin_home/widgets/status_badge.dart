import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MealStatusBadge extends StatelessWidget {
  final ApprovalStatus status;

  const MealStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final data = switch (status) {
      ApprovalStatus.approved => (
          '✓  Approved',
          const Color(0xFF10B981),
          const Color(0xFFECFDF5)
        ),
      ApprovalStatus.pending => (
          '⏳  Pending',
          const Color(0xFFF59E0B),
          const Color(0xFFFFFBEB)
        ),
      ApprovalStatus.rejected => (
          '✕  Rejected',
          const Color(0xFFEF4444),
          const Color(0xFFFEF2F2)
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: data.$3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data.$1,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: data.$2,
        ),
      ),
    );
  }
}