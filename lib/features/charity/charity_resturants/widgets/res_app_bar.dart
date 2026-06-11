
  import 'package:eat2beat/features/charity/charity_resturants/controllers/res_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(
    BuildContext context,
    RestaurantsController ctrl,
  ) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text(
        'Restaurants',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      
      actions: [
        IconButton(
          icon: Icon(
            ctrl.isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: ctrl.toggleSearch,
        ),
      ],
    );
  }