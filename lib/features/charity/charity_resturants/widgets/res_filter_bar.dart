import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class RestaurantFilterBar extends StatelessWidget {
  final RestaurantStatus? selected;
  final ValueChanged<RestaurantStatus?> onSelected;

  const RestaurantFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _filters = <(String, RestaurantStatus?)>[
    ('All', null),
    ('Active', RestaurantStatus.active),
    ('Pending', RestaurantStatus.pending),
    ('Inactive', RestaurantStatus.inactive),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (label, value) = _filters[i];
          final isSelected = selected == value;
          return FilterChip(
            label: label,
            isSelected: isSelected,
            onTap: () => onSelected(value),
          );
        },
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryChipText,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}