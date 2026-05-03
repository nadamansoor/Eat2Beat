  // ── Mock ──────────────────────────────────────────────────────────
  import 'package:eat2beat/features/admin/presentation/view/analytics/domain/entities/analytics_entity.dart';

AnalyticsEntity mockData(String id) => AnalyticsEntity(
        restaurantId: id,
        dateLabel: '16-04-2026',
        dayName: 'الخميس',
        dayType: 'يوم عمل',
        isOfficialHoliday: false,
        visitorsToday: 44,
        lag7: 60,
        rollingMean7: 45.4,
        demandLevel: DemandLevel.medium,
        weekAhead: const [
          DayForecast(dayName: 'الخميس', dateLabel: '17 أبريل', visitors: 44, demand: DemandLevel.medium, isToday: true),
          DayForecast(dayName: 'الجمعة', dateLabel: '17 أبريل', visitors: 66, demand: DemandLevel.high),
          DayForecast(dayName: 'السبت',  dateLabel: '18 أبريل', visitors: 50, demand: DemandLevel.medium),
          DayForecast(dayName: 'الأحد',  dateLabel: '19 أبريل', visitors: 41, demand: DemandLevel.medium),
          DayForecast(dayName: 'الاثنين',dateLabel: '20 أبريل', visitors: 30, demand: DemandLevel.low),
          DayForecast(dayName: 'الثلاثاء',dateLabel: '21 أبريل', visitors: 50, demand: DemandLevel.medium),
          DayForecast(dayName: 'الأربعاء',dateLabel: '22 أبريل', visitors: 46, demand: DemandLevel.medium),
        ],
        last7Days: const [
          HistoricalDay(dateLabel: '11 أبريل', visitors: 60),
          HistoricalDay(dateLabel: '17 أبريل', visitors: 18),
          HistoricalDay(dateLabel: '18 أبريل', visitors: 30),
          HistoricalDay(dateLabel: '19 أبريل', visitors: 20),
          HistoricalDay(dateLabel: '22 أبريل', visitors: 22),
          HistoricalDay(dateLabel: '21 أبريل', visitors: 71),
          HistoricalDay(dateLabel: '22 أبريل', visitors: 97),
        ],
      );