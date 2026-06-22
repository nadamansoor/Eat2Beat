import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  METRIC CARDS ROW
// ─────────────────────────────────────────────
class MetricCardsRow extends StatelessWidget {
  final int todayVisitors;
  final int todayOrders;
  final double conversionRate;
  final int totalOrders;

  const MetricCardsRow({
    super.key,
    required this.todayVisitors,
    required this.todayOrders,
    required this.conversionRate,
    required this.totalOrders,
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
              "Today's Forecast & Stats",
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
          'Key metrics for your restaurant',
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
                title: "Expected Visitors",
                value: '$todayVisitors',
                valueColor: AppColors.primary,
                subtitle: 'predicted_visitors',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.shopping_bag_outlined,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
                title: 'Predicted Orders',
                value: '$todayOrders',
                valueColor: AppColors.orange,
                subtitle: 'predicted_orders',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.percent_rounded,
                iconColor: AppColors.green,
                iconBg: AppColors.greenLight,
                title: 'Conversion Rate',
                value: '${(conversionRate * 100).toStringAsFixed(1)}%',
                valueColor: AppColors.green,
                subtitle: 'conversion_rate',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.receipt_long_outlined,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
                title: 'Total Period Orders',
                value: '$totalOrders',
                valueColor: AppColors.orange,
                subtitle: 'total_orders',
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
  final String value;
  final Color valueColor;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.valueColor,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
