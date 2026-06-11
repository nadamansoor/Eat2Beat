// ─────────────────────────────────────────────
//  WEEK FORECAST
// ─────────────────────────────────────────────
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Quick Look — Next 7 Days',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              const Text('Forecast for the upcoming 7 days',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
            ]),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
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
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE').format(day.date).substring(0, 3),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Text(
            '${DateFormat('MMM').format(day.date)} ${day.date.day}',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.visitors}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
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
                      color: isSelected ? Colors.white : color),
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
