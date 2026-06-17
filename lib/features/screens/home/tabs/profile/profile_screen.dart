import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/Account_Screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/theme_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/widgets/menu_Item.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/widgets/profile_header.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/language_screen.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.light,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                /// Background Pattern
                Positioned.fill(
                  child: Image.asset(
                    ThemeNotifier().isDarkMode ? Assets.imagesPattern : Assets.imagesPatternCart,
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
                          title: S.of(context).myAccount,
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
                          icon: Icons.palette_outlined,
                          title: S.of(context).theme,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ThemeScreen(),
                              ),
                            );
                          },
                        ),
                        buildMenuItem(
                          icon: Icons.language,
                          title: S.of(context).language,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LanguageScreen(),
                              ),
                            );
                          },
                        ),
                        buildMenuItem(
                          icon: Icons.logout,
                          title: S.of(context).logout,
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
  },
);
  }
}