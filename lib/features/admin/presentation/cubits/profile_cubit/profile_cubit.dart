import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.authRepo, required this.apiService})
      : super(ProfileInitial());

  final AuthRepo authRepo;
  final ApiService apiService;
  Map<String, dynamic> _currentProfile = {};

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final token = await authRepo.getIdToken();
      if (token == null) {
        emit(ProfileError(message: 'Unauthorized. Please login again.'));
        return;
      }
      
      // Expected role is restaurant since we are in admin features
      Map<String, dynamic> profile = {};
      try {
        profile = await apiService.getProfile(token, 'restaurant');
      } catch (_) {
        // Fallback to local cache if API fails/offline
      }
      
      _currentProfile = Map<String, dynamic>.from(profile);

      // Merge local cache
      final prefs = await SharedPreferences.getInstance();
      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'default';
      final cachedProfileString = prefs.getString('cached_profile_$userEmail');
      if (cachedProfileString != null) {
        final Map<String, dynamic> cachedData = json.decode(cachedProfileString);
        cachedData.forEach((key, value) {
          _currentProfile[key] = value;
        });
      }

      emit(ProfileLoaded(profileData: _currentProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    String? restaurantName,
    String? phone,
    String? address,
    String? openTime,
    String? closeTime,
    bool? isOpen,
  }) async {
    emit(ProfileLoading());
    try {
      final token = await authRepo.getIdToken();
      if (token == null) {
        emit(ProfileError(message: 'Unauthorized. Please login again.'));
        return;
      }

      try {
        await apiService.updateProfile(
          token,
          restaurantName: restaurantName,
          phone: phone,
          address: address,
          openTime: openTime,
          closeTime: closeTime,
          isOpen: isOpen,
        );
      } catch (_) {
        // Ignore API error for updating profile so local storage still works
      }

      // Locally update to avoid fetching again immediately
      if (restaurantName != null) _currentProfile['restaurant_name'] = restaurantName;
      if (phone != null) _currentProfile['phone'] = phone;
      if (address != null) _currentProfile['address'] = address;
      if (openTime != null) _currentProfile['open_time'] = openTime;
      if (closeTime != null) _currentProfile['close_time'] = closeTime;
      if (isOpen != null) _currentProfile['is_open'] = isOpen;

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'default';
      await prefs.setString('cached_profile_$userEmail', json.encode(_currentProfile));

      emit(ProfileUpdateSuccess(
        profileData: _currentProfile,
        message: 'Profile updated successfully!',
      ));
      
      // Reload back to standard loaded state after showing success
      emit(ProfileLoaded(profileData: _currentProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      // Re-emit loaded so UI recovers
      emit(ProfileLoaded(profileData: _currentProfile));
    }
  }
}
