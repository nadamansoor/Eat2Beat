import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends ChangeNotifier {
  static final LanguageNotifier _instance = LanguageNotifier._internal();
  factory LanguageNotifier() => _instance;
  LanguageNotifier._internal();

  late SharedPreferences _prefs;
  String _localeCode = 'en';

  Locale get locale => Locale(_localeCode);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _localeCode = _prefs.getString('locale_code') ?? 'en';
  }

  Future<void> setLocale(String languageCode) async {
    if (_localeCode != languageCode) {
      _localeCode = languageCode;
      await _prefs.setString('locale_code', languageCode);
      notifyListeners();
    }
  }
}
