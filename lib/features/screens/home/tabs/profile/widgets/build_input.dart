import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

  // ================= Input Field =================
Widget buildInput({
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.black13Bold,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppStyles.black16Bold,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyles.grey13w400,
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    BorderSide(color: AppColors.purple.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.purple),
              ),
            ),
          ),
        ],
      ),
    );
  }