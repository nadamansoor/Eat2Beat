// lib/features/admin/presentation/profile_settings/cubit/profile_cubit.dart

import 'package:eat2beat/features/admin/presentation/view/profile_settings/cubits/profile_settings_state.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/entities/profile_entitiy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  // ── Load profile data (replace with real repo call) ───────────────
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      // TODO: replace with repository call
      await Future.delayed(const Duration(milliseconds: 300));
      emit(ProfileLoaded(
        profile: const ProfileEntity(
          restaurantName: 'Nada Seafood Restaurant',
          email: 'restaurant5@eat2beat.com',
          phone: '+20 100 000 0000',
          address: '123 Tahrir St, Cairo',
          isOpen: true,
          notificationsEnabled: true,
          openTime: '09:00 AM',
          closeTime: '11:00 PM',
          language: 'English',
        ),
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // ── Field updates ─────────────────────────────────────────────────
  void updateName(String value) => _update((p) => p.copyWith(restaurantName: value));
  void updateEmail(String value) => _update((p) => p.copyWith(email: value));
  void updatePhone(String value) => _update((p) => p.copyWith(phone: value));
  void updateAddress(String value) => _update((p) => p.copyWith(address: value));
  void updateOpenTime(String value) => _update((p) => p.copyWith(openTime: value));
  void updateCloseTime(String value) => _update((p) => p.copyWith(closeTime: value));
  void toggleIsOpen(bool value) => _update((p) => p.copyWith(isOpen: value));
  void toggleNotifications(bool value) => _update((p) => p.copyWith(notificationsEnabled: value));

  void _update(ProfileEntity Function(ProfileEntity) updater) {
    final current = state;
    if (current is ProfileLoaded) {
      emit(current.copyWith(profile: updater(current.profile)));
    }
  }

  // ── Save ──────────────────────────────────────────────────────────
  Future<void> saveProfile({String? newPassword}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    emit(current.copyWith(isSaving: true));
    try {
      // TODO: replace with repository call
      await Future.delayed(const Duration(seconds: 1));
      emit(ProfileSaveSuccess(current.profile));
      emit(current.copyWith(isSaving: false));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}