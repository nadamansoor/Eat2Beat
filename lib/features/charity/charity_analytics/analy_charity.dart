import 'package:eat2beat/features/charity/charity_analytics/controllers/analy_charity_controllers.dart';
import 'package:eat2beat/features/charity/charity_analytics/widgets/analy_body_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';

class AnalyCharity extends StatelessWidget {
  const AnalyCharity({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsController(),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AnalyticsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Analytics',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ctrl.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : Body(ctrl: ctrl),
    );
  }
}