import 'package:dartz/dartz.dart';
import 'package:eat2beat/core/errors/failure.dart';
import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future <Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email, String password, String name);
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, UserEntity>> signinWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithFacebook();
  Future<String?> getIdToken();
  Future<void> signOut();
  Future<void> deleteCurrentUser();
}