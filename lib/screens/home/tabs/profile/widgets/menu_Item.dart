import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

  // ================= Menu Item =================
Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.grey,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: AppStyles.black16Bold,
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
