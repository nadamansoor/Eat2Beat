import 'package:eat2beat/screens/home/tabs/profile/Account_Screen.dart';
import 'package:eat2beat/screens/home/tabs/profile/settings_screen.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/menu_Item.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/profile_header.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            /// Background Pattern
            Positioned.fill(
              child: Image.asset(
                AppImages.PatternCart,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  /// Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: circleIcon(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  /// Profile Header
                  buildProfileHeader(screenWidth),

                  SizedBox(height: screenHeight * 0.02),

                  /// Menu
                  Expanded(
                    child: ListView(
                      children: [
                        buildMenuItem(
                          icon: Icons.person_outline,
                          title: "My Account",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccountScreen(),
                              ),
                            );
                          },
                        ),
                        buildMenuItem(
                          icon: Icons.credit_card,
                          title: "Payment",
                        ),
                        buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: "Addresses",
                        ),
                        buildMenuItem(
                          icon: Icons.star_border,
                          title: "My Points",
                        ),
                        buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: "Settings",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),

                        buildMenuItem(
                          icon: Icons.star_outline,
                          title: "Rate App",
                        ),
                        buildMenuItem(
                          icon: Icons.logout,
                          title: "Log out",
                          iconColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}