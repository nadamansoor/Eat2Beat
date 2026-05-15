import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/core/services/firebase_auth_service.dart';
import 'package:eat2beat/features/auth/data/models/user_model.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;

  AuthRepoImpl({required this.firebaseAuthService});
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      var user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(UserModel.fromFirebaseUser(user));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
      return left(ServerFailure('An error occurred, please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(UserModel.fromFirebaseUser(user));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: ${e.toString()}');
      return left(ServerFailure('An error occurred, please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithGoogle() async {
    try {
      var user = await firebaseAuthService.signInWithGoogle();
      return right(UserModel.fromFirebaseUser(user));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in signInWithGoogle: ${e.toString()}');
      return left(ServerFailure('An error occurred, please try again later.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      var user = await firebaseAuthService.signInWithFacebook();
      return right(UserModel.fromFirebaseUser(user));
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in signInWithFacebook: ${e.toString()}');
      return left(ServerFailure('An error occurred, please try again later.'));
    }
  }

  @override
  Future<String?> getIdToken() async {
    return await firebaseAuthService.getIdToken();
  }

  @override
  Future<void> signOut() async {
    await firebaseAuthService.signOut();
  }

  @override
  Future<void> deleteCurrentUser() async {
    await firebaseAuthService.deleteCurrentUser();
  }
}
