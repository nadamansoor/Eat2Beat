import 'dart:ui';
import 'package:eat2beat/features/screens/chatbot/chatbot_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/cart_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/order_history/order_history_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/home_tab/home_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/impact/impact_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/offers/offers_tab.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
// ... (rest of imports remain)


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return HomeTab();
      case 1:
        return OffersTab();
      case 2:
        return ImpactTab();
      case 3:
        return OrderHistoryTab(onSwitchTab: (idx) {
          setState(() {
            selectedIndex = idx;
          });
        });
      case 4:
        return CartScreen();
      default:
        return HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Approximate height of the floating bottom bar (vertical padding * 2 + icon)
    final double bottomBarHeight = screenHeight * 0.024 + 65;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: BottomBar(
              width: double.infinity,
              hideOnScroll: false,
              iconHeight: 65,
              barColor: Colors.white.withOpacity(0.15),
              offset: 0,
              fit: StackFit.expand,
              barDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [Color(0xffE8ECF4), Color(0xffE8ECF4)],
                ),
              ),

              body: (context, controller) {
                return Stack(
                  children: [
                    // ── active tab content ──
                    _buildTab(selectedIndex),

                    // ── FAB floating above the bottom bar ──
                    if (selectedIndex != 4)
                      Positioned(
                        right: 24,
                        bottom: bottomBarHeight + 45,
                        child: _buildFAB(),
                      ),
                  ],
                );
              },

              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildNavBarItem(Assets.imagesHomeIcon, "Home", 0),
                        buildNavBarItem(Assets.imagesOfferIcon, "Offers", 1),
                        buildNavBarItem(Assets.imagesImpactIcon, "Impact", 2),
                        buildNavBarItem(Assets.imagesInactiveOrdrs, "Orders", 3),
                        // cart tab — same style as the others
                        buildNavBarItem(Assets.imagesCarrtIcon, "Cart", 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNavBarItem(String icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              color: isSelected ? AppColors.purple : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.purple : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // light lavender purple — matches the reference image
        gradient: const RadialGradient(
          colors: [Color(0xffA78BCA), Color(0xff7B5EA7)],
          center: Alignment(-0.3, -0.4),
          radius: 1.1,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff7B5EA7).withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotScreen()),
            );
          },
          child: const Center(
            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
