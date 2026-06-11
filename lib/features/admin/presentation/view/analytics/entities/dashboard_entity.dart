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
  final OrderLevel orderLevel;

  const ForecastDay({
    required this.date,
    required this.visitors,
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

class DashboardData {
  final String restaurantId;
  final DateTime currentDate;
  final int todayVisitors;
  final OrderLevel orderLevel;
  final double sevenDayAverage;
  final int visitorsLast7Days;
  final List<ForecastDay> weekForecast;
  final List<HistoricalVisit> historicalVisits;
  final int dayNumber;
  final String dayName;
  final bool isWeekend;
  final bool isHoliday;

  const DashboardData({
    required this.restaurantId,
    required this.currentDate,
    required this.todayVisitors,
    required this.orderLevel,
    required this.sevenDayAverage,
    required this.visitorsLast7Days,
    required this.weekForecast,
    required this.historicalVisits,
    required this.dayNumber,
    required this.dayName,
    required this.isWeekend,
    required this.isHoliday,
  });
}