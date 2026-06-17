import 'package:eat2beat/core/services/language_notifier.dart';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: LanguageNotifier(),
      builder: (context, child) {
        final languageNotifier = LanguageNotifier();
        final currentLanguageCode = languageNotifier.locale.languageCode;

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
                            S.of(context).languageSelection,
                            style: AppStyles.black20Bold,
                          ),
                          const SizedBox(width: 48), // Balanced space for app bar symmetry
                        ],
                      ),

                      SizedBox(height: height * 0.05),

                      /// English
                      _buildLanguageItem(
                        title: "English",
                        isSelected: currentLanguageCode == 'en',
                        onTap: () {
                          languageNotifier.setLocale('en');
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Arabic
                      _buildLanguageItem(
                        title: "العربية (Arabic)",
                        isSelected: currentLanguageCode == 'ar',
                        onTap: () {
                          languageNotifier.setLocale('ar');
                        },
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

  Widget _buildLanguageItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDarkThemeActive = ThemeNotifier().isDarkMode;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: isDarkThemeActive ? AppColors.purple800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.black16Bold,
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.purple
                      : AppColors.purple.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purple,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
