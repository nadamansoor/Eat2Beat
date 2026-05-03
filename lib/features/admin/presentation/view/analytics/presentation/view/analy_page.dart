import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/cubits/analysis_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/cubits/analysis_states.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/view/widgets/analy_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatefulWidget {
  final String restaurantId;

  const AnalyticsPage({
    super.key,
    this.restaurantId = 'air_5c817ef28f236bdf',
  });

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().loadAnalytics(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E1A),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          // ── Loading ─────────────────────────────────────────────
          if (state is AnalyticsLoading || state is AnalyticsInitial) {
            return SafeArea(
              child: Column(
                children: [
                  AnalyticsHeader(restaurantId: widget.restaurantId),
                  const Expanded(child: AnalyticsSkeleton()),
                ],
              ),
            );
          }

          // ── Error ───────────────────────────────────────────────
          if (state is AnalyticsError) {
            return SafeArea(
              child: Column(
                children: [
                  AnalyticsHeader(restaurantId: widget.restaurantId),
                  Expanded(
                    child: AnalyticsErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<AnalyticsCubit>()
                          .retry(widget.restaurantId),
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Success ─────────────────────────────────────────────
          final data = (state as AnalyticsSuccess).data;
          final maxVisitors = data.last7Days
              .map((e) => e.visitors)
              .reduce((a, b) => a > b ? a : b);

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Sticky header ──────────────────────────────────
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HeaderDelegate(
                    restaurantId: widget.restaurantId,
                    onNotification: () {},
                    onRefresh: () => context
                        .read<AnalyticsCubit>()
                        .loadAnalytics(widget.restaurantId),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Date bar ─────────────────────────────────
                      DateInfoBar(
                        dateLabel: data.dateLabel,
                        dayName: data.dayName,
                        dayType: data.dayType,
                        isOfficialHoliday: data.isOfficialHoliday,
                      ),

                      // ── Today forecast title ──────────────────────
                      const SectionTitle(
                        title: 'توقع اليوم',
                        subtitle: 'المحور الاساسي للوحة التحكم',
                        icon: Icons.location_on_rounded,
                        iconColor: Color(0xFFFF6B6B),
                      ),

                      // ── 4 stat cards (2×2 grid) ───────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.15,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            StatCard(
                              label: 'راتر اليوم',
                              sublabel: 'زوار اليوم',
                              value: '${data.visitorsToday}',
                              valueColor: const Color(0xFF7C6FFF),
                              icon: Icons.people_alt_rounded,
                              iconColor: const Color(0xFF7C6FFF),
                            ),
                            StatCard(
                              label: 'lag_7',
                              sublabel: 'زوار آخر 7 أيام',
                              value: '${data.lag7}',
                              valueColor: const Color(0xFFFFC542),
                              icon: Icons.history_rounded,
                              iconColor: const Color(0xFFFFC542),
                            ),
                            StatCard(
                              label: 'rolling_mean_7',
                              sublabel: 'متوسط آخر 7 أيام',
                              value: data.rollingMean7.toStringAsFixed(0),
                              valueColor: const Color(0xFF2ECC71),
                              icon: Icons.trending_up_rounded,
                              iconColor: const Color(0xFF2ECC71),
                            ),
                            DemandBadgeCard(level: data.demandLevel),
                          ],
                        ),
                      ),

                      // ── Alert banner ──────────────────────────────
                      DemandAlertBanner(
                        level: data.demandLevel,
                        dateLabel: data.dateLabel,
                      ),

                      // ── Week ahead (horizontal carousel) ──────────
                      const SectionTitle(
                        title: 'نظرة سريعة — الأسبوع القادم',
                        subtitle: 'توقع الأيام السبعة القادمة',
                        icon: Icons.calendar_month_rounded,
                        iconColor: Color(0xFF7C6FFF),
                      ),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: data.weekAhead.length,
                          itemBuilder: (_, i) =>
                              DayForecastCard(day: data.weekAhead[i]),
                        ),
                      ),

                      // ── Historical + Summary side by side ─────────
                      const SectionTitle(
                        title: 'الزوار — آخر 7 فعلية',
                        subtitle: 'HISTORICAL',
                        icon: Icons.bar_chart_rounded,
                        iconColor: Color(0xFFB060FF),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: data.last7Days
                              .map((d) => HistoricalBarRow(
                                    day: d,
                                    maxVisitors: maxVisitors,
                                  ))
                              .toList(),
                        ),
                      ),

                      // ── Summary ───────────────────────────────────
                      const SectionTitle(
                        title: 'ملخص البيانات',
                        icon: Icons.summarize_rounded,
                        iconColor: Color(0xFFFFC542),
                      ),
                      SummaryCard(
                        restaurantId: data.restaurantId,
                        dayNumber: 'الأيام (3)',
                        lag7: data.lag7,
                        rollingMean7: data.rollingMean7,
                        visitorsToday: data.visitorsToday,
                        demandLevel: data.demandLevel,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Sticky header delegate ───────────────────────────────────────────
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String restaurantId;
  final VoidCallback? onNotification;
  final VoidCallback? onRefresh;

  const _HeaderDelegate({
    required this.restaurantId,
    this.onNotification,
    this.onRefresh,
  });

  @override
  double get minExtent => 72;
  @override
  double get maxExtent => 72;

  @override
  bool shouldRebuild(_HeaderDelegate old) => false;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0F0E1A),
      padding: const EdgeInsets.only(top: 8),
      child: AnalyticsHeader(
        restaurantId: restaurantId,
        onNotification: onNotification,
      ),
    );
  }
}