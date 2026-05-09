
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

class MockupData {
  static DashboardData get sampleDashboard => DashboardData(
        restaurantId: 'air_5c817ef28f236bdf',
        currentDate: DateTime(2026, 4, 16),
        todayVisitors: 44,
        orderLevel: OrderLevel.medium,
        sevenDayAverage: 45.4,
        visitorsLast7Days: 60,
        dayNumber: 3,
        weekForecast: [
          ForecastDay(date: DateTime(2026, 4, 17), visitors: 44, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 18), visitors: 66, orderLevel: OrderLevel.high),
          ForecastDay(date: DateTime(2026, 4, 19), visitors: 50, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 20), visitors: 41, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 21), visitors: 30, orderLevel: OrderLevel.low),
          ForecastDay(date: DateTime(2026, 4, 22), visitors: 50, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 23), visitors: 46, orderLevel: OrderLevel.medium),
        ],
        historicalVisits: [
          HistoricalVisit(date: DateTime(2026, 4, 11), visitors: 60),
          HistoricalVisit(date: DateTime(2026, 4, 17), visitors: 18),
          HistoricalVisit(date: DateTime(2026, 4, 18), visitors: 30),
          HistoricalVisit(date: DateTime(2026, 4, 19), visitors: 20),
          HistoricalVisit(date: DateTime(2026, 4, 22), visitors: 22),
          HistoricalVisit(date: DateTime(2026, 4, 21), visitors: 71),
          HistoricalVisit(date: DateTime(2026, 4, 22), visitors: 97),
        ],
      );
}