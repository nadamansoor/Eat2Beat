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
    activeImage: 'assets/images/home_active.png',
    inActiveImage: 'assets/images/home_notactive.png',
    name: 'Dashboard',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/rest_active.png',
    inActiveImage: 'assets/images/rest_notactive.png',
    name: 'Restaurants',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_order.png',
    inActiveImage: 'assets/images/inactive_ordrs.png',
    name: 'Donations',
  ),
  BottomNaviBar(
    activeImage: 'assets/images/active_analytics.png',
    inActiveImage: 'assets/images/inactive_anaytics.png',
    name: 'Analytics',
  ),
];