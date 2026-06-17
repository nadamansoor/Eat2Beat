import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Image.asset(Assets.imagesPattern),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight*0.02
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Assets.imagesSuccessmark),
                  SizedBox(height: screenHeight*0.04,),
                  Text(S.of(context).passwordChangedTitle, style: AppStyles.black24Bold,),
                  SizedBox(height: screenHeight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).passwordChangedDesc, style: AppStyles.grey16w400,),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.05,),
                  CustomButton(text: S.of(context).backToLogin,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
