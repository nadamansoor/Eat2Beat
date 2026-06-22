import 'package:flutter/material.dart';

/// Central place for every color used in the app.
/// Change here → reflected everywhere.
abstract class AppColors {
  // Brand
  static const primary = Color(0xFF7B5EA7);        // purple pill / active chip
  static const primaryLight = Color(0xFFF0EBFA);   // chip background (unselected)
  static const primaryChipText = Color(0xFF7B5EA7); // unselected chip label

  // Status badges
  static const statusActive = Color(0xFF4CAF50);
  static const statusPending = Color(0xFFF5A623);
  static const statusInactive = Color(0xFF9E9E9E);

  // Surfaces
  static const scaffoldBg = Color(0xFFF4F2FB);
  static const cardBg = Colors.white;

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF7A7A9D);
}