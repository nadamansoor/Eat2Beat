import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  METRIC CARDS ROW
// ─────────────────────────────────────────────
class MetricCardsRow extends StatelessWidget {
  final int todayVisitors;
  final OrderLevel orderLevel;
  final double sevenDayAvg;
  final int visitorsLast7;

  const MetricCardsRow({
    super.key,
    required this.todayVisitors,
    required this.orderLevel,
    required this.sevenDayAvg,
    required this.visitorsLast7,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Forecast",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.push_pin_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'Key metrics for the dashboard',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.group_outlined,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
                title: "Today's Visitors",
                value: '$todayVisitors',
                valueColor: AppColors.primary,
                subtitle: 'Today Visitors',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
                title: 'Order Level',
                valueWidget: _OrderLevelBadge(level: orderLevel),
                subtitle: 'Auto Classification',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.green,
                iconBg: AppColors.greenLight,
                title: '7-Day Average',
                value: '${sevenDayAvg.toInt()}',
                valueColor: AppColors.green,
                subtitle: 'rolling_mean_7',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.sync_rounded,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
                title: 'Visitors Last 7 Days',
                value: '$visitorsLast7',
                valueColor: AppColors.orange,
                subtitle: 'lag_7',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? value;
  final Color? valueColor;
  final Widget? valueWidget;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.value,
    this.valueColor,
    this.valueWidget,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          if (valueWidget != null)
            valueWidget!
          else
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _OrderLevelBadge extends StatelessWidget {
  final OrderLevel level;

  const _OrderLevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    switch (level) {
      case OrderLevel.low:
        color = AppColors.green;
        bg = AppColors.greenLight;
        break;
      case OrderLevel.medium:
        color = AppColors.orange;
        bg = AppColors.orangeLight;
        break;
      case OrderLevel.high:
        color = AppColors.red;
        bg = AppColors.redLight;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            level.label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
