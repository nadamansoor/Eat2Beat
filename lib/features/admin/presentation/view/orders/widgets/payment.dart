
// ─── Payment Row ──────────────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/orders/const.dart';
import 'package:flutter/material.dart';

class PaymentRow extends StatelessWidget {
  final String method;
  final bool isPaid;

  const PaymentRow({
    super.key,
    required this.method,
    this.isPaid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              'VISA',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            method,
            style: const TextStyle(fontSize: 13, color: kText),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPaid ? kGreenBg : kRedBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isPaid ? 'Paid' : 'Pending',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPaid ? kGreen : kRed,
            ),
          ),
        ),
      ],
    );
  }
}

