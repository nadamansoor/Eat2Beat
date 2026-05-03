enum DemandLevel { low, medium, high }

class DayForecast {
  final String dayName;
  final String dateLabel;
  final int visitors;
  final DemandLevel demand;
  final bool isToday;

  const DayForecast({
    required this.dayName,
    required this.dateLabel,
    required this.visitors,
    required this.demand,
    this.isToday = false,
  });
}

class HistoricalDay {
  final String dateLabel;
  final int visitors;

  const HistoricalDay({
    required this.dateLabel,
    required this.visitors,
  });
}

class AnalyticsEntity {
  final String restaurantId;
  final String dateLabel;
  final String dayName;
  final String dayType;       // e.g. "يوم عمل"
  final bool isOfficialHoliday;
  final int visitorsToday;    // راتر اليوم
  final int lag7;             // زوار آخر 7 أيام
  final double rollingMean7;  // متوسط آخر 7 أيام
  final DemandLevel demandLevel;
  final List<DayForecast> weekAhead;
  final List<HistoricalDay> last7Days;

  const AnalyticsEntity({
    required this.restaurantId,
    required this.dateLabel,
    required this.dayName,
    required this.dayType,
    required this.isOfficialHoliday,
    required this.visitorsToday,
    required this.lag7,
    required this.rollingMean7,
    required this.demandLevel,
    required this.weekAhead,
    required this.last7Days,
  });
}