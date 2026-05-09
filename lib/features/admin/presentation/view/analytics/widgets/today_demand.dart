import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

class TodaysDemandCard extends StatelessWidget {
  final DateTime date;
  final OrderLevel orderLevel;

  const TodaysDemandCard({super.key, required this.date, required this.orderLevel});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  Map<String, dynamic> _levelInfo(OrderLevel level) {
    switch (level) {
      case OrderLevel.low:
        return {
          'color': AppColors.green,
          'desc': 'Expected low demand. Light preparation required — standard operations.',
          'tags': ['Light Prep', 'Minimal Staff', 'Standard Flow'],
        };
      case OrderLevel.medium:
        return {
          'color': AppColors.orange,
          'desc':
              'Expected moderate demand. Maintain standard preparation and increase team efficiency during peak hours.',
          'tags': ['Standard Prep', 'Monitor Flow', 'Prepare Backup Team', 'Follow Orders'],
        };
      case OrderLevel.high:
        return {
          'color': AppColors.red,
          'desc':
              'High demand expected. Full team deployment and maximum preparation required.',
          'tags': ['Full Team', 'Max Prep', 'Priority Queue', 'All Stations Active'],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _levelInfo(orderLevel);
    final Color color = info['color'] as Color;
    final List<String> tags = info['tags'] as List<String>;

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
            children: [
              Text(
                "Today's Demand: ",
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                orderLevel.label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(width: 6),
              Container(
                  width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const Spacer(),
              Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(_formatDate(date),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            info['desc'] as String,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
