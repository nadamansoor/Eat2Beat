import 'package:bloc/bloc.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/admin/data/repos/admin_donation_repository.dart';
import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';
import 'admin_donation_state.dart';

class AdminDonationCubit extends Cubit<AdminDonationState> {
  final AuthRepo authRepo;
  final AdminDonationRepository donationRepo;

  AdminDonationCubit({
    required this.authRepo,
    required this.donationRepo,
  }) : super(AdminDonationInitial());

  Future<void> loadAll() async {
    emit(AdminDonationLoading());
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(const AdminDonationError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    try {
      final donationsRes = await donationRepo.getRestaurantDonations(token);
      final requestsRes = await donationRepo.getAdminPickupRequests(token);
      final schedulesRes = await donationRepo.getAdminSchedules(token);
      final historyRes = await donationRepo.getAdminDonationHistory(token);
      final notificationsRes = await donationRepo.getNotifications(token);
      final charitiesRes = await donationRepo.searchCharities(token, '');

      List<AdminDonation> donations = [];
      List<AdminPickupRequest> requests = [];
      List<AdminPickupSchedule> schedules = [];
      List<AdminDonation> history = [];
      List<AdminNotification> notifications = [];
      List<AdminCharityProfile> charities = [];

      donationsRes.fold((_) {}, (r) => donations = r);
      requestsRes.fold((_) {}, (r) => requests = r);
      schedulesRes.fold((_) {}, (r) => schedules = r);
      historyRes.fold((_) {}, (r) => history = r);
      notificationsRes.fold((_) {}, (r) => notifications = r);
      charitiesRes.fold((_) {}, (r) => charities = r);

      emit(AdminDonationLoaded(
        donations: donations,
        pickupRequests: requests,
        schedules: schedules,
        history: history,
        notifications: notifications,
        charities: charities,
      ));
    } catch (e) {
      emit(AdminDonationError(message: e.toString()));
    }
  }

  Future<void> loadPickupRequests() async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.getAdminPickupRequests(token);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(pickupRequests: r, clearError: true)),
    );
  }

  Future<void> loadSchedules() async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.getAdminSchedules(token);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(schedules: r, clearError: true)),
    );
  }

  Future<void> loadHistory() async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.getAdminDonationHistory(token);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(history: r, clearError: true)),
    );
  }

  Future<void> loadMyDonations() async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.getRestaurantDonations(token);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(donations: r, clearError: true)),
    );
  }

  Future<void> loadNotifications() async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.getNotifications(token);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(notifications: r, clearError: true)),
    );
  }

  Future<void> approveRequest(String id) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.approvePickupRequest(token, id);
    res.fold(
      (failure) => emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) async {
        emit(currentState.copyWith(isSubmitting: false, successMessage: 'Request approved successfully!'));
        await loadPickupRequests();
        await loadSchedules();
      },
    );
  }

  Future<void> rejectRequest(String id) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.rejectPickupRequest(token, id);
    res.fold(
      (failure) => emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) async {
        emit(currentState.copyWith(isSubmitting: false, successMessage: 'Request rejected successfully.'));
        await loadPickupRequests();
        await loadHistory();
      },
    );
  }

  Future<void> schedulePickup(String pickupId, String scheduledAt, String? notes) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final body = {
      'pickup_id': pickupId,
      'scheduled_at': scheduledAt,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final res = await donationRepo.schedulePickup(token, body);
    res.fold(
      (failure) => emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) async {
        emit(currentState.copyWith(isSubmitting: false, successMessage: 'Pickup scheduled successfully!'));
        await loadPickupRequests();
        await loadSchedules();
      },
    );
  }

  Future<void> reschedulePickup(String scheduleId, String scheduledAt, String? notes) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final body = {
      'schedule_id': scheduleId,
      'scheduled_at': scheduledAt,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final res = await donationRepo.reschedulePickup(token, body);
    res.fold(
      (failure) => emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) async {
        emit(currentState.copyWith(isSubmitting: false, successMessage: 'Rescheduled successfully!'));
        await loadSchedules();
      },
    );
  }

  Future<void> addDonation({
    required String description,
    required String pickupLocation,
    required String donationImgBase64,
    required List<Map<String, dynamic>> items,
  }) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    // Body schema for add-donation:
    final body = {
      'description': description,
      'pickup_location': pickupLocation,
      'donation_img_base64': donationImgBase64,
    };

    final donationRes = await donationRepo.addRestaurantDonation(token, body);
    await donationRes.fold(
      (failure) async {
        emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message));
      },
      (newDonation) async {
        // Add items sequentially or asynchronously
        bool itemsFailed = false;
        String? itemError;

        for (var item in items) {
          final itemBody = {
            'donation_id': newDonation.id,
            'item_name': item['item_name'],
            'quantity': item['quantity'],
            'donation_item_img_base64': item['donation_item_img_base64'],
            if (item['description'] != null) 'description': item['description'],
          };
          final itemRes = await donationRepo.addRestaurantDonationItem(token, itemBody);
          itemRes.fold(
            (failure) {
              itemsFailed = true;
              itemError = failure.message;
            },
            (_) {},
          );
        }

        if (itemsFailed) {
          emit(currentState.copyWith(
            isSubmitting: false,
            errorMessage: 'Donation created, but some items failed to add: $itemError',
          ));
        } else {
          emit(currentState.copyWith(
            isSubmitting: false,
            successMessage: 'Donation created successfully with items!',
          ));
        }
        await loadMyDonations();
      },
    );
  }

  Future<void> deleteDonation(String donationId) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.removeRestaurantDonation(token, donationId);
    res.fold(
      (failure) => emit(currentState.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) async {
        emit(currentState.copyWith(isSubmitting: false, successMessage: 'Donation deleted successfully.'));
        await loadMyDonations();
      },
    );
  }

  Future<void> searchCharities(String query) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    final res = await donationRepo.searchCharities(token, query);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (r) => emit(currentState.copyWith(charities: r, charitySearchQuery: query, clearError: true)),
    );
  }

  Future<void> markNotificationsRead({List<String>? ids}) async {
    final currentState = state;
    if (currentState is! AdminDonationLoaded) return;

    final token = await authRepo.getIdToken();
    if (token == null) return;

    // If ids is empty or null, we collect all unread ids to mark them all read
    List<String> toMark = [];
    if (ids == null || ids.isEmpty) {
      toMark = currentState.notifications
          .where((n) => n.readAt == null)
          .map((n) => n.id)
          .toList();
    } else {
      toMark = ids;
    }

    if (toMark.isEmpty) return;

    final res = await donationRepo.markNotificationsAsRead(token, ids: toMark);
    res.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (_) async {
        await loadNotifications();
      },
    );
  }

  void clearAlerts() {
    final currentState = state;
    if (currentState is AdminDonationLoaded) {
      emit(currentState.copyWith(clearError: true, clearSuccess: true));
    }
  }
}
