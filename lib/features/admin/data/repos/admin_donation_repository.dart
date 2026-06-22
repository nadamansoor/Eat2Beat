import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';

class AdminDonationRepository {
  final ApiService apiService;

  AdminDonationRepository({required this.apiService});

  Future<Either<Failure, List<AdminDonation>>> getRestaurantDonations(String token) async {
    try {
      final list = await apiService.getRestaurantDonations(token);
      final donations = list.map((json) => AdminDonation.fromJson(json)).toList();
      return right(donations);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading donations.'));
    }
  }

  Future<Either<Failure, List<AdminDonationItem>>> getRestaurantDonationItems(
    String token,
    String donationId,
  ) async {
    try {
      final list = await apiService.getRestaurantDonationItems(token, donationId);
      final items = list.map((json) => AdminDonationItem.fromJson(json)).toList();
      return right(items);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading donation items.'));
    }
  }

  Future<Either<Failure, AdminDonation>> addRestaurantDonation(
    String token,
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await apiService.addRestaurantDonation(token, body);
      return right(AdminDonation.fromJson(json));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while adding donation.'));
    }
  }

  Future<Either<Failure, void>> removeRestaurantDonation(String token, String donationId) async {
    try {
      await apiService.removeRestaurantDonation(token, donationId);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while deleting donation.'));
    }
  }

  Future<Either<Failure, AdminDonationItem>> addRestaurantDonationItem(
    String token,
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await apiService.addRestaurantDonationItem(token, body);
      return right(AdminDonationItem.fromJson(json));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while adding donation item.'));
    }
  }

  Future<Either<Failure, void>> removeRestaurantDonationItem(String token, String itemId) async {
    try {
      await apiService.removeRestaurantDonationItem(token, itemId);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while deleting donation item.'));
    }
  }

  Future<Either<Failure, List<AdminPickupRequest>>> getAdminPickupRequests(String token) async {
    try {
      final list = await apiService.getAdminPickupRequests(token);
      final requests = list.map((json) => AdminPickupRequest.fromJson(json)).toList();
      return right(requests);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading pickup requests.'));
    }
  }

  Future<Either<Failure, void>> approvePickupRequest(String token, String pickupId) async {
    try {
      await apiService.approvePickupRequest(token, pickupId);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while approving pickup request.'));
    }
  }

  Future<Either<Failure, void>> rejectPickupRequest(String token, String pickupId) async {
    try {
      await apiService.rejectPickupRequest(token, pickupId);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while rejecting pickup request.'));
    }
  }

  Future<Either<Failure, AdminPickupSchedule>> schedulePickup(
    String token,
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await apiService.schedulePickup(token, body);
      return right(AdminPickupSchedule.fromJson(json));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while scheduling pickup.'));
    }
  }

  Future<Either<Failure, AdminPickupSchedule>> reschedulePickup(
    String token,
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await apiService.reschedulePickup(token, body);
      return right(AdminPickupSchedule.fromJson(json));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while rescheduling pickup.'));
    }
  }

  Future<Either<Failure, List<AdminPickupSchedule>>> getAdminSchedules(String token) async {
    try {
      final list = await apiService.getAdminSchedules(token);
      final schedules = list.map((json) => AdminPickupSchedule.fromJson(json)).toList();
      return right(schedules);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading schedules.'));
    }
  }

  Future<Either<Failure, List<AdminDonation>>> getAdminDonationHistory(String token) async {
    try {
      final list = await apiService.getAdminDonationHistory(token);
      final donations = list.map((json) => AdminDonation.fromJson(json)).toList();
      return right(donations);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading donation history.'));
    }
  }

  Future<Either<Failure, List<AdminCharityProfile>>> searchCharities(
    String token,
    String query,
  ) async {
    try {
      final list = await apiService.searchCharities(token, query);
      final charities = list.map((json) => AdminCharityProfile.fromJson(json)).toList();
      return right(charities);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while searching charities.'));
    }
  }

  Future<Either<Failure, AdminCharityProfile>> getCharityProfile(
    String token,
    String charityId,
  ) async {
    try {
      final json = await apiService.getAdminCharityProfile(token, charityId);
      return right(AdminCharityProfile.fromJson(json));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading charity profile.'));
    }
  }

  Future<Either<Failure, List<AdminNotification>>> getNotifications(
    String token, {
    bool unreadOnly = false,
  }) async {
    try {
      final list = await apiService.getNotifications(token, unreadOnly: unreadOnly);
      final notifications = list.map((json) => AdminNotification.fromJson(json)).toList();
      return right(notifications);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while loading notifications.'));
    }
  }

  Future<Either<Failure, void>> markNotificationsAsRead(String token, {List<String>? ids}) async {
    try {
      await apiService.markNotificationsAsRead(token, ids: ids);
      return right(null);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('An error occurred while marking notifications as read.'));
    }
  }
}
