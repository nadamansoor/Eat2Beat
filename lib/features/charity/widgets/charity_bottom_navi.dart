import 'package:flutter/material.dart';

class BottomNaviBar {
  final String? activeImage, inActiveImage;
  final IconData? icon;
  final String name;

  BottomNaviBar({
    this.activeImage,
    this.inActiveImage,
    this.icon,
    required this.name,
  });
}

List<BottomNaviBar> get bottoomNavigationBarItems => [
  BottomNaviBar(
    activeImage: 'assets/images/home_icon.png',
    inActiveImage: 'assets/images/home_icon.png',
    name: 'Dashboard',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_order.png',
    inActiveImage: 'assets/images/inactive_ordrs.png',
    name: 'Donations',
  ),
  BottomNaviBar(
    icon: Icons.list_alt_rounded,
    name: 'My Requests',
  ),
  BottomNaviBar(
    icon: Icons.history_rounded,
    name: 'History',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_analytics.png',
    inActiveImage: 'assets/images/inactive_anaytics.png',
    name: 'Analytics',
  ),
];