class BottomNaviBar {
  final String activeImage , inActiveImage;
  final String name;

  BottomNaviBar({
    required this.activeImage,
    required this.inActiveImage,
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
    activeImage: 'assets/images/active_analytics.png',
    inActiveImage: 'assets/images/inactive_anaytics.png',
    name: 'Analytics',
  ),
];