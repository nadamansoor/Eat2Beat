// lib/features/admin/presentation/profile_settings/cubit/profile_state.dart


import 'package:eat2beat/features/admin/presentation/view/profile_settings/entities/profile_entitiy.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final bool isSaving;

  ProfileLoaded({required this.profile, this.isSaving = false});

  ProfileLoaded copyWith({ProfileEntity? profile, bool? isSaving}) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ProfileSaveSuccess extends ProfileState {
  final ProfileEntity profile;
  ProfileSaveSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}