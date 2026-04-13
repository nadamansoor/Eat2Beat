import 'package:bloc/bloc.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/foundation.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;
  
  Future<void> SignIn (String email , String password) async{
    emit(SigninLoading());
    var result = await authRepo.signinWithEmailAndPassword(
      email,
      password,
      );
    result.fold(
      (Error) => emit(SigninError(message: Error.message)),
      (UserEntity) => emit(SigninSuccess(userEntity: UserEntity))
    );  
  }
  Future<void> signInWithGoogle() async {
    emit(SigninLoading());
    var result = await authRepo.signinWithGoogle();
    result.fold(
      (error) => emit(SigninError(message: error.message)),
      (userEntity) => emit(SigninSuccess(userEntity: userEntity)),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SigninLoading());
    var result = await authRepo.signInWithFacebook();
    result.fold(
      (error) => emit(SigninError(message: error.message)),
      (userEntity) => emit(SigninSuccess(userEntity: userEntity)),
    );
  }
}
