import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final MealEntity item;
  final bool isDeleting;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.item,
    this.isDeleting = false,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  Widget _buildPlaceholder() {
    return Container(
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
    );
  }

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
              child: item.imageUrl.startsWith('http')
                  ? Image.network(
                      item.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : Image.asset(
                      item.imageUrl.isNotEmpty ? item.imageUrl : 'assets/images/default_food.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
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
                    '\$${item.price.toStringAsFixed(2)}  ·  Qty: ${item.quantity}',
                    style: const TextStyle(fontSize: 11, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(width: 8),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onDelete != null) ...[
                const SizedBox(width: 12),
                isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.redAccent),
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
              ],
            ] else
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