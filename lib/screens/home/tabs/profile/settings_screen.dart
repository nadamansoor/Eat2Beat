import 'package:eat2beat/screens/home/tabs/profile/widgets/lan_item.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/simple_item.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/switch_item.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool locationEnabled = true;
  bool notificationEnabled = true;
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            /// Background
            Positioned.fill(
              child: Image.asset(
                AppImages.PatternCart,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: height * 0.03),

                  /// App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      circleIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                        "Save",
                        style: AppStyles.grey13w400,
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.04),

                  /// Change Password
                  buildSimpleItem(
                    title: "Change Password",
                    onTap: () {
                      // TODO: navigate to change password screen
                    },
                  ),

                  SizedBox(height: 20),

                  /// Switches
                  buildSwitchItem(
                    title: "Current Location",
                    value: locationEnabled,
                    onChanged: (val) {
                      setState(() => locationEnabled = val);
                    },
                  ),

                  SizedBox(height: 16),

                  buildSwitchItem(
                    title: "Notification",
                    value: notificationEnabled,
                    onChanged: (val) {
                      setState(() => notificationEnabled = val);
                    },
                  ),

                  SizedBox(height: 28),

                  /// Language
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Language",
                      style: AppStyles.black13Bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  buildLanguageItem(
                        language: "Arabic",
                        selectedLanguage: selectedLanguage,
                        onTap: () {
                          setState(() => selectedLanguage = "Arabic");
                        },
                      ),
                  SizedBox(height: 12),
                  buildLanguageItem(
                        language: "English",
                        selectedLanguage: selectedLanguage,
                        onTap: () {
                          setState(() => selectedLanguage = "English");
                        },
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
