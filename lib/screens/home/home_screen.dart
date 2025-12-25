import 'dart:ui';
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
      body: BottomBar(
        width: double.infinity,
        hideOnScroll: false,
        iconHeight: 50,
        barColor: Colors.transparent,
        offset: 10,
        fit: StackFit.expand,
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            colors: [
              Color(0x00e8ecf4),
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

                  buildNavBarItem(AppImages.homeIcon, 0),
                  buildNavBarItem(AppImages.offerIcon, 1),
                  buildNavBarItem(AppImages.impactIcon, 2),
                  buildNavBarItem(AppImages.donateIcon, 3),

              //cart indep
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  CartScreen(),
                        ),
                      );
                    },
                    child: ImageIcon(
                      AssetImage(AppImages.cartIcon),
                      color: AppColors.white,
                    ),
                  ),
                ],
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
