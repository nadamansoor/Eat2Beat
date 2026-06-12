import 'dart:io';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:flutter/material.dart';

  // ================= Profile Header =================
Widget buildProfileHeader(double screenWidth) {
  return ListenableBuilder(
    listenable: UserProfileNotifier(),
    builder: (context, child) {
      final profile = UserProfileNotifier();
      return Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.14,
                backgroundColor: AppColors.purple50,
                backgroundImage: profile.profileImagePath.isNotEmpty
                    ? FileImage(File(profile.profileImagePath)) as ImageProvider
                    : null,
                child: profile.profileImagePath.isEmpty
                    ? Icon(
                        Icons.person,
                        size: screenWidth * 0.14,
                        color: AppColors.purple,
                      )
                    : null,
              ),

              Positioned(
                bottom: 4,
                right: 4,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.purple,
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            profile.name,
            style: AppStyles.black24Bold,
          ),

          const SizedBox(height: 4),

          Text(
            profile.email,
            style: AppStyles.grey13w400,
          ),
        ],
      );
    },
  );
}