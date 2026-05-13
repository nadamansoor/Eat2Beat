part of 'signin_cubit.dart';

@immutable
 sealed class SigninState{}

 final class SigninInitial extends SigninState{}
 final class SigninLoading extends SigninState{}
 final class SigninSuccess extends SigninState{
   final UserEntity userEntity;
   final String role;
   SigninSuccess({required this.userEntity, required this.role});
 }
 final class SigninPendingRestaurant extends SigninState {}
 final class SigninProfileNotFound extends SigninState {
   final String message;
   SigninProfileNotFound({required this.message});
 }
 final class SigninError extends SigninState{
   final String message;
   SigninError({required this.message});
 }