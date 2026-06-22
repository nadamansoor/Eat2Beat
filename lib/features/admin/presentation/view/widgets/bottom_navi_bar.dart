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
    activeImage: 'assets/images/active_meal.png',
    inActiveImage: 'assets/images/inactive_meal.png',
    name: 'Meals',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_up.png',
    inActiveImage: 'assets/images/inactive_upload.png',
    name: 'Upload',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_order.png',
    inActiveImage: 'assets/images/inactive_ordrs.png',
    name: 'Orders',
  ),
  BottomNaviBar(
    icon: Icons.volunteer_activism,
    name: 'Donation',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_analytics.png',
    inActiveImage: 'assets/images/inactive_anaytics.png',
    name: 'Analytics',
  ),
];