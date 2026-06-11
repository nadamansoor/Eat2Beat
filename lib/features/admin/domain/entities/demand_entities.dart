class LastDay {
  final DateTime date;
  final int visitors;

  const LastDay({
    required this.date,
    required this.visitors,
  });
}

class Prediction {
  final String restaurantId;
  final DateTime predictionDate;
  final String dayOfWeek;
  final int dayOfWeekNum;
  final bool isWeekend;
  final bool holidayFlg;
  final int predictedVisitors;
  final int rollingMean7;
  final int lag7;
  final String demandLevel; // 'Low' | 'Medium' | 'High'
  final List<LastDay> last7Days;

  const Prediction({
    required this.restaurantId,
    required this.predictionDate,
    required this.dayOfWeek,
    required this.dayOfWeekNum,
    required this.isWeekend,
    required this.holidayFlg,
    required this.predictedVisitors,
    required this.rollingMean7,
    required this.lag7,
    required this.demandLevel,
    required this.last7Days,
  });
}
