import 'package:eat2beat/features/charity/charity_dashboard/model/dash_model.dart';
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/foundation.dart';

class DashboardController extends ChangeNotifier {
  final CharityCubit charityCubit;
  bool _isLoading = true;
  DashboardData? _data;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  DashboardData? get data => _data;
  String get searchQuery => _searchQuery;

  DashboardController(this.charityCubit) {
    _listenToCubit();
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
      
      final summary = DashboardSummary(
        totalRequests: state.stats.totalRequests,
        approved: state.stats.totalApproved,
        pending: state.stats.totalPending,
        rejected: state.stats.totalRejected,
        confirmed: state.stats.totalConfirmed,
      );

      final recent = state.pickupRequests.take(5).map((req) {
        DonationStatus status;
        if (req.status == 'approved') {
          status = DonationStatus.received;
        } else if (req.status == 'pending') {
          status = DonationStatus.pending;
        } else {
          status = DonationStatus.cancelled;
        }
        return DonationCharityModel(
          id: req.id,
          itemName: req.description ?? 'Donation Request',
          restaurantName: req.restaurantName ?? 'Partner Restaurant',
          imageAsset: req.donationImgUrl ?? '',
          meals: 1,
          timeLabel: req.createdAt,
          status: status,
          pickupAddress: req.pickupLocation ?? '',
          notes: req.description ?? '',
        );
      }).toList();

      _data = DashboardData(
        summary: summary,
        recentDonations: recent,
      );
      notifyListeners();
    } else if (state is CharityError) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => charityCubit.loadAllData();

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void onNotificationTap() {
    debugPrint('Notifications tapped');
  }

  void onViewAllDonations(dynamic context) {
    debugPrint('View all tapped');
  }
}