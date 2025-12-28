import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

  // ================= Profile Header =================
Widget buildProfileHeader(double screenWidth) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: screenWidth * 0.14,
              backgroundImage: AssetImage(AppImages.myPhotoNada),
            ),

            Positioned(
              bottom: 4,
              right: 4,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.purple,
                child: Icon(
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
          "Nada Mansour",
          style: AppStyles.black24Bold,
        ),

        const SizedBox(height: 4),

        Text(
          "nadamansour1566@gmail.com",
          style: AppStyles.grey13w400,
        ),
      ],
    );
  }