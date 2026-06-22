import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/foundation.dart';

class DonationsController extends ChangeNotifier {
  final CharityCubit charityCubit;
  DonationStatus? _filter; // null = All
  String _searchQuery = '';
  bool _isSearchOpen = false;
  bool _isLoading = true;
  List<DonationCharityModel> _all = [];

  DonationStatus? get filter => _filter;
  String get searchQuery => _searchQuery;
  bool get isSearchOpen => _isSearchOpen;
  bool get isLoading => _isLoading;

  DonationsController(this.charityCubit) {
    _listenToCubit();
    // Refresh available donations list from server
    charityCubit.loadAllData();
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
      _all = state.availableDonations.map((don) {
        return DonationCharityModel(
          id: don.id,
          itemName: don.description ?? 'Surplus Food Donation',
          restaurantName: don.restaurantName ?? 'Partner Restaurant',
          imageAsset: don.donationImgUrl,
          meals: 1, // Default
          timeLabel: don.createdAt,
          status: DonationStatus.pending, // Display as pending request in tile details if needed
          pickupAddress: don.pickupLocation ?? '',
          notes: don.description ?? '',
          receivedBy: '',
        );
      }).toList();
      notifyListeners();
    } else if (state is CharityError) {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DonationCharityModel> get filtered => _all.where((d) {
        final matchSearch = _searchQuery.isEmpty ||
            d.itemName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d.restaurantName.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchSearch;
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