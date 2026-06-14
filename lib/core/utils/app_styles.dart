import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {

  static TextStyle get grey16w400 => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white.withOpacity(0.7) : AppColors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w400
  );

  static TextStyle get grey16Bold => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white.withOpacity(0.8) : AppColors.grey,
      fontSize: 16,
      fontWeight: FontWeight.bold
  );

  static TextStyle get grey13w400 => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white.withOpacity(0.6) : const Color(0xff555555),
      fontSize: 13,
      fontWeight: FontWeight.w400
  );

  static TextStyle get grey8w400 => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white.withOpacity(0.6) : const Color(0xff555555),
      fontSize: 8,
      fontWeight: FontWeight.w400
  );

  static TextStyle get black24Bold => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : AppColors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold
  );

  static const TextStyle white20Regular = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500
  );

  static const TextStyle white25Bold = TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold
  );

  static const TextStyle white16Bold = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold
  );

  static TextStyle get black16w500 => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500
  );

  static TextStyle get black16Bold => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold
  );

  static TextStyle get black20Bold => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  static TextStyle get black13w400 => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.w400
  );

  static TextStyle get black13Bold => TextStyle(
      color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.bold
  );

  static const TextStyle blue16w500 = TextStyle(
      color: AppColors.blue,
      fontSize: 16,
      fontWeight: FontWeight.w500
  );

  static const TextStyle blue14w500 = TextStyle(
      color: AppColors.blue,
      fontSize: 14,
      fontWeight: FontWeight.w500
  );

  static const TextStyle bold40Green800 = TextStyle(
      color: AppColors.green800,
      fontSize: 40,
      fontWeight: FontWeight.bold
  );

  static const TextStyle sBold14Green800 = TextStyle(
      color: AppColors.green800,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  static const TextStyle purple = TextStyle(
      color: AppColors.purple,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  static var purple32Bold;
}