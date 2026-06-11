import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class RestaurantListTile extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const RestaurantListTile({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                restaurant.imageAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Text info ───────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    restaurant.location,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${restaurant.mealsDoanted} meals donated',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ── Status badge ────────────────────────────────────────────────
            StatusBadge(status: restaurant.status),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final RestaurantStatus status;
  const StatusBadge({required this.status});

  static String _label(RestaurantStatus s) => switch (s) {
        RestaurantStatus.active => 'Active',
        RestaurantStatus.pending => 'Pending',
        RestaurantStatus.inactive => 'Inactive',
      };

  static Color _color(RestaurantStatus s) => switch (s) {
        RestaurantStatus.active => AppColors.statusActive,
        RestaurantStatus.pending => AppColors.statusPending,
        RestaurantStatus.inactive => AppColors.statusInactive,
      };

  @override
  Widget build(BuildContext context) {
    return Text(
      _label(status),
      style: TextStyle(
        color: _color(status),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}