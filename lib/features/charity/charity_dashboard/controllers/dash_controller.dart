import 'package:eat2beat/features/charity/charity_dashboard/model/dash_model.dart';
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:flutter/foundation.dart';

class DashboardController extends ChangeNotifier {
  bool _isLoading = true;
  DashboardData? _data;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  DashboardData? get data => _data;
  String get searchQuery => _searchQuery;

  DashboardController() {
    _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();

    // TODO: replace with real repository calls
    await Future.delayed(const Duration(milliseconds: 500));
    _data = const DashboardData(
      summary: DashboardSummary(
        activeRestaurants: 12,
        todaysDonations: 48,
        mealsReceived: 156,
      ),
      recentDonations: [
        DonationCharityModel(
          id: '1',
          itemName: 'Caesar Salad Bowl',
          restaurantName: 'Good Eats Cafe',
          imageAsset: 'assets/imgoffers/food1.png',
          meals: 10,
          timeLabel: '2 min ago',
          status: DonationStatus.received,
        ),
        DonationCharityModel(
          id: '2',
          itemName: 'Classic Beef Burger',
          restaurantName: 'Burger House',
          imageAsset: 'assets/imgoffers/food2.png',
          meals: 8,
          timeLabel: '15 min ago',
          status: DonationStatus.received,
        ),
        DonationCharityModel(
          id: '3',
          itemName: 'Pasta Primavera',
          restaurantName: 'Pasta Palace',
          imageAsset: 'assets/imgoffers/food3.png',
          meals: 6,
          timeLabel: '45 min ago',
          status: DonationStatus.pending,
        ),
        DonationCharityModel(
          id: '4',
          itemName: 'Lentil Stew',
          restaurantName: 'Healthy Bites',
          imageAsset: 'assets/imgoffers/food4.png',
          meals: 4,
          timeLabel: '1 hr ago',
          status: DonationStatus.received,
        ),
      ],
    );
    _isLoading = false;
    notifyListeners();
  }
  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void onNotificationTap() {
    // TODO: push notifications page
    debugPrint('Notifications tapped');
  }

  void onViewAllDonations(dynamic context) {
    // TODO: navigate to donations tab or page
    debugPrint('View all tapped');
  }
}