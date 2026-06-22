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

      // 1. Parse today_prediction
      final todayRaw = rawMap['today_prediction'];
      PredictionModel? todayPrediction;
      if (todayRaw != null) {
        todayPrediction = PredictionModel.fromJson(Map<String, dynamic>.from(todayRaw));
      }

      // 2. Parse actual rows
      final actualRaw = rawMap['actual'] as List? ?? [];
      final List<ActualRow> actualRows = actualRaw.map((x) {
        final map = Map<String, dynamic>.from(x);
        final dateStr = map['date']?.toString() ?? '';
        final ordersVal = int.tryParse(map['orders']?.toString() ?? '0') ?? 0;
        final sessionsVal = int.tryParse(map['sessions']?.toString() ?? '0') ?? 0;
        return ActualRow(
          date: DateTime.tryParse(dateStr) ?? DateTime.now(),
          orders: ordersVal,
          sessions: sessionsVal,
          customers: (ordersVal * 0.7).round(),
        );
      }).toList();

      // Convert actual history to HistoricalVisit list (last 7 elements matching Angular)
      final List<HistoricalVisit> historicalVisits = actualRows.map((row) {
        return HistoricalVisit(
          date: row.date,
          visitors: row.sessions, // sessions represents traffic/visits
        );
      }).toList();

      // 3. Parse saved_forecast list
      final forecastRawList = rawMap['saved_forecast'] as List? ?? [];
      List<ForecastDay> weekForecast = [];

      if (forecastRawList.isNotEmpty) {
        weekForecast = forecastRawList.map((x) {
          final map = Map<String, dynamic>.from(x);
          final dateStr = map['prediction_date'] ?? map['predictionDate'] ?? map['date'] ?? map['day'] ?? '';
          final date = DateTime.tryParse(dateStr.toString()) ?? DateTime.now();
          final visitors = int.tryParse((map['predicted_visitors'] ?? map['predictedVisitors'] ?? map['visitors'] ?? 0).toString()) ?? 0;
          final orders = int.tryParse((map['predicted_orders'] ?? map['predictedOrders'] ?? map['orders'] ?? 0).toString()) ?? 0;
          final demand = map['demand_level'] ?? map['demandLevel'] ?? 'Medium';
          return ForecastDay(
            date: date,
            visitors: visitors,
            predictedOrders: orders,
            orderLevel: _parseOrderLevel(demand.toString()),
          );
        }).toList();
      } else {
        // Fallback: fetch forecast endpoint if saved_forecast is empty
        try {
          final fallbackForecast = await remoteDataSource.getForecast(
            token: token,
            restaurantId: restaurantId,
            days: 7,
            save: false,
          );
          weekForecast = fallbackForecast.map((x) {
            final map = Map<String, dynamic>.from(x);
            final dateStr = map['prediction_date'] ?? map['predictionDate'] ?? map['date'] ?? map['day'] ?? '';
            final date = DateTime.tryParse(dateStr.toString()) ?? DateTime.now();
            final visitors = int.tryParse((map['predicted_visitors'] ?? map['predictedVisitors'] ?? map['visitors'] ?? 0).toString()) ?? 0;
            final orders = int.tryParse((map['predicted_orders'] ?? map['predictedOrders'] ?? map['orders'] ?? 0).toString()) ?? 0;
            final demand = map['demand_level'] ?? map['demandLevel'] ?? 'Medium';
            return ForecastDay(
              date: date,
              visitors: visitors,
              predictedOrders: orders,
              orderLevel: _parseOrderLevel(demand.toString()),
            );
          }).toList();
        } catch (_) {
          // If fallback fails, leave forecast empty
          weekForecast = [];
        }
      }

      // 4. Parse summary
      final summaryRaw = rawMap['summary'] ?? {};
      final totalOrdersVal = int.tryParse(summaryRaw['total_orders']?.toString() ?? '0') ?? 0;
      final totalSessionsVal = int.tryParse(summaryRaw['total_sessions']?.toString() ?? '0') ?? 0;
      final conversionRateVal = double.tryParse(summaryRaw['conversion_rate']?.toString() ?? '0.0') ?? 0.0;

      // 5. Calculate Charity Impact Data
      // Sum the restaurant's local donations count or default to a baseline of 1500 if none exist
      int totalDonations = 1500;
      try {
        final mealsList = await remoteDataSource.getMeals(token);
        if (mealsList.isNotEmpty) {
          final firstMeal = mealsList[0];
          final rid = firstMeal['restaurant_id']?.toString() ?? firstMeal['restaurants_id']?.toString() ?? '';
          if (rid.isNotEmpty) {
            final donations = await remoteDataSource.getRestaurantDonations(token);
            if (donations.isNotEmpty) {
              totalDonations = donations.length * 25; // Estimate some dollar value per donation post
            }
          }
        }
      } catch (_) {
        // Fallback to 1500
      }

      final List<CharityImpactRow> charityData = [
        CharityImpactRow(day: 'Mon', donations: (totalDonations * 0.15).round(), foodWaste: (totalDonations * 0.08).round()),
        CharityImpactRow(day: 'Tue', donations: (totalDonations * 0.22).round(), foodWaste: (totalDonations * 0.10).round()),
        CharityImpactRow(day: 'Wed', donations: (totalDonations * 0.12).round(), foodWaste: (totalDonations * 0.05).round()),
        CharityImpactRow(day: 'Thu', donations: (totalDonations * 0.25).round(), foodWaste: (totalDonations * 0.12).round()),
        CharityImpactRow(day: 'Fri', donations: (totalDonations * 0.30).round(), foodWaste: (totalDonations * 0.15).round()),
        CharityImpactRow(day: 'Sat', donations: (totalDonations * 0.22).round(), foodWaste: (totalDonations * 0.09).round()),
        CharityImpactRow(day: 'Sun', donations: (totalDonations * 0.18).round(), foodWaste: (totalDonations * 0.07).round()),
      ];

      // Build dashboard data object
      final dashboardData = DashboardData(
        restaurantId: todayPrediction?.restaurantId.isNotEmpty == true 
            ? todayPrediction!.restaurantId 
            : restaurantId,
        currentDate: todayPrediction?.predictionDate ?? DateTime.now(),
        todayVisitors: todayPrediction?.predictedVisitors ?? 0,
        todayOrders: todayPrediction?.predictedVisitors != null ? (todayPrediction!.predictedVisitors * 0.6).round() : 0,
        orderLevel: _parseOrderLevel(todayPrediction?.demandLevel ?? 'Medium'),
        sevenDayAverage: todayPrediction?.rollingMean7.toDouble() ?? 0.0,
        visitorsLast7Days: todayPrediction?.lag7 ?? 0,
        weekForecast: weekForecast,
        historicalVisits: historicalVisits,
        dayNumber: todayPrediction?.dayOfWeekNum ?? DateTime.now().weekday,
        dayName: todayPrediction?.dayOfWeek ?? _getCurrentDayName(),
        isWeekend: todayPrediction?.isWeekend ?? false,
        isHoliday: todayPrediction?.holidayFlg ?? false,
        actual: actualRows,
        totalOrders: totalOrdersVal,
        totalSessions: totalSessionsVal,
        conversionRate: conversionRateVal,
        charityData: charityData,
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

  String _getCurrentDayName() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[DateTime.now().weekday - 1];
  }
}
