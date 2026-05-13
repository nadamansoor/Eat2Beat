import 'package:bloc/bloc.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/foundation.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo, this.apiService) : super(SigninInitial());
  final AuthRepo authRepo;
  final ApiService apiService;

  String _mapWorkerRoleToUi(String role) {
    if (role == 'restaurant') return 'admin';
    return 'user';
  }

  String _mapUiRoleToWorkerRole(String role) {
    if (role == 'admin' || role == 'restaurant') return 'restaurant';
    return 'user';
  }

  Future<void> SignIn(String email, String password, String selectedRole) async {
    emit(SigninLoading());
    var result = await authRepo.signinWithEmailAndPassword(email, password);
    
    await result.fold(
      (error) async {
        emit(SigninError(message: error.message));
      },
      (userEntity) async {
        try {
          String? token = await authRepo.getIdToken();
          if (token == null) {
            await authRepo.signOut();
            emit(SigninError(message: 'Failed to get authentication token.'));
            return;
          }

          String expectedWorkerRole = _mapUiRoleToWorkerRole(selectedRole);
          var profile = await apiService.getProfile(token, expectedWorkerRole);
          
          String uiRole = _mapWorkerRoleToUi(profile['role'] ?? 'user');
          emit(SigninSuccess(userEntity: userEntity, role: uiRole));
        } on RoleMismatchException catch (_) {
        
          emit(SigninError(message: 'This account is not this role. try again'));
        } on ProfileNotFoundException catch (_) {
          emit(SigninProfileNotFound(message: 'No profile in Supabase yet. Please create an account first.'));
        } catch (e) {
          emit(SigninError(message: e.toString()));
        }
      }
    );
  }

  Future<void> signInWithGoogle(String selectedRole) async {
    emit(SigninLoading());
    if (selectedRole != 'user') {
      emit(SigninError(message: 'Access denied. Google login is available for User role only.'));
      return;
    }

    var result = await authRepo.signinWithGoogle();
    await result.fold(
      (error) async {
        emit(SigninError(message: error.message));
      },
      (userEntity) async {
        try {
          String? token = await authRepo.getIdToken();
          if (token == null) {
            await authRepo.signOut();
            emit(SigninError(message: 'Failed to get authentication token.'));
            return;
          }

          String expectedWorkerRole = 'user';
          Map<String, dynamic>? profile;
          try {
            profile = await apiService.getProfile(token, expectedWorkerRole);
          } on ProfileNotFoundException catch (_) {
            await Future.delayed(const Duration(milliseconds: 600));
            profile = await apiService.getProfile(token, expectedWorkerRole);
          }

          String uiRole = _mapWorkerRoleToUi(profile['role'] ?? 'user');
          emit(SigninSuccess(userEntity: userEntity, role: uiRole));
        } on RoleMismatchException catch (_) {
          emit(SigninError(message: 'This account is not this role.'));
        } on ProfileNotFoundException catch (_) {
          emit(SigninError(message: 'Failed to create account automatically. Please try again.'));
        } catch (e) {
          emit(SigninError(message: e.toString()));
        }
      }
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SigninLoading());
    var result = await authRepo.signInWithFacebook();
    result.fold(
      (error) => emit(SigninError(message: error.message)),
      (userEntity) => emit(SigninSuccess(userEntity: userEntity, role: 'user')),
    );
  }
}
