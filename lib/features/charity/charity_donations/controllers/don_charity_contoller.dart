import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:flutter/foundation.dart';

class DonationsController extends ChangeNotifier {
  DonationStatus? _filter; // null = All
  String _searchQuery = '';
  bool _isSearchOpen = false;

  DonationStatus? get filter => _filter;
  String get searchQuery => _searchQuery;
  bool get isSearchOpen => _isSearchOpen;

  final List<DonationCharityModel> _all = const [
    DonationCharityModel(
      id: '1',
      itemName: 'Caesar Salad Bowl',
      restaurantName: 'Good Eats Cafe',
      imageAsset: 'assets/images/food.png',
      meals: 10,
      timeLabel: 'Today, 5:30 PM',
      status: DonationStatus.received,
      pickupAddress: '123 Main St, Downtown',
      pickupHours: '5:00 PM - 7:00 PM',
      notes: 'Freshly made salads. Please distribute within 2 hours.',
      receivedBy: 'Hope Foundation Team',
    ),
    DonationCharityModel(
      id: '2',
      itemName: 'Classic Beef Burger',
      restaurantName: 'Burger House',
      imageAsset: 'assets/imgoffers/food1.png',
      meals: 8,
      timeLabel: 'Today, 4:45 PM',
      status: DonationStatus.received,
      pickupAddress: '45 City Center Blvd',
      pickupHours: '4:00 PM - 6:00 PM',
      notes: 'Packaged and ready for pickup.',
      receivedBy: 'Hope Foundation Team',
    ),
    DonationCharityModel(
      id: '3',
      itemName: 'Pasta Primavera',
      restaurantName: 'Pasta Palace',
      imageAsset: 'assets/imgoffers/food2.png',
      meals: 6,
      timeLabel: 'Today, 3:20 PM',
      status: DonationStatus.pending,
      pickupAddress: '10 Old Town Sq',
      pickupHours: '3:00 PM - 5:00 PM',
      notes: 'Vegan-friendly pasta.',
      receivedBy: '',
    ),
    DonationCharityModel(
      id: '4',
      itemName: 'Grilled Chicken Wrap',
      restaurantName: 'Healthy Bites',
      imageAsset: 'assets/imgoffers/food3.png',
      meals: 5,
      timeLabel: 'Today, 2:10 PM',
      status: DonationStatus.received,
      pickupAddress: '7 Riverside Ave',
      pickupHours: '2:00 PM - 4:00 PM',
      notes: 'Contains gluten. Please label before distributing.',
      receivedBy: 'Green Aid Volunteers',
    ),
    DonationCharityModel(
      id: '5',
      itemName: 'Lentil Stew',
      restaurantName: 'Healthy Bites',
      imageAsset: 'assets/imgoffers/food1.png',
      meals: 4,
      timeLabel: 'Today, 1:00 PM',
      status: DonationStatus.received,
      pickupAddress: '7 Riverside Ave',
      pickupHours: '12:00 PM - 2:00 PM',
      notes: 'High-protein meal, great for families.',
      receivedBy: 'Hope Foundation Team',
    ),
  ];

  List<DonationCharityModel> get filtered => _all.where((d) {
        final matchStatus = _filter == null || d.status == _filter;
        final matchSearch = _searchQuery.isEmpty ||
            d.itemName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d.restaurantName.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchStatus && matchSearch;
      }).toList();

  // ── Actions ───────────────────────────────────────────────────────────────
  void setFilter(DonationStatus? status) {
    _filter = status;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchOpen = !_isSearchOpen;
    if (!_isSearchOpen) _searchQuery = '';
    notifyListeners();
  }
}