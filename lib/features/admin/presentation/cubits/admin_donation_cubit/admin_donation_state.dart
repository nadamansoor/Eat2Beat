import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';

abstract class AdminDonationState {
  const AdminDonationState();
}

class AdminDonationInitial extends AdminDonationState {}

class AdminDonationLoading extends AdminDonationState {}

class AdminDonationLoaded extends AdminDonationState {
  final List<AdminDonation> donations;
  final List<AdminPickupRequest> pickupRequests;
  final List<AdminPickupSchedule> schedules;
  final List<AdminDonation> history;
  final List<AdminCharityProfile> charities;
  final List<AdminNotification> notifications;
  final String charitySearchQuery;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const AdminDonationLoaded({
    required this.donations,
    required this.pickupRequests,
    required this.schedules,
    required this.history,
    required this.charities,
    required this.notifications,
    this.charitySearchQuery = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  AdminDonationLoaded copyWith({
    List<AdminDonation>? donations,
    List<AdminPickupRequest>? pickupRequests,
    List<AdminPickupSchedule>? schedules,
    List<AdminDonation>? history,
    List<AdminCharityProfile>? charities,
    List<AdminNotification>? notifications,
    String? charitySearchQuery,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AdminDonationLoaded(
      donations: donations ?? this.donations,
      pickupRequests: pickupRequests ?? this.pickupRequests,
      schedules: schedules ?? this.schedules,
      history: history ?? this.history,
      charities: charities ?? this.charities,
      notifications: notifications ?? this.notifications,
      charitySearchQuery: charitySearchQuery ?? this.charitySearchQuery,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class AdminDonationError extends AdminDonationState {
  final String message;
  const AdminDonationError({required this.message});
}
