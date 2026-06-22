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
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/charity_impact_chart.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/widgets/recent_orders_list.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_demand_dashboard_usecase.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    String? restaurantId;
    if (profileCubit.state is ProfileLoaded) {
      final profileData = (profileCubit.state as ProfileLoaded).profileData;
      restaurantId = profileData['restaurant_id']?.toString() ??
                     profileData['id']?.toString() ??
                     profileData['uid']?.toString();
    }

    return BlocProvider(
      create: (_) => DashboardCubit(
        authRepo: getIt<AuthRepo>(),
        getDemandDashboardUseCase: getIt<GetDemandDashboardUseCase>(),
        apiService: getIt<ApiService>(),
      )..loadDashboard(restaurantId: restaurantId),
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
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
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

            // If actual history and forecast are empty, display info panel gracefully
            final bool hasNoDataYet = data.actual.isEmpty && data.weekForecast.isEmpty;

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

                        // ── Restaurant & Days Selector ──
                        RestaurantSelector(
                          restaurantId: data.restaurantId,
                          days: state.days,
                          onRefresh: cubit.refresh,
                          onDaysChanged: (newDays) {
                            cubit.loadDashboard(
                              restaurantId: data.restaurantId,
                              days: newDays,
                            );
                          },
                        ),
                        const SizedBox(height: 14),

                        if (hasNoDataYet) ...[
                          // Graceful Info Card matching Angular
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 40),
                                SizedBox(height: 12),
                                Text(
                                  'Not enough historical data yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'More days of order transactions are required before predictive demand analytics can be calculated.',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          // ── Date Info ──
                          DateInfoRow(
                            date: data.currentDate,
                            dayName: data.dayName,
                            isWeekend: data.isWeekend,
                            isHoliday: data.isHoliday,
                          ),
                          const SizedBox(height: 14),

                          // ── Metric Cards ──
                          MetricCardsRow(
                            todayVisitors: data.todayVisitors,
                            todayOrders: data.todayOrders,
                            conversionRate: data.conversionRate,
                            totalOrders: data.totalOrders,
                          ),
                          const SizedBox(height: 14),

                          // ── Today's Demand Card ──
                          TodaysDemandCard(
                            date: data.currentDate,
                            orderLevel: data.orderLevel,
                          ),
                          const SizedBox(height: 14),

                          // ── Week Forecast Card ──
                          WeekForecastCard(
                            days: data.weekForecast,
                            selectedIndex: state.selectedForecastIndex,
                            onSelect: cubit.selectForecastDay,
                          ),
                          const SizedBox(height: 14),

                          // ── Weekly Performance Chart ──
                          WeeklyPerformanceChart(actual: data.actual),
                          const SizedBox(height: 14),

                          // ── Charity Impact Chart ──
                          CharityImpactChart(charityData: data.charityData),
                          const SizedBox(height: 14),

                          // ── Recent Activity Log List ──
                          RecentOrdersListCard(actual: data.actual),
                          const SizedBox(height: 14),

                          // ── Data Summary details ──
                          DataSummaryCard(data: data),
                          const SizedBox(height: 24),
                        ],
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