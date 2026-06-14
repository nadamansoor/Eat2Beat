import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static final ThemeNotifier _instance = ThemeNotifier._internal();
  factory ThemeNotifier() => _instance;
  ThemeNotifier._internal();

  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  bool _forceLightMode = true;

  bool get forceLightMode => _forceLightMode;

  set forceLightMode(bool value) {
    if (_forceLightMode != value) {
      _forceLightMode = value;
      notifyListeners();
    }
  }

  bool get isDarkMode => _isDarkMode && !forceLightMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('is_dark_mode') ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('is_dark_mode', value);
    notifyListeners();
  }

  ThemeMode get currentThemeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
