import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekForecastCard extends StatelessWidget {
  final List<ForecastDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const WeekForecastCard({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'No forecast data available.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Forecast (Next 7 Days)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Predicted visitors and orders',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final day = days[i];
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: _ForecastDayCard(day: day, isSelected: isSelected),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ForecastDayCard extends StatelessWidget {
  final ForecastDay day;
  final bool isSelected;

  const _ForecastDayCard({required this.day, required this.isSelected});

  Color _levelColor(OrderLevel l) {
    switch (l) {
      case OrderLevel.low:
        return AppColors.green;
      case OrderLevel.medium:
        return AppColors.orange;
      case OrderLevel.high:
        return AppColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(day.orderLevel);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE', 'en_US').format(day.date).substring(0, 3),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Text(
            '${DateFormat('MMM', 'en_US').format(day.date)} ${day.date.day}',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          // Visitors
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 12,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${day.visitors}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Orders
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 12,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${day.predictedOrders}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.15) : color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  day.orderLevel.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
