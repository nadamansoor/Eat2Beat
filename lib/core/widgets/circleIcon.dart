import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget circleIcon({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.white,
          shape: BoxShape.rectangle,

        ),
        child: Icon(icon, color: AppColors.black),
      ),
    );
  }