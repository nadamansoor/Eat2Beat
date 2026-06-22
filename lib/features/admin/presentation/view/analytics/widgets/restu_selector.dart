import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:flutter/material.dart';

class RestaurantSelector extends StatelessWidget {
  final String restaurantId;
  final int days;
  final VoidCallback onRefresh;
  final ValueChanged<int> onDaysChanged;

  const RestaurantSelector({
    super.key,
    required this.restaurantId,
    required this.days,
    required this.onRefresh,
    required this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Restaurant ID',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            restaurantId,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Days Selector Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.date_range_rounded, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 6),
                  Text(
                    'Timeframe:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  _DaysChip(
                    label: '7d',
                    selected: days == 7,
                    onTap: () => onDaysChanged(7),
                  ),
                  const SizedBox(width: 6),
                  _DaysChip(
                    label: '14d',
                    selected: days == 14,
                    onTap: () => onDaysChanged(14),
                  ),
                  const SizedBox(width: 6),
                  _DaysChip(
                    label: '30d',
                    selected: days == 30,
                    onTap: () => onDaysChanged(30),
                  ),
                  const SizedBox(width: 8),
                  // Custom Day Picker Dropdown
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: [7, 14, 30].contains(days) ? null : days,
                        hint: Text(
                          [7, 14, 30].contains(days) ? 'Custom' : '${days}d',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.primary),
                        items: List.generate(28, (index) => index + 3).map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('${val} days', style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) {
                            onDaysChanged(newVal);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DaysChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DaysChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
