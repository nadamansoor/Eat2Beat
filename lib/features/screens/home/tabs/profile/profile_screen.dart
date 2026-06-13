import 'package:eat2beat/features/screens/home/tabs/profile/Account_Screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/addresses_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/points_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/settings_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/widgets/menu_Item.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/widgets/profile_header.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: AppColors.light,
        body: SafeArea(
          bottom: false,
          child: Stack(
          children: [
            /// Background Pattern
            Positioned.fill(
              child: Image.asset(
                Assets.imagesPatternCart,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddressesScreen(),
                                ),
                              );
                            },
                          ),
                        buildMenuItem(
                          icon: Icons.star_border,
                          title: "My Points",
                          onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>  PointsScreen(),
                                ),
                              );
                            },
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
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            try {
                              await getIt<AuthRepo>().signOut();
                            } catch (e) {
                              // Ignore sign out errors
                            }
                            navigator.pushNamedAndRemoveUntil(
                              AppRoutes.loginRouteName,
                              (route) => false,
                            );
                            await UserProfileNotifier().clearActiveSession();
                          },
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