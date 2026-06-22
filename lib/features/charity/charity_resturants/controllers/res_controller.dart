import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/resturants_details_charity.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';

class RestaurantsController extends ChangeNotifier {
  final CharityCubit charityCubit;
  RestaurantStatus? _activeFilter; // null = "All"
  String _searchQuery = '';
  bool _isSearchOpen = false;
  bool _isLoading = true;
  List<RestaurantModel> _allRestaurants = [];

  RestaurantStatus? get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  bool get isSearchOpen => _isSearchOpen;
  bool get isLoading => _isLoading;

  RestaurantsController(this.charityCubit) {
    _listenToCubit();
    // Fetch initial list of restaurants
    charityCubit.searchPartnerRestaurants('', false);
  }

  void _listenToCubit() {
    _updateState(charityCubit.state);
    charityCubit.stream.listen((state) {
      _updateState(state);
    });
  }

  void _updateState(CharityState state) {
    if (state is CharityLoading || state is CharityInitial) {
      _isLoading = true;
      notifyListeners();
    } else if (state is CharityLoaded) {
      _isLoading = false;
      _allRestaurants = state.searchedRestaurants.map((res) {
        return RestaurantModel(
          id: res.id,
          name: res.name,
          location: res.address ?? 'No address available',
          mealsDoanted: res.donations?.length ?? 0,
          status: res.acceptingOrders ? RestaurantStatus.active : RestaurantStatus.inactive,
          imageAsset: res.imgUrl ?? '',
        );
      }).toList();
      notifyListeners();
    } else if (state is CharityError) {
      _isLoading = false;
      notifyListeners();
    }
  }

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
    final availableOnly = status == RestaurantStatus.active;
    charityCubit.searchPartnerRestaurants(_searchQuery, availableOnly);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    final availableOnly = _activeFilter == RestaurantStatus.active;
    charityCubit.searchPartnerRestaurants(query, availableOnly);
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchOpen = !_isSearchOpen;
    if (!_isSearchOpen) {
      _searchQuery = '';
      final availableOnly = _activeFilter == RestaurantStatus.active;
      charityCubit.searchPartnerRestaurants('', availableOnly);
    }
    notifyListeners();
  }

  void onRestaurantTap(BuildContext context, RestaurantModel restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailPage(
          restaurant: restaurant,
          charityCubit: charityCubit,
        ),
      ),
    );
  }
}