import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
            Image.asset(AppImages.pattern),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight*0.02
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.successMark),
                  SizedBox(height: screenHeight*0.04,),
                  Text("Password Changed!", style: AppStyles.black24Bold,),
                  SizedBox(height: screenHeight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Your password has been\n   changed successfully.", style: AppStyles.grey16w400,),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.05,),
                  CustomButton(text: "Back to Login",
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
