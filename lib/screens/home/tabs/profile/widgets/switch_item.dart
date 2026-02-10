import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

  // ================= Switch Item =================
Widget buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.black16Bold,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.purple,
            inactiveTrackColor: AppColors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
