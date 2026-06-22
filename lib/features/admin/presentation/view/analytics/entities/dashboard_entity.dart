enum OrderLevel { low, medium, high }

extension OrderLevelExt on OrderLevel {
  String get label {
    switch (this) {
      case OrderLevel.low:
        return 'Low';
      case OrderLevel.medium:
        return 'Medium';
      case OrderLevel.high:
        return 'High';
    }
  }
}

class ForecastDay {
  final DateTime date;
  final int visitors;
  final int predictedOrders;
  final OrderLevel orderLevel;

  const ForecastDay({
    required this.date,
    required this.visitors,
    required this.predictedOrders,
    required this.orderLevel,
  });
}

class HistoricalVisit {
  final DateTime date;
  final int visitors;

  const HistoricalVisit({
    required this.date,
    required this.visitors,
  });
}

class ActualRow {
  final DateTime date;
  final int orders;
  final int sessions;
  final int customers;

  const ActualRow({
    required this.date,
    required this.orders,
    required this.sessions,
    required this.customers,
  });
}

class CharityImpactRow {
  final String day;
  final int donations;
  final int foodWaste;

  const CharityImpactRow({
    required this.day,
    required this.donations,
    required this.foodWaste,
  });
}

class DashboardData {
  final String restaurantId;
  final DateTime currentDate;
  final int todayVisitors;
  final int todayOrders;
  final OrderLevel orderLevel;
  final double sevenDayAverage;
  final int visitorsLast7Days;
  final List<ForecastDay> weekForecast;
  final List<HistoricalVisit> historicalVisits;
  final int dayNumber;
  final String dayName;
  final bool isWeekend;
  final bool isHoliday;

  // Matching fields from Angular client
  final List<ActualRow> actual;
  final int totalOrders;
  final int totalSessions;
  final double conversionRate;
  final List<CharityImpactRow> charityData;

  const DashboardData({
    required this.restaurantId,
    required this.currentDate,
    required this.todayVisitors,
    required this.todayOrders,
    required this.orderLevel,
    required this.sevenDayAverage,
    required this.visitorsLast7Days,
    required this.weekForecast,
    required this.historicalVisits,
    required this.dayNumber,
    required this.dayName,
    required this.isWeekend,
    required this.isHoliday,
    required this.actual,
    required this.totalOrders,
    required this.totalSessions,
    required this.conversionRate,
    required this.charityData,
  });
}