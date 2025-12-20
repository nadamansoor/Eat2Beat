class TotalStatsModel{

  int mealSaved;
  int donationMade;
  int yourOrder;

  TotalStatsModel({
    required this.mealSaved,
    required this.donationMade,
    required this.yourOrder,
  });

  static final List<TotalStatsModel> totalStats = [
    TotalStatsModel(
        mealSaved: 12,
        donationMade: 67,
        yourOrder: 5
    ),

    TotalStatsModel(
        mealSaved: 40,
        donationMade: 210,
        yourOrder: 12
    ),

    TotalStatsModel(
        mealSaved: 200,
        donationMade: 980,
        yourOrder: 49
    )
  ];
}