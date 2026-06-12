import 'dart:developer';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in createUserWithEmailAndPassword: ${e.message} and code is ${e.code}',
      );
      if (e.code == 'weak-password') {
        throw CustomExceptions(message: 'This password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw CustomExceptions(message: 'This email is already in use  ');
      } else if (e.code == 'network-request-failed') {
        throw CustomExceptions(
          message: 'Please check your internet connection and try again',
        );
      } else {
        throw CustomExceptions(
          message: e.message ?? 'An error occurred, please try again later.',
        );
      }
    } catch (e) {
      log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
      throw CustomExceptions(
        message: e.toString(),
      );
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in createUserWithEmailAndPassword: ${e.message} and code is ${e.code}',
      );
      if (e.code == 'user-not-found') {
        throw CustomExceptions(message: 'The email or password is incorrect');
      } else if (e.code == 'wrong-password') {
        throw CustomExceptions(message: 'The email or password is incorrect');
      } else if (e.code == 'network-request-failed') {
        throw CustomExceptions(
          message: 'Please check your internet connection and try again',
        );
      } else {
        throw CustomExceptions(
          message: e.message ?? 'An error occurred, please try again later.',
        );
      }
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: ${e.toString()}');
      throw CustomExceptions(
        message: e.toString(),
      );
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }

  Future<User> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    )).user!;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<String?> getIdToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<void> deleteCurrentUser() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }
}
