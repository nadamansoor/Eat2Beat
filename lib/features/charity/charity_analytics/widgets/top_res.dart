import 'package:eat2beat/features/charity/charity_analytics/models/analytics_charity_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class TopRestaurantRow extends StatelessWidget {
  final int rank;
  final TopRestaurant restaurant;
  const TopRestaurantRow({required this.rank, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              restaurant.imageAsset,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                color: AppColors.primaryLight,
                child: const Icon(Icons.restaurant,
                    color: AppColors.primary, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(restaurant.name,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
          Text('${restaurant.meals} meals',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}