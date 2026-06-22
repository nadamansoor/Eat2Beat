
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

class MockupData {
  static DashboardData get sampleDashboard => DashboardData(
        restaurantId: 'air_5c817ef28f236bdf',
        currentDate: DateTime(2026, 4, 16),
        todayVisitors: 44,
        todayOrders: 26,
        orderLevel: OrderLevel.medium,
        sevenDayAverage: 45.4,
        visitorsLast7Days: 60,
        dayNumber: 3,
        dayName: 'Monday',
        isWeekend: false,
        isHoliday: false,
        weekForecast: [
          ForecastDay(date: DateTime(2026, 4, 17), visitors: 44, predictedOrders: 26, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 18), visitors: 66, predictedOrders: 40, orderLevel: OrderLevel.high),
          ForecastDay(date: DateTime(2026, 4, 19), visitors: 50, predictedOrders: 30, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 20), visitors: 41, predictedOrders: 25, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 21), visitors: 30, predictedOrders: 18, orderLevel: OrderLevel.low),
          ForecastDay(date: DateTime(2026, 4, 22), visitors: 50, predictedOrders: 30, orderLevel: OrderLevel.medium),
          ForecastDay(date: DateTime(2026, 4, 23), visitors: 46, predictedOrders: 28, orderLevel: OrderLevel.medium),
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
        actual: [
          ActualRow(date: DateTime(2026, 4, 11), orders: 36, sessions: 60, customers: 25),
          ActualRow(date: DateTime(2026, 4, 17), orders: 11, sessions: 18, customers: 8),
          ActualRow(date: DateTime(2026, 4, 18), orders: 18, sessions: 30, customers: 13),
          ActualRow(date: DateTime(2026, 4, 19), orders: 12, sessions: 20, customers: 9),
          ActualRow(date: DateTime(2026, 4, 20), orders: 13, sessions: 22, customers: 9),
          ActualRow(date: DateTime(2026, 4, 21), orders: 43, sessions: 71, customers: 30),
          ActualRow(date: DateTime(2026, 4, 22), orders: 58, sessions: 97, customers: 41),
        ],
        totalOrders: 191,
        totalSessions: 318,
        conversionRate: 60.0,
        charityData: [
          CharityImpactRow(day: 'Mon', donations: 225, foodWaste: 120),
          CharityImpactRow(day: 'Tue', donations: 330, foodWaste: 150),
          CharityImpactRow(day: 'Wed', donations: 180, foodWaste: 75),
          CharityImpactRow(day: 'Thu', donations: 375, foodWaste: 180),
          CharityImpactRow(day: 'Fri', donations: 450, foodWaste: 225),
          CharityImpactRow(day: 'Sat', donations: 330, foodWaste: 135),
          CharityImpactRow(day: 'Sun', donations: 270, foodWaste: 105),
        ],
      );
}