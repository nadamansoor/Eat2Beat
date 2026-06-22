import 'package:eat2beat/features/charity/charity_analytics/controllers/analy_charity_controllers.dart';
import 'package:flutter/material.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';

class DateRangeDropdown extends StatelessWidget {
  final AnalyticsController ctrl;
  const DateRangeDropdown({required this.ctrl});

  static const _options = <(String, DateRange)>[
    ('This Month', DateRange.thisMonth),
    ('Last Month', DateRange.lastMonth),
    ('Last 3 Months', DateRange.last3Months),
    ('Last Year', DateRange.lastYear),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showMenu<DateRange>(
          context: context,
          position: const RelativeRect.fromLTRB(100, 120, 16, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          items: _options
              .map((o) => PopupMenuItem(
                    value: o.$2,
                    child: Text(o.$1,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 13)),
                  ))
              .toList(),
        );
        if (result != null) ctrl.setRange(result);
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ctrl.rangeLabel,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

