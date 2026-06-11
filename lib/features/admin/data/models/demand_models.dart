import 'package:eat2beat/features/admin/domain/entities/demand_entities.dart';

class LastDayModel extends LastDay {
  const LastDayModel({
    required super.date,
    required super.visitors,
  });

  factory LastDayModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] != null) {
      parsedDate = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    int parsedVisitors = 0;
    if (json['visitors'] != null) {
      if (json['visitors'] is num) {
        parsedVisitors = (json['visitors'] as num).toInt();
      } else {
        parsedVisitors = int.tryParse(json['visitors'].toString()) ?? 0;
      }
    } else if (json['predicted_visitors'] != null) {
      if (json['predicted_visitors'] is num) {
        parsedVisitors = (json['predicted_visitors'] as num).toInt();
      } else {
        parsedVisitors = int.tryParse(json['predicted_visitors'].toString()) ?? 0;
      }
    }

    return LastDayModel(
      date: parsedDate,
      visitors: parsedVisitors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'visitors': visitors,
    };
  }
}

class PredictionModel extends Prediction {
  const PredictionModel({
    required super.restaurantId,
    required super.predictionDate,
    required super.dayOfWeek,
    required super.dayOfWeekNum,
    required super.isWeekend,
    required super.holidayFlg,
    required super.predictedVisitors,
    required super.rollingMean7,
    required super.lag7,
    required super.demandLevel,
    required super.last7Days,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedPredDate;
    final rawDate = json['prediction_date'] ?? json['predictionDate'] ?? '';
    parsedPredDate = DateTime.tryParse(rawDate.toString()) ?? DateTime.now();

    final List<dynamic> last7List = json['last_7_days'] ?? json['last7Days'] ?? [];
    final lastDays = last7List.map((x) => LastDayModel.fromJson(Map<String, dynamic>.from(x))).toList();

    int parsedPredicted = 0;
    final rawPredicted = json['predicted_visitors'] ?? json['predictedVisitors'] ?? json['predicted_orders'] ?? 0;
    if (rawPredicted is num) {
      parsedPredicted = rawPredicted.toInt();
    } else {
      parsedPredicted = int.tryParse(rawPredicted.toString()) ?? 0;
    }

    int parsedRolling = 0;
    final rawRolling = json['rolling_mean_7'] ?? json['rollingMean7'] ?? 0;
    if (rawRolling is num) {
      parsedRolling = rawRolling.toInt();
    } else {
      parsedRolling = int.tryParse(rawRolling.toString()) ?? 0;
    }

    int parsedLag = 0;
    final rawLag = json['lag_7'] ?? json['lag7'] ?? 0;
    if (rawLag is num) {
      parsedLag = rawLag.toInt();
    } else {
      parsedLag = int.tryParse(rawLag.toString()) ?? 0;
    }

    bool weekend = false;
    final rawWeekend = json['is_weekend'] ?? json['isWeekend'];
    if (rawWeekend is bool) {
      weekend = rawWeekend;
    } else if (rawWeekend != null) {
      weekend = rawWeekend.toString() == '1' || rawWeekend.toString().toLowerCase() == 'true';
    }

    bool holiday = false;
    final rawHoliday = json['holiday_flg'] ?? json['holidayFlg'];
    if (rawHoliday is bool) {
      holiday = rawHoliday;
    } else if (rawHoliday != null) {
      holiday = rawHoliday.toString() == '1' || rawHoliday.toString().toLowerCase() == 'true';
    }

    return PredictionModel(
      restaurantId: json['restaurant_id']?.toString() ?? json['restaurantId']?.toString() ?? '',
      predictionDate: parsedPredDate,
      dayOfWeek: json['day_of_week']?.toString() ?? json['dayOfWeek']?.toString() ?? '',
      dayOfWeekNum: int.tryParse((json['day_of_week_num'] ?? json['dayOfWeekNum'] ?? 0).toString()) ?? 0,
      isWeekend: weekend,
      holidayFlg: holiday,
      predictedVisitors: parsedPredicted,
      rollingMean7: parsedRolling,
      lag7: parsedLag,
      demandLevel: json['demand_level']?.toString() ?? json['demandLevel']?.toString() ?? 'Medium',
      last7Days: lastDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'prediction_date': predictionDate.toIso8601String(),
      'day_of_week': dayOfWeek,
      'day_of_week_num': dayOfWeekNum,
      'is_weekend': isWeekend,
      'holiday_flg': holidayFlg,
      'predicted_visitors': predictedVisitors,
      'rolling_mean_7': rollingMean7,
      'lag_7': lag7,
      'demand_level': demandLevel,
      'last_7_days': last7Days.map((x) => (x as LastDayModel).toJson()).toList(),
    };
  }
}
