
// ─────────────────────────────────────────────
//  DATA SUMMARY
// ─────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

class DataSummaryCard extends StatelessWidget {
  final DashboardData data;

  const DataSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
              const Text('Data Summary',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const Icon(Icons.content_copy_outlined, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Restaurant', value: data.restaurantId),
          _SummaryRow(label: 'Day Number', value: '(${data.dayNumber})'),
          _SummaryRow(label: 'Day Name', value: data.dayName),
          _SummaryRow(label: 'Is Weekend', value: data.isWeekend ? 'Yes' : 'No'),
          _SummaryRow(label: 'Is Holiday', value: data.isHoliday ? 'Yes' : 'No'),
          _SummaryRow(label: 'lag_7', value: '${data.visitorsLast7Days} visitors'),
          _SummaryRow(label: 'rolling_mean_7', value: '${data.sevenDayAverage.toStringAsFixed(1)} visitors'),
          _SummaryRow(label: 'Expected Visitors', value: '${data.todayVisitors} visitors'),
          _SummaryRow(label: 'Order Level', value: data.orderLevel.label, isLast: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _SummaryRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}