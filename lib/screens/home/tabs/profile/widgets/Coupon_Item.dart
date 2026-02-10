import 'package:eat2beat/models/coupon_model.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CouponItem extends StatelessWidget {
  final CouponModel coupon;

  const CouponItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_num_outlined,
              color: AppColors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.code,
                  style: AppStyles.grey16Bold,
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.description,
                  style: AppStyles.black16Bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
