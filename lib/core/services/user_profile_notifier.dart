import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileNotifier extends ChangeNotifier {
  static final UserProfileNotifier _instance = UserProfileNotifier._internal();
  factory UserProfileNotifier() => _instance;
  UserProfileNotifier._internal();

  String _currentUId = "";
  String _name = "Nada Mansour";
  String _email = "nadamansour1566@gmail.com";
  String _phone = "";
  String _phone2 = "";
  String _profileImagePath = "";

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get phone2 => _phone2;
  String get profileImagePath => _profileImagePath;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _currentUId = _prefs.getString('current_user_uid') ?? "";
    if (_currentUId.isNotEmpty) {
      await loadProfileForUser(_currentUId);
    }
  }

  Future<void> loadProfileForUser(
    String uId, {
    String? fallbackName,
    String? fallbackEmail,
  }) async {
    _currentUId = uId;
    await _prefs.setString('current_user_uid', uId);

    _name = _prefs.getString('${uId}_name') ?? fallbackName ?? "Nada Mansour";
    _email = _prefs.getString('${uId}_email') ?? fallbackEmail ?? "nadamansour1566@gmail.com";
    _phone = _prefs.getString('${uId}_phone') ?? "";
    _phone2 = _prefs.getString('${uId}_phone2') ?? "";
    _profileImagePath = _prefs.getString('${uId}_profile_image') ?? "";

    // Save loaded data to ensure it persists in SharedPreferences
    await _prefs.setString('${uId}_name', _name);
    await _prefs.setString('${uId}_email', _email);
    await _prefs.setString('${uId}_phone', _phone);
    await _prefs.setString('${uId}_phone2', _phone2);
    await _prefs.setString('${uId}_profile_image', _profileImagePath);

    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String phone2,
    required String profileImagePath,
  }) async {
    _name = name;
    _email = email;
    _phone = phone;
    _phone2 = phone2;
    _profileImagePath = profileImagePath;

    if (_currentUId.isNotEmpty) {
      await _prefs.setString('${_currentUId}_name', name);
      await _prefs.setString('${_currentUId}_email', email);
      await _prefs.setString('${_currentUId}_phone', phone);
      await _prefs.setString('${_currentUId}_phone2', phone2);
      await _prefs.setString('${_currentUId}_profile_image', profileImagePath);

      // Also update Firebase Authentication profile
      try {
        final fbUser = FirebaseAuth.instance.currentUser;
        if (fbUser != null) {
          if (name != fbUser.displayName) {
            await fbUser.updateDisplayName(name);
          }
          if (email != fbUser.email) {
            await fbUser.verifyBeforeUpdateEmail(email);
          }
        }
      } catch (e) {
        log('Exception updating Firebase user profile: ${e.toString()}');
      }
    }

    notifyListeners();
  }

  Future<void> clearActiveSession() async {
    _currentUId = "";
    await _prefs.remove('current_user_uid');

    _name = "Nada Mansour";
    _email = "nadamansour1566@gmail.com";
    _phone = "";
    _phone2 = "";
    _profileImagePath = "";

    notifyListeners();
  }
}
