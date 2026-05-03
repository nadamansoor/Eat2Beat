
// ─── Customer Info ────────────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/orders/const.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  final String name;
  final String address;
  final String initials;
  final Color avatarColor;

  const CustomerInfo({
    super.key,
    required this.name,
    required this.address,
    required this.initials,
    this.avatarColor = const Color(0xFFFF8C42),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: avatarColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: avatarColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              address,
              style: const TextStyle(
                fontSize: 12,
                color: kMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
