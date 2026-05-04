import 'package:flutter/material.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';


class OrderItemRow extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final Color dotColor;

  const OrderItemRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    this.dotColor = kPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$name × $quantity',
              style: const TextStyle(fontSize: 13, color: kText),
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}
