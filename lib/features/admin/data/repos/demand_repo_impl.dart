import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/admin/data/datasources/demand_remote_datasource.dart';
import 'package:eat2beat/features/admin/data/models/demand_models.dart';
import 'package:eat2beat/features/admin/domain/repo/demand_repo.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

class DemandRepositoryImpl implements DemandRepository {
  final DemandRemoteDataSource remoteDataSource;

  DemandRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String token,
    required String restaurantId,
    int days = 7,
  }) async {
    try {
      final rawMap = await remoteDataSource.getDashboardData(
        token: token,
        restaurantId: restaurantId,
        days: days,
      );

      // Parse today_prediction
      final todayRaw = rawMap['today_prediction'] ?? {};
      final todayPrediction = PredictionModel.fromJson(Map<String, dynamic>.from(todayRaw));

      // Parse saved_forecast list
      final forecastRawList = rawMap['saved_forecast'] as List? ?? [];
      final forecastPredictions = forecastRawList
          .map((x) => PredictionModel.fromJson(Map<String, dynamic>.from(x)))
          .toList();

      // Convert predictions to UI entities (ForecastDay)
      final List<ForecastDay> weekForecast = forecastPredictions.map((pred) {
        return ForecastDay(
          date: pred.predictionDate,
          visitors: pred.predictedVisitors,
          orderLevel: _parseOrderLevel(pred.demandLevel),
        );
      }).toList();

      // Convert last 7 days to UI entities (HistoricalVisit)
      final List<HistoricalVisit> historicalVisits = todayPrediction.last7Days.map((ld) {
        return HistoricalVisit(
          date: ld.date,
          visitors: ld.visitors,
        );
      }).toList();

      final dashboardData = DashboardData(
        restaurantId: todayPrediction.restaurantId.isNotEmpty 
            ? todayPrediction.restaurantId 
            : restaurantId,
        currentDate: todayPrediction.predictionDate,
        todayVisitors: todayPrediction.predictedVisitors,
        orderLevel: _parseOrderLevel(todayPrediction.demandLevel),
        sevenDayAverage: todayPrediction.rollingMean7.toDouble(),
        visitorsLast7Days: todayPrediction.lag7,
        weekForecast: weekForecast,
        historicalVisits: historicalVisits,
        dayNumber: todayPrediction.dayOfWeekNum,
        dayName: todayPrediction.dayOfWeek,
        isWeekend: todayPrediction.isWeekend,
        isHoliday: todayPrediction.holidayFlg,
      );

      return right(dashboardData);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading analytics data. Please try again.'));
    }
  }

  OrderLevel _parseOrderLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return OrderLevel.low;
      case 'high':
        return OrderLevel.high;
      case 'medium':
      default:
        return OrderLevel.medium;
    }
  }
}
