import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

class HistoricalVisitsCard extends StatelessWidget {
  final List<HistoricalVisit> visits;

  const HistoricalVisitsCard({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    final maxVisitors = visits.map((v) => v.visitors).reduce((a, b) => a > b ? a : b);

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
              Flexible(
                child: Text(
                  'Visitors — Last 7 Occasions',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: AppColors.greenLight, borderRadius: BorderRadius.circular(8)),
                child: const Text('HISTORICAL',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                        letterSpacing: 0.5)),
              )
            ],
          ),
          const SizedBox(height: 12),
          ...visits.map((v) => _VisitRow(visit: v, maxVisitors: maxVisitors)),
        ],
      ),
    );
  }
}

class _VisitRow extends StatelessWidget {
  final HistoricalVisit visit;
  final int maxVisitors;

  const _VisitRow({required this.visit, required this.maxVisitors});

  @override
  Widget build(BuildContext context) {
    final ratio = visit.visitors / maxVisitors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                backgroundColor: const Color(0xFFEDE9FE),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text('${visit.visitors}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          SizedBox(
            width: 44,
            child: Text(
              'Apr ${visit.date.day}',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
