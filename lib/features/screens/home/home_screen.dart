import 'dart:ui';
import 'package:eat2beat/features/screens/home/tabs/cart/cart_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/donation/donation_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/home_tab/home_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/impact/impact_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/offers/offers_tab.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = [
    HomeTab(),
    OffersTab(),
    ImpactTab(),
    DonationTab(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BottomBar(
          width: double.infinity,
          hideOnScroll: false,
          iconHeight: 50,
          barColor: Colors.white.withOpacity(0.15),
          offset: 0,
          fit: StackFit.expand,
          barDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [
                Color(0xffE8ECF4),
                Color(0xffE8ECF4),
              ],
            ),
          ),

          body: (context, controller) {
            return tabs[selectedIndex];
          },

          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    buildNavBarItem(Assets.imagesHomeIcon, 0),
                    buildNavBarItem(Assets.imagesOfferIcon, 1),
                    buildNavBarItem(Assets.imagesImpactIcon, 2),
                    buildNavBarItem(Assets.imagesDonationIcon, 3),

                    // cart indep
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartScreen(),
                          ),
                        );
                      },
                      child: ImageIcon(
                        AssetImage(Assets.imagesCarrtIcon),
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(String icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: ImageIcon(
        AssetImage(icon),
        color: selectedIndex == index
            ? AppColors.purple
            : AppColors.white,
      ),
    );
  }
}

