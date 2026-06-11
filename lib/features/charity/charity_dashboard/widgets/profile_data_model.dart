
import 'package:flutter/material.dart';

enum MenuAction {
  organizationInfo,
  teamMembers,
  settings,
  helpSupport,
  logout,
}

class MenuItem {
  final String label;
  final IconData icon;
  final MenuAction item;
  final bool isDestructive;

  const MenuItem({
    required this.label,
    required this.icon,
    required this.item,
    this.isDestructive = false,
  });
}