import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/resturants_details_charity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RestaurantsController extends ChangeNotifier {
  RestaurantStatus? _activeFilter; // null = "All"
  String _searchQuery = '';
  bool _isSearchOpen = false;

  RestaurantStatus? get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  bool get isSearchOpen => _isSearchOpen;

  final List<RestaurantModel> _allRestaurants = const [
    RestaurantModel(
      id: '1',
      name: 'Good Eats Cafe',
      location: 'Downtown',
      mealsDoanted: 120,
      status: RestaurantStatus.active,
      imageAsset: 'assets/images/food.png',
    ),
    RestaurantModel(
      id: '2',
      name: 'Burger House',
      location: 'City Center',
      mealsDoanted: 85,
      status: RestaurantStatus.active,
      imageAsset: 'assets/imgoffers/food1.png',
    ),
    RestaurantModel(
      id: '3',
      name: 'Pasta Palace',
      location: 'Old Town',
      mealsDoanted: 60,
      status: RestaurantStatus.pending,
      imageAsset: 'assets/imgoffers/food2.png',
    ),
    RestaurantModel(
      id: '4',
      name: 'Healthy Bites',
      location: 'Riverside',
      mealsDoanted: 40,
      status: RestaurantStatus.active,
      imageAsset: 'assets/imgoffers/food3.png',
    ),
    RestaurantModel(
      id: '5',
      name: 'Green Corner',
      location: 'Uptown',
      mealsDoanted: 35,
      status: RestaurantStatus.inactive,
      imageAsset: 'assets/imgoffers/food4.png',
    ),
  ];

  List<RestaurantModel> get filteredRestaurants {
    return _allRestaurants.where((r) {
      final matchesStatus =
          _activeFilter == null || r.status == _activeFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void setFilter(RestaurantStatus? status) {
    if (_activeFilter == status) return;
    _activeFilter = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchOpen = !_isSearchOpen;
    if (!_isSearchOpen) _searchQuery = '';
    notifyListeners();
  }
  void onRestaurantTap(BuildContext context, RestaurantModel restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailPage(restaurant: restaurant),
      ),
    );
  }
}