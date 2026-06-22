import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_details_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailController extends ChangeNotifier {
  final CharityCubit charityCubit;
  RestaurantDetail? _detail;
  bool _isLoading = true;
  String? _error;

  RestaurantDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RestaurantDetailController(this.charityCubit);

  Future<void> load(String restaurantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await charityCubit.loadRestaurantProfileDetails(restaurantId);
      final state = charityCubit.state;
      if (state is CharityLoaded && state.selectedRestaurant != null) {
        final pr = state.selectedRestaurant!;
        final recent = (pr.donations ?? []).map((d) {
          return RecentDonation(
            id: d.id,
            itemName: d.description ?? 'Surplus Food',
            imageAsset: d.donationImgUrl,
            meals: 1, // Default to 1 meal, or parse from description
            timeLabel: d.createdAt,
            received: d.pickedUp == 'picked_up',
          );
        }).toList();

        _detail = RestaurantDetail(
          restaurant: RestaurantModel(
            id: pr.id,
            name: pr.name,
            location: pr.address ?? 'No Address',
            mealsDoanted: recent.length,
            status: pr.acceptingOrders ? RestaurantStatus.active : RestaurantStatus.inactive,
            imageAsset: pr.imgUrl ?? '',
          ),
          mealsThisMonth: recent.where((d) => d.received).length,
          reliabilityPercent: 95,
          about: pr.description ?? '${pr.name} is proud to support the community by sharing surplus food.',
          pickupSchedule: 'Daily\n5:00 PM – 7:00 PM',
          address: pr.address ?? 'No address available',
          contactName: 'Manager',
          contactPhone: '+20 100 000 0000',
          joinedDate: 'June 2026',
          recentDonations: recent,
        );
      } else if (state is CharityError) {
        _error = state.message;
      } else {
        _error = 'Failed to load restaurant details.';
      }
    } catch (e) {
      _error = 'Failed to load details. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> callContact() async {
    if (_detail == null) return;
    final uri = Uri(scheme: 'tel', path: _detail!.contactPhone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void onViewAllDonations() {
    debugPrint('View all donations for ${_detail?.restaurant.name}');
  }
}