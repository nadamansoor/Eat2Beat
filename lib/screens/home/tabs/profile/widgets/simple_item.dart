import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

  // ================= Simple Item =================
Widget buildSimpleItem({
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: AppStyles.black16Bold,
        ),
      ),
    );
  }

