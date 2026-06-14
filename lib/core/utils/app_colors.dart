import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:flutter/material.dart';

class AppColors {

  static const Color purple = Color(0xff8966FA);
  
  static const Color purple50 = Color(0x80b099fc);
  static const Color purple800 = Color(0xff45337D);
  static const Color lightPurple = Color(0xffE7E0FE);
  static const Color possibleYellow = Color(0xb3fbd198);
  static const Color blue = Color(0xff3391FF);
  static const Color grey = Color(0xff808080);
  static const Color yellow = Color(0xffFFD500);
  static const Color navBarColor = Color(0xffE8ECF4);
  static const Color lightGreen = Color(0x99c2ede5);
  static const Color green800 = Color(0xff246558);
  static const Color green300 = Color(0xff85DBCA);

  static Color get light => ThemeNotifier().isDarkMode ? const Color(0xff8966FA) : const Color(0xfff9f7ff);
  static Color get black => ThemeNotifier().isDarkMode ? Colors.white : const Color(0xff1A1A1A);
  static Color get white => ThemeNotifier().isDarkMode ? const Color(0xff45337D) : Colors.white;
  static Color get grey800 => ThemeNotifier().isDarkMode ? Colors.white70 : const Color(0xff404040);

}