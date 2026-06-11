class AnalyticsSummary {
  final int totalDonations;
  final int totalMeals;
  final int activeRestaurants;
  final String dateRangeLabel;

  const AnalyticsSummary({
    required this.totalDonations,
    required this.totalMeals,
    required this.activeRestaurants,
    required this.dateRangeLabel,
  });
}

class ChartPoint {
  final String label; // x-axis label e.g. "May 1"
  final double value;
  const ChartPoint({required this.label, required this.value});
}

class TopRestaurant {
  final String name;
  final String imageAsset;
  final int meals;
  const TopRestaurant({
    required this.name,
    required this.imageAsset,
    required this.meals,
  });
}

class AnalyticsData {
  final AnalyticsSummary summary;
  final List<ChartPoint> chartPoints;
  final List<TopRestaurant> topRestaurants;

  const AnalyticsData({
    required this.summary,
    required this.chartPoints,
    required this.topRestaurants,
  });
}