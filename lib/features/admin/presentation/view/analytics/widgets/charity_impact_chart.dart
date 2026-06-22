import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

class CharityImpactChart extends StatelessWidget {
  final List<CharityImpactRow> charityData;

  const CharityImpactChart({super.key, required this.charityData});

  @override
  Widget build(BuildContext context) {
    if (charityData.isEmpty) {
      return const SizedBox.shrink();
    }

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
                'Charity Impact',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'WEEKLY',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
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
              children: charityData.map((row) {
                // Calculate height percentages based on max limits from Angular (donations: 280, foodWaste: 12)
                final double donationsHeightRatio = (row.donations / 280.0).clamp(0.02, 1.0);
                final double foodWasteHeightRatio = (row.foodWaste / 12.0).clamp(0.02, 1.0);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Donations Bar
                            _Bar(
                              ratio: donationsHeightRatio,
                              color: const Color(0xFF8966FA),
                              value: '\$${row.donations}',
                            ),
                            // Food Waste Bar
                            _Bar(
                              ratio: foodWasteHeightRatio,
                              color: const Color(0xFF10B981),
                              value: '${row.foodWaste}kg',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        row.day,
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
              _LegendItem(color: Color(0xFF8966FA), label: 'Total Charity (\$)'),
              _LegendItem(color: Color(0xFF10B981), label: 'Food Waste (kg)'),
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
