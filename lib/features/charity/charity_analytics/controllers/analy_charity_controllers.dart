import 'package:eat2beat/features/charity/charity_analytics/models/analytics_charity_model.dart';
import 'package:flutter/foundation.dart';

enum DateRange { thisMonth, lastMonth, last3Months, lastYear }

class AnalyticsController extends ChangeNotifier {
  DateRange _selectedRange = DateRange.thisMonth;
  bool _isLoading = true;
  AnalyticsData? _data;

  DateRange get selectedRange => _selectedRange;
  bool get isLoading => _isLoading;
  AnalyticsData? get data => _data;

  String get rangeLabel => switch (_selectedRange) {
        DateRange.thisMonth => 'May 1 - May 31, 2024',
        DateRange.lastMonth => 'Apr 1 - Apr 30, 2024',
        DateRange.last3Months => 'Mar 1 - May 31, 2024',
        DateRange.lastYear => 'Jun 2023 - May 2024',
      };

  AnalyticsController() {
    _load();
  }

  Future<void> setRange(DateRange range) async {
    if (_selectedRange == range) return;
    _selectedRange = range;
    await _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();

    // TODO: replace with repository / API call
    await Future.delayed(const Duration(milliseconds: 500));
    _data = _mockData(_selectedRange);

    _isLoading = false;
    notifyListeners();
  }

  // ── Mock data ─────────────────────────────────────────────────────────────
  AnalyticsData _mockData(DateRange range) {
    final chartsByRange = <DateRange, List<ChartPoint>>{
      DateRange.thisMonth: const [
        ChartPoint(label: 'May 1', value: 20),
        ChartPoint(label: 'May 5', value: 35),
        ChartPoint(label: 'May 10', value: 30),
        ChartPoint(label: 'May 15', value: 75),
        ChartPoint(label: 'May 20', value: 65),
        ChartPoint(label: 'May 25', value: 50),
        ChartPoint(label: 'May 28', value: 70),
        ChartPoint(label: 'May 31', value: 85),
      ],
      DateRange.lastMonth: const [
        ChartPoint(label: 'Apr 1', value: 15),
        ChartPoint(label: 'Apr 8', value: 40),
        ChartPoint(label: 'Apr 15', value: 55),
        ChartPoint(label: 'Apr 22', value: 45),
        ChartPoint(label: 'Apr 30', value: 60),
      ],
      DateRange.last3Months: const [
        ChartPoint(label: 'Mar', value: 120),
        ChartPoint(label: 'Apr', value: 160),
        ChartPoint(label: 'May', value: 200),
      ],
      DateRange.lastYear: const [
        ChartPoint(label: 'Jun', value: 80),
        ChartPoint(label: 'Aug', value: 110),
        ChartPoint(label: 'Oct', value: 95),
        ChartPoint(label: 'Dec', value: 140),
        ChartPoint(label: 'Feb', value: 130),
        ChartPoint(label: 'Apr', value: 160),
        ChartPoint(label: 'May', value: 200),
      ],
    };

    final summaries = <DateRange, AnalyticsSummary>{
      DateRange.thisMonth: AnalyticsSummary(
        totalDonations: 48,
        totalMeals: 480,
        activeRestaurants: 8,
        dateRangeLabel: rangeLabel,
      ),
      DateRange.lastMonth: AnalyticsSummary(
        totalDonations: 36,
        totalMeals: 350,
        activeRestaurants: 7,
        dateRangeLabel: rangeLabel,
      ),
      DateRange.last3Months: AnalyticsSummary(
        totalDonations: 120,
        totalMeals: 1200,
        activeRestaurants: 10,
        dateRangeLabel: rangeLabel,
      ),
      DateRange.lastYear: AnalyticsSummary(
        totalDonations: 480,
        totalMeals: 4800,
        activeRestaurants: 12,
        dateRangeLabel: rangeLabel,
      ),
    };

    return AnalyticsData(
      summary: summaries[range]!,
      chartPoints: chartsByRange[range]!,
      topRestaurants: const [
        TopRestaurant(
          name: 'Good Eats Cafe',
          imageAsset: 'assets/imgoffers/food3.png',
          meals: 120,
        ),
        TopRestaurant(
          name: 'Burger House',
          imageAsset: 'assets/imgoffers/food2.png',
          meals: 85,
        ),
        TopRestaurant(
          name: 'Pasta Palace',
          imageAsset: 'assets/imgoffers/food4.png',
          meals: 60,
        ),
        TopRestaurant(
          name: 'Healthy Bites',
          imageAsset: 'assets/imgoffers/food1.png',
          meals: 40,
        ),
      ],
    );
  }
}