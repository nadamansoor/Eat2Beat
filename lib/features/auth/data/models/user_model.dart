import 'package:eat2beat/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity{
  UserModel({required super.name, required super.email, required super.UId});
  factory UserModel.fromFirebaseUser(User user)
  {
    return UserModel 
    (
      name: user.displayName ?? '',
      email: user.email ?? '',
      UId: user.uid
    );
  }
}