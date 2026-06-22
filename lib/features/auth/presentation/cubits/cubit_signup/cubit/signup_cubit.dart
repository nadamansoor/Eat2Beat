import 'package:bloc/bloc.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo, this.apiService) : super(SignupInitial());

  final AuthRepo authRepo;
  final ApiService apiService;

  String _mapWorkerRoleToUi(String role) {
    if (role == 'restaurant') return 'admin';
    if (role == 'charity') return 'charity';
    return 'user';
  }

  String _mapUiRoleToWorkerRole(String role) {
    if (role == 'admin') return 'restaurant';
    if (role == 'charity') return 'charity';
    return 'user';
  }

  /// Existing user signup — unchanged
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name, String selectedRole) async {
    emit(SignupLoading());
    final result = await authRepo.createUserWithEmailAndPassword(email, password, name);
    
    await result.fold(
      (error) async => emit(SignupError(message: error.message)),
      (userEntity) async {
        try {
          String? token = await authRepo.getIdToken();
          if (token == null) {
            emit(SignupError(message: 'Failed to retrieve authentication token.'));
            return;
          }

          String expectedWorkerRole = _mapUiRoleToWorkerRole(selectedRole);
          await apiService.createProfile(token, name, email, expectedWorkerRole);

          // After creating, fetch the profile to confirm role
          var profile = await apiService.getProfile(token, expectedWorkerRole);
          String uiRole = _mapWorkerRoleToUi(profile['role'] ?? 'user');

          emit(SignupSuccess(userEntity: userEntity, role: uiRole));
        } catch (e) {
          emit(SignupError(message: e.toString()));
        }
      },
    );
  }

  /// New restaurant signup — creates account with pending_restaurant role
  Future<void> createRestaurantAccount({
    required String email,
    required String password,
    required String userName,
    required String restaurantName,
    required String ownerFullName,
    required String phone,
    required String address,
    required String nationalId,
  }) async {
    emit(SignupLoading());
    final result = await authRepo.createUserWithEmailAndPassword(email, password, userName);

    await result.fold(
      (error) async => emit(SignupError(message: error.message)),
      (userEntity) async {
        try {
          String? token = await authRepo.getIdToken();
          if (token == null) {
            emit(SignupError(message: 'Failed to retrieve authentication token.'));
            return;
          }

          // Create profile with user role + extra details
          await apiService.createProfile(
            token,
            userName,
            email,
            'user',
            restaurantDetails: {
              'restaurant_name': restaurantName,
              'owner_full_name': ownerFullName,
              'phone': phone,
              'address': address,
              'national_id': nationalId,
            },
          );

          emit(SignupSuccess(userEntity: userEntity, role: 'user'));
        } catch (e) {
          emit(SignupError(message: e.toString()));
        }
      },
    );
  }
}
