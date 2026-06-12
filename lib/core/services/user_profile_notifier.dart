import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileNotifier extends ChangeNotifier {
  static final UserProfileNotifier _instance = UserProfileNotifier._internal();
  factory UserProfileNotifier() => _instance;
  UserProfileNotifier._internal();

  String _name = "Nada Mansour";
  String _email = "nadamansour1566@gmail.com";
  String _phone = "";
  String _phone2 = "";
  String _profileImagePath = ""; // Local file path or empty

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get phone2 => _phone2;
  String get profileImagePath => _profileImagePath;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _name = _prefs.getString('user_name') ?? "Nada Mansour";
    _email = _prefs.getString('user_email') ?? "nadamansour1566@gmail.com";
    _phone = _prefs.getString('user_phone') ?? "01558591638";
    _phone2 = _prefs.getString('user_phone2') ?? "01111111111";
    _profileImagePath = _prefs.getString('user_profile_image') ?? "";
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

    await _prefs.setString('user_name', name);
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_phone', phone);
    await _prefs.setString('user_phone2', phone2);
    await _prefs.setString('user_profile_image', profileImagePath);

    notifyListeners();
  }

  Future<void> clearProfile() async {
    _name = "Nada Mansour";
    _email = "nadamansour1566@gmail.com";
    _phone = "01558591638";
    _phone2 = "01111111111";
    _profileImagePath = "";

    await _prefs.remove('user_name');
    await _prefs.remove('user_email');
    await _prefs.remove('user_phone');
    await _prefs.remove('user_phone2');
    await _prefs.remove('user_profile_image');

    notifyListeners();
  }
}
