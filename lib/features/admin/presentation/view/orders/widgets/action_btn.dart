// ─── Action Buttons ───────────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/orders/const.dart';
import 'package:flutter/material.dart';

class OrderActionButtons extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onMarkReady;

  const OrderActionButtons({
    super.key,
    this.onCancel,
    this.onMarkReady,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: kRedBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kRed.withOpacity(0.3)),
              ),
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kRed,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Mark as Ready
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: onMarkReady,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Text(
                'Mark as Ready',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}