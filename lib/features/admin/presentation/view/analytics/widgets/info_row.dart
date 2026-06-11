import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:flutter/material.dart';

class DateInfoRow extends StatelessWidget {
  final DateTime date;
  final String dayName;
  final bool isWeekend;
  final bool isHoliday;

  const DateInfoRow({
    super.key,
    required this.date,
    required this.dayName,
    required this.isWeekend,
    required this.isHoliday,
  });

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Widget build(BuildContext context) {
    final isWork = !isWeekend;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoChip(
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value: _formatDate(date),
              valueStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          _divider(),
          Expanded(
            child: _InfoChip(
              icon: Icons.calendar_month_rounded,
              label: 'Day',
              value: dayName,
              valueStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          _divider(),
          Expanded(
            child: _InfoChip(
              label: 'Day Type',
              icon: isWork ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
              value: isWork ? 'Workday' : 'Weekend',
              valueBadge: true,
              badgeColor: isWork ? AppColors.greenLight : AppColors.primaryLight,
              badgeTextColor: isWork ? AppColors.green : AppColors.primary,
            ),
          ),
          _divider(),
          Expanded(
            child: _InfoChip(
              label: 'Signal',
              icon: Icons.auto_awesome_outlined,
              value: isHoliday ? 'Holiday' : 'Regular',
              valueBadge: true,
              badgeColor: isHoliday ? AppColors.redLight : AppColors.greenLight,
              badgeTextColor: isHoliday ? AppColors.red : AppColors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1, height: 36, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 3));
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final bool valueBadge;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueBadge = false,
    this.badgeColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 11, color: AppColors.textSecondary),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (valueBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor ?? AppColors.greenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badgeTextColor ?? AppColors.green,
              ),
            ),
          )
        else
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: valueStyle ?? const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}
