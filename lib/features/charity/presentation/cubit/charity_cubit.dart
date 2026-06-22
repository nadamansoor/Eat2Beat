import 'package:bloc/bloc.dart';
import 'package:eat2beat/features/charity/data/charity_repository.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';

abstract class CharityState {}

class CharityInitial extends CharityState {}

class CharityLoading extends CharityState {}

class CharityLoaded extends CharityState {
  final CharityProfile profile;
  final CharityStats stats;
  final List<AvailableDonation> availableDonations;
  final List<PickupRequest> pickupRequests;
  final List<PickupRequest> approvedPickups;
  final List<PickupRequest> pickedUpDonations;
  final List<PickupRequest> rejectedPickups;
  final List<PickupSchedule> schedules;
  final List<PickupRequest> history;
  final List<PartnerRestaurant> searchedRestaurants;
  final PartnerRestaurant? selectedRestaurant;

  CharityLoaded({
    required this.profile,
    required this.stats,
    required this.availableDonations,
    required this.pickupRequests,
    required this.approvedPickups,
    required this.pickedUpDonations,
    required this.rejectedPickups,
    required this.schedules,
    required this.history,
    this.searchedRestaurants = const [],
    this.selectedRestaurant,
  });

  CharityLoaded copyWith({
    CharityProfile? profile,
    CharityStats? stats,
    List<AvailableDonation>? availableDonations,
    List<PickupRequest>? pickupRequests,
    List<PickupRequest>? approvedPickups,
    List<PickupRequest>? pickedUpDonations,
    List<PickupRequest>? rejectedPickups,
    List<PickupSchedule>? schedules,
    List<PickupRequest>? history,
    List<PartnerRestaurant>? searchedRestaurants,
    PartnerRestaurant? selectedRestaurant,
    bool clearSelectedRestaurant = false,
  }) {
    return CharityLoaded(
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      availableDonations: availableDonations ?? this.availableDonations,
      pickupRequests: pickupRequests ?? this.pickupRequests,
      approvedPickups: approvedPickups ?? this.approvedPickups,
      pickedUpDonations: pickedUpDonations ?? this.pickedUpDonations,
      rejectedPickups: rejectedPickups ?? this.rejectedPickups,
      schedules: schedules ?? this.schedules,
      history: history ?? this.history,
      searchedRestaurants: searchedRestaurants ?? this.searchedRestaurants,
      selectedRestaurant: clearSelectedRestaurant ? null : (selectedRestaurant ?? this.selectedRestaurant),
    );
  }
}

class CharityError extends CharityState {
  final String message;
  CharityError(this.message);
}

class CharityCubit extends Cubit<CharityState> {
  final CharityRepository charityRepository;

  CharityCubit(this.charityRepository) : super(CharityInitial());

  Future<void> loadAllData() async {
    emit(CharityLoading());
    try {
      final profile = await charityRepository.getProfile();
      final stats = await charityRepository.getStats();
      final availableDonations = await charityRepository.getAvailableDonations();
      final pickupRequests = await charityRepository.getAllPickupRequests();
      final approvedPickups = await charityRepository.getApprovedPickups();
      final pickedUpDonations = await charityRepository.getPickedUpDonations();
      final rejectedPickups = await charityRepository.getRejectedPickups();
      final schedules = await charityRepository.getSchedules();
      final history = await charityRepository.getHistory();

      emit(CharityLoaded(
        profile: profile,
        stats: stats,
        availableDonations: availableDonations,
        pickupRequests: pickupRequests,
        approvedPickups: approvedPickups,
        pickedUpDonations: pickedUpDonations,
        rejectedPickups: rejectedPickups,
        schedules: schedules,
        history: history,
      ));
    } catch (e) {
      emit(CharityError(e.toString()));
    }
  }

  Future<void> requestPickupDonation(String donationId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        final newRequest = await charityRepository.requestPickup(donationId);
        final updatedRequests = List<PickupRequest>.from(currentState.pickupRequests)..insert(0, newRequest);
        final updatedAvailable = currentState.availableDonations.where((d) => d.id != donationId).toList();
        
        // Refresh stats
        final stats = await charityRepository.getStats();

        emit(currentState.copyWith(
          pickupRequests: updatedRequests,
          availableDonations: updatedAvailable,
          stats: stats,
        ));
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> cancelPickupRequest(String pickupId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        await charityRepository.cancelPickup(pickupId);
        
        // Reload all data to refresh statuses
        await loadAllData();
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> confirmPickupRequest(String pickupId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        await charityRepository.confirmPickup(pickupId);
        
        // Reload all data to refresh statuses
        await loadAllData();
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> confirmScheduleRequest(String scheduleId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        await charityRepository.confirmSchedule(scheduleId);
        await loadAllData();
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> cancelScheduleRequest(String scheduleId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        await charityRepository.cancelSchedule(scheduleId);
        await loadAllData();
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> searchPartnerRestaurants(String query, bool availableOnly) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        final results = await charityRepository.searchRestaurants(query, availableOnly);
        emit(currentState.copyWith(searchedRestaurants: results));
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> loadRestaurantProfileDetails(String restaurantId) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        final profile = await charityRepository.getRestaurantProfile(restaurantId);
        emit(currentState.copyWith(selectedRestaurant: profile));
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  void clearSelectedRestaurant() {
    final currentState = state;
    if (currentState is CharityLoaded) {
      emit(currentState.copyWith(clearSelectedRestaurant: true));
    }
  }

  Future<void> updateCharityProfileInfo(CharityProfile profile) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        await charityRepository.updateProfile(profile);
        final updatedProfile = await charityRepository.getProfile();
        emit(currentState.copyWith(profile: updatedProfile));
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }

  Future<void> loadHistoryFiltered({
    String time = 'all',
    String? from,
    String? to,
  }) async {
    final currentState = state;
    if (currentState is CharityLoaded) {
      try {
        final tzOffset = DateTime.now().timeZoneOffset.inMinutes;
        final filteredHistory = await charityRepository.getHistory(
          time: time,
          from: from,
          to: to,
          tzOffsetMinutes: tzOffset,
        );
        emit(currentState.copyWith(history: filteredHistory));
      } catch (e) {
        emit(CharityError(e.toString()));
      }
    }
  }
}
