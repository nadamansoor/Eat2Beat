import 'package:eat2beat/screens/home/tabs/cart/cart_tab.dart';
import 'package:eat2beat/screens/home/tabs/donation/donation_tab.dart';
import 'package:eat2beat/screens/home/tabs/home_tab/home_tab.dart';
import 'package:eat2beat/screens/home/tabs/impact/impact_tab.dart';
import 'package:eat2beat/screens/home/tabs/offers/offers_tab.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    HomeTab(),
    OffersTab(),
    ImpactTab(),
    DonationTab(),
    CartTab(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;             // 375
    var screenHeight = MediaQuery.of(context).size.height;           // 812
    return Scaffold(
      //
      body: BottomBar(
        width: double.infinity,
        hideOnScroll: false,
        iconHeight: 50,
        barColor: Colors.transparent,
        offset: 10,
        fit: StackFit.expand,
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
              colors: [
                Color(0x1A000000),
                Color(0xFFE8ECF4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),

        body: (context, controller) {
          return tabs[selectedIndex];
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.03
          ),
          child: DefaultTabController(
            length: 5,
            child: TabBar(
              indicator: BoxDecoration(),
              dividerColor: Colors.transparent,
              tabs: [
                buildNavBarItem(
                  icon: AppImages.homeIcon,
                  index: 0,
                ),
                buildNavBarItem(
                  icon: AppImages.offerIcon,
                  index: 1,
                ),
                buildNavBarItem(
                  icon: AppImages.impactIcon,
                  index: 2,
                ),
                buildNavBarItem(
                  icon: AppImages.donateIcon,
                  index: 3,
                ),
                buildNavBarItem(
                  icon: AppImages.cartIcon,
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildNavBarItem({required String icon, required int index}) {
    return InkWell(
      onTap: () {
        selectedIndex = index;
        setState(() {});
      },
      child: ImageIcon(AssetImage(icon),
        color: selectedIndex == index ? AppColors.purple
            : AppColors.white,),
    );
  }
}
