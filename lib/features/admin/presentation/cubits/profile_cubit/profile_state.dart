import 'package:flutter/foundation.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profileData;

  ProfileLoaded({required this.profileData});
}

final class ProfileUpdateSuccess extends ProfileState {
  final Map<String, dynamic> profileData;
  final String message;

  ProfileUpdateSuccess({required this.profileData, required this.message});
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
