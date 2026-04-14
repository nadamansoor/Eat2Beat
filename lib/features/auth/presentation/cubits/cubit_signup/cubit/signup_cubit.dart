// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());

  final AuthRepo authRepo ;
  
Future<void> createUserWithEmailAndPassword(
    String email, String password, String name, String role) async {
  emit(SignupLoading());
  final result = await authRepo.createUserWithEmailAndPassword(
      email, password, name);
  result.fold(
    (error) => emit(SignupError(message: error.message)),
    (userEntity) => emit(SignupSuccess(userEntity: userEntity, role: role)), // ✅
  );
}

}
