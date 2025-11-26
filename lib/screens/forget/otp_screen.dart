import 'package:eat2beat/widgets/otp_text_field.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/leading_widget.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeadingWidget(),
                  SizedBox(height: screenHeight*0.04,),
                  Text("OTP Verification",style: AppStyles.black24Bold,),
                  SizedBox(height: screenHeight*0.01,),
                  Text("Enter the verification code we just sent on your email address.",
                    style: AppStyles.grey16w400,),
                  SizedBox(height: screenHeight*0.05,),
                  Row(
                    children: [
                      Expanded(child: OtpTextField(controller: otpController1)),
                      SizedBox(width: screenWidth*0.05,),
                      Expanded(child: OtpTextField(controller: otpController2)),
                      SizedBox(width: screenWidth*0.05,),
                      Expanded(child: OtpTextField(controller: otpController3)),
                      SizedBox(width: screenWidth*0.05,),
                      Expanded(child: OtpTextField(controller: otpController4)),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.05,),
                  CustomButton(text: "Verify", onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.newPassRouteName);
                  }),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive code ?", style: AppStyles.black16w500),
                      SizedBox(width: screenWidth * 0.01),

                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Resend",
                          style: AppStyles.blue16w500.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
