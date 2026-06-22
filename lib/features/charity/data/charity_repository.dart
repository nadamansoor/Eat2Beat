import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';

class CharityRepository {
  final ApiService apiService;
  final AuthRepo authRepo;

  CharityRepository({required this.apiService, required this.authRepo});

  Future<String> _getToken() async {
    final token = await authRepo.getIdToken();
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  Future<CharityProfile> getProfile() async {
    final token = await _getToken();
    final data = await apiService.getCharityProfile(token);
    return CharityProfile.fromJson(data);
  }

  Future<void> updateProfile(CharityProfile profile) async {
    final token = await _getToken();
    await apiService.updateCharityProfile(token, profile.toJson());
  }

  Future<List<AvailableDonation>> getAvailableDonations() async {
    final token = await _getToken();
    final list = await apiService.getAvailableDonations(token);
    return list.map((item) => AvailableDonation.fromJson(item)).toList();
  }

  Future<List<DonationItem>> getDonationItems(String donationId) async {
    final token = await _getToken();
    final list = await apiService.getDonationItems(token, donationId);
    return list.map((item) => DonationItem.fromJson(item)).toList();
  }

  Future<List<PickupRequest>> getAllPickupRequests() async {
    final token = await _getToken();
    final list = await apiService.getCharityPickupsAll(token);
    return list.map((item) => PickupRequest.fromJson(item)).toList();
  }

  Future<List<PickupRequest>> getApprovedPickups() async {
    final token = await _getToken();
    final list = await apiService.getCharityPickupsApproved(token);
    return list.map((item) => PickupRequest.fromJson(item)).toList();
  }

  Future<List<PickupRequest>> getPickedUpDonations() async {
    final token = await _getToken();
    final list = await apiService.getCharityPickupsPickedUp(token);
    return list.map((item) => PickupRequest.fromJson(item)).toList();
  }

  Future<List<PickupRequest>> getRejectedPickups() async {
    final token = await _getToken();
    final list = await apiService.getCharityPickupsRejected(token);
    return list.map((item) => PickupRequest.fromJson(item)).toList();
  }

  Future<PickupRequest> requestPickup(String donationId) async {
    final token = await _getToken();
    final data = await apiService.requestPickup(token, donationId);
    return PickupRequest.fromJson(data);
  }

  Future<void> cancelPickup(String pickupId) async {
    final token = await _getToken();
    await apiService.cancelPickup(token, pickupId);
  }

  Future<void> confirmPickup(String pickupId) async {
    final token = await _getToken();
    await apiService.confirmPickup(token, pickupId);
  }

  Future<CharityStats> getStats() async {
    final token = await _getToken();
    final data = await apiService.getCharityStats(token);
    return CharityStats.fromJson(data);
  }

  Future<List<PickupRequest>> getHistory({
    String time = 'all',
    String? from,
    String? to,
    int? tzOffsetMinutes,
  }) async {
    final token = await _getToken();
    final list = await apiService.getCharityHistory(
      token,
      time: time,
      from: from,
      to: to,
      tzOffsetMinutes: tzOffsetMinutes,
    );
    return list.map((item) => PickupRequest.fromJson(item)).toList();
  }

  Future<List<PickupSchedule>> getSchedules() async {
    final token = await _getToken();
    final list = await apiService.getCharitySchedules(token);
    return list.map((item) => PickupSchedule.fromJson(item)).toList();
  }

  Future<void> confirmSchedule(String scheduleId) async {
    final token = await _getToken();
    await apiService.confirmSchedule(token, scheduleId);
  }

  Future<void> cancelSchedule(String scheduleId) async {
    final token = await _getToken();
    await apiService.cancelSchedule(token, scheduleId);
  }

  Future<List<PartnerRestaurant>> searchRestaurants(String query, bool availableOnly) async {
    final token = await _getToken();
    final list = await apiService.searchRestaurants(token, query: query, availableOnly: availableOnly);
    return list.map((item) => PartnerRestaurant.fromJson(item)).toList();
  }

  Future<PartnerRestaurant> getRestaurantProfile(String restaurantId) async {
    final token = await _getToken();
    final data = await apiService.getRestaurantProfile(token, restaurantId);
    return PartnerRestaurant.fromJson(data);
  }
}
