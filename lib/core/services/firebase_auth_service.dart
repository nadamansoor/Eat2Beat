import 'dart:developer';
import 'package:eat2beat/core/errors/exceptions.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseAuthService
{
  Future <User> createUserWithEmailAndPassword({required String email ,required String password}) async
  {
        try {
        final credential = 
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential.user!;
      } on FirebaseAuthException catch (e) {
        log(
          'Exception in createUserWithEmailAndPassword: ${e.message} and code is ${e.code}',
        );
        if (e.code == 'weak-password') {
          throw CustomExceptions(message:'لا يمكنك ان تكون كلمة المرور قصيرة');
        } else if (e.code == 'email-already-in-use') {
          throw CustomExceptions(
              message: 'لقد تم استخدام هذا البريد الإلكتروني من قبل');
        } else if (e.code == 'network-request-failed') {
          throw CustomExceptions(
              message: 'تأكد من الاتصال بالانترنت و المحاولة مرة أخرى');
          
        }
        
        else{
          throw CustomExceptions(
              message: 'لقد حدث خطأ ما يرجى المحاولة مرة أخرى');
        }
      }
       catch (e) {
        log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
        throw CustomExceptions(
          message: 'لقد حدث خطأ ما يرجى المحاولة مرة أخرى',
        );
    }
  }

  Future<User> signInWithEmailAndPassword({required String email ,required String password}) async
  {
    try {
        final credential = 
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential.user!;
      } on FirebaseAuthException catch (e) {
        log(
          'Exception in createUserWithEmailAndPassword: ${e.message} and code is ${e.code}',
        );
        if (e.code == 'user-not-found') {
          throw CustomExceptions(message:'البريد الإلكتروني او كلمة المرور غير صحيح');
        } else if (e.code == 'wrong-password') {
          throw CustomExceptions(
              message: 'البريد الإلكتروني او كلمة المرور غير صحيح');
        } else if (e.code == 'network-request-failed') {
          throw CustomExceptions(
              message: 'تأكد من الاتصال بالانترنت و المحاولة مرة أخرى');
          
        }
        
        else{
          throw CustomExceptions(
              message: 'لقد حدث خطأ ما يرجى المحاولة مرة أخرى');
        }
      }
       catch (e) {
        log('Exception in createUserWithEmailAndPassword: ${e.toString()}');

        throw CustomExceptions(
          message: 'لقد حدث خطأ ما يرجى المحاولة مرة أخرى',
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
  return( await FirebaseAuth.instance.signInWithCredential(credential)).user!;
}
  Future<User> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  // Once signed in, return the UserCredential
  return (await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)).user!;
}

}
