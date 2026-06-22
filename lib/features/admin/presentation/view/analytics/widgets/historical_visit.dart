import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyPerformanceChart extends StatelessWidget {
  final List<ActualRow> actual;

  const WeeklyPerformanceChart({super.key, required this.actual});

  @override
  Widget build(BuildContext context) {
    if (actual.isEmpty) {
      return const SizedBox.shrink();
    }

    // Limit to the last 7 days to match the weekly view
    final dataToShow = actual.length > 7 ? actual.sublist(actual.length - 7) : actual;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Performance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '7 DAYS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart area
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dataToShow.map((row) {
                // Calculate height percentages based on max limits from Angular (orders: 90, sessions: 185, customers: 72)
                final double ordersHeightRatio = (row.orders / 90.0).clamp(0.02, 1.0);
                final double sessionsHeightRatio = (row.sessions / 185.0).clamp(0.02, 1.0);
                final double customersHeightRatio = (row.customers / 72.0).clamp(0.02, 1.0);

                final String dayLabel = DateFormat('E', 'en_US').format(row.date);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Orders Bar
                            _Bar(
                              ratio: ordersHeightRatio,
                              color: const Color(0xFF8966FA),
                              value: row.orders.toString(),
                            ),
                            // Sessions Bar
                            _Bar(
                              ratio: sessionsHeightRatio,
                              color: const Color(0xFF60A5FA),
                              value: row.sessions.toString(),
                            ),
                            // Customers Bar
                            _Bar(
                              ratio: customersHeightRatio,
                              color: const Color(0xFFFFC833),
                              value: row.customers.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dayLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          const Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _LegendItem(color: Color(0xFF8966FA), label: 'Orders'),
              _LegendItem(color: Color(0xFF60A5FA), label: 'Sessions'),
              _LegendItem(color: Color(0xFFFFC833), label: 'Unique Customers'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double ratio;
  final Color color;
  final String value;

  const _Bar({
    required this.ratio,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double barHeight = (availableHeight - 20).clamp(0.0, availableHeight) * ratio;
            return Tooltip(
              message: value,
              triggerMode: TooltipTriggerMode.tap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (barHeight > 15)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    height: barHeight.clamp(4.0, double.infinity),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
