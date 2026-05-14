import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/status_badge.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/entities/food_item.dart';
import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;

  const FoodItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imageAsset,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EFF9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_outlined,
                    color: kPrimary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.calories} cal  ·  ${item.protein}g protein',
                    style: const TextStyle(fontSize: 11, color: kMuted),
                  ),

                  const SizedBox(height: 8),
                  MealStatusBadge(status: item.status),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: kMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}