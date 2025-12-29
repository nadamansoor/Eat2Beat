import 'package:eat2beat/models/coupon_model.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/Coupon_Item.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class PointsScreen extends StatelessWidget {
  PointsScreen({super.key});

  final List<CouponModel> coupons = [
    CouponModel(
      code: "PIZZA10",
      description: "Get 10% off on any pizza order.",
    ),
    CouponModel(
      code: "WELCOME50",
      description: "50% off your first order!",
    ),
    CouponModel(
      code: "WEEKEND5",
      description: "Save \$5 on orders over \$25 this weekend.",
    ),
    CouponModel(
      code: "EXTRA20",
      description: "20% off on orders above \$30.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
   
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            /// Background
            Positioned.fill(
              child: Image.asset(
                AppImages.PatternCart,
                fit: BoxFit.cover,
              ),
            ),



       SingleChildScrollView(
        child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.03),
            
            Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        circleIcon(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Text(
                          "Save",
                          style: AppStyles.grey13w400,
                        ),
                      ],
                    ),

            SizedBox(height: height * 0.04),


            Text(
              "Every order you place increases your points",
              style: AppStyles.black16Bold,
            ),

            const SizedBox(height: 20),

            /// Points Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.purple, width: 1.2),
              ),
              child: Column(
                children: [
                  Text("Your Points", style: AppStyles.black13Bold),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.moneyImg,
                        width: 50,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "85",
                        style: AppStyles.purple,
                        
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "How can use your points",
              style: AppStyles.black13Bold,
            ),
            const SizedBox(height: 6),
            Text(
              "Add from these coupons in your next order",
              style: AppStyles.grey13w400,
            ),

            const SizedBox(height: 20),

            /// Coupons List
            ...coupons.map((coupon) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CouponItem(coupon: coupon),
                )),
          ],
        ),
        ),
      ),
          ],
        
        ),
      ),
    );
  }
}
