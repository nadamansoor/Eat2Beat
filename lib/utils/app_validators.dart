import 'package:flutter/cupertino.dart';

class AppValidators {

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email required";
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(pattern).hasMatch(value)) {
      return "Invalid email";
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if(value == null || value.trim().isEmpty){
      return "Please, Enter your name";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password required" ;
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters" ;
    }
    return null;
  }

  static String? confirmValidator(
      String? value ,
      {required TextEditingController passwordController}) {
    if (value == null || value.trim().isEmpty) {
      return "confirm Password required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if(value != passwordController.text){
      return "confirmed password doesn't match password";
    }
    return null;
  }
}