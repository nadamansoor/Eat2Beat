import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

Widget buildLanguageItem({
  required String language,
  required String selectedLanguage,
  required VoidCallback onTap,
}) {
  final bool isSelected = selectedLanguage == language;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
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
