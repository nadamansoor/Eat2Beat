import 'package:eat2beat/features/admin/presentation/view/notifications/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/domain/entities/notifi_model.dart';
import 'package:flutter/material.dart';

IconData iconFor(NotifType t) {
  switch (t) {
    case NotifType.order:  return Icons.receipt_long_rounded;
    case NotifType.meal:   return Icons.restaurant_menu_rounded;
    case NotifType.system: return Icons.info_outline_rounded;
  }
}

Color colorFor(NotifType t) {
  switch (t) {
    case NotifType.order:  return const Color(0xFF10B981);
    case NotifType.meal:   return kPrimary;
    case NotifType.system: return const Color(0xFFF59E0B);
  }
}

