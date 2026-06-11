import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_details_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';


class RestaurantDetailController extends ChangeNotifier {
  RestaurantDetail? _detail;
  bool _isLoading = true;
  String? _error;

  RestaurantDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(RestaurantModel restaurant) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600)); // fake network
      _detail = _mockDetail(restaurant);
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

  RestaurantDetail _mockDetail(RestaurantModel r) {
    final seedMap = <String, RestaurantDetail>{
      '1': RestaurantDetail(
        restaurant: r,
        mealsThisMonth: 24,
        reliabilityPercent: 98,
        about:
            'Good Eats Cafe is committed to reducing food waste and helping the community.',
        pickupSchedule: 'Daily\n5:00 PM – 7:00 PM',
        address: '123 Main St, Downtown',
        contactName: 'John Smith',
        contactPhone: '+20 123 456 7890',
        joinedDate: 'May 2024',
        recentDonations: const [
          RecentDonation(
            id: 'd1',
            itemName: 'Caesar Salad Bowl',
            imageAsset: 'assets/images/caesar_salad.jpg',
            meals: 10,
            timeLabel: 'Today, 5:30 PM',
            received: true,
          ),
          RecentDonation(
            id: 'd2',
            itemName: 'Grilled Chicken Wrap',
            imageAsset: 'assets/images/wrap.jpg',
            meals: 8,
            timeLabel: 'Yesterday, 6:00 PM',
            received: true,
          ),
        ],
      ),
      '2': RestaurantDetail(
        restaurant: r,
        mealsThisMonth: 18,
        reliabilityPercent: 91,
        about: 'Burger House supports local food banks with daily surplus.',
        pickupSchedule: 'Mon–Sat\n4:00 PM – 6:00 PM',
        address: '45 City Center Blvd',
        contactName: 'Sara Lee',
        contactPhone: '+20 111 222 3333',
        joinedDate: 'August 2023',
        recentDonations: const [
          RecentDonation(
            id: 'd3',
            itemName: 'Classic Burger Combo',
            imageAsset: 'assets/images/burger.jpg',
            meals: 6,
            timeLabel: 'Today, 4:45 PM',
            received: false,
          ),
        ],
      ),
    };

    return seedMap[r.id] ??
        RestaurantDetail(
          restaurant: r,
          mealsThisMonth: 10,
          reliabilityPercent: 85,
          about: '${r.name} is proud to donate surplus food daily.',
          pickupSchedule: 'Daily\n5:00 PM – 7:00 PM',
          address: r.location,
          contactName: 'Manager',
          contactPhone: '+20 100 000 0000',
          joinedDate: 'January 2024',
          recentDonations: const [],
        );
  }
}