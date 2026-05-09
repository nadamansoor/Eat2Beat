import 'package:eat2beat/features/admin/presentation/view/analytics/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/cubits/dashboard_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/cubits/dashboard_state.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/analy_cutom_app_bar.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/data_summary.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/forcast.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/historical_visit.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/info_row.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/metric_cards.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/restu_selector.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/today_demand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().refresh(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            final data = state.data;
            final cubit = context.read<DashboardCubit>();

            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ── Header ──
                        const HeaderCard(),
                        const SizedBox(height: 14),

                        // ── Restaurant Selector ──
                        RestaurantSelector(
                          restaurantId: data.restaurantId,
                          onRefresh: cubit.refresh,
                        ),
                        const SizedBox(height: 14),

                        // ── Date Info ──
                        DateInfoRow(date: data.currentDate),
                        const SizedBox(height: 14),

                        // ── Metric Cards ──
                        MetricCardsRow(
                          todayVisitors: data.todayVisitors,
                          orderLevel: data.orderLevel,
                          sevenDayAvg: data.sevenDayAverage,
                          visitorsLast7: data.visitorsLast7Days,
                        ),
                        const SizedBox(height: 14),

                        // ── Today's Demand ──
                        TodaysDemandCard(
                          date: data.currentDate,
                          orderLevel: data.orderLevel,
                        ),
                        const SizedBox(height: 14),

                        // ── Week Forecast ──
                        WeekForecastCard(
                          days: data.weekForecast,
                          selectedIndex: state.selectedForecastIndex,
                          onSelect: cubit.selectForecastDay,
                        ),
                        const SizedBox(height: 14),

                        // ── Historical + Summary ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: HistoricalVisitsCard(visits: data.historicalVisits),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DataSummaryCard(data: data),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}