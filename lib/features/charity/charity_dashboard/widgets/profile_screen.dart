import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';

class CharityProfileScreen extends StatelessWidget {
  

  const CharityProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context),
      body: const ProfileBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }
}