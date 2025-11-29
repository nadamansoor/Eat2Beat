import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/leading_widget.dart';
import '../../widgets/otp_widget.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
                  OtpWidget(correctCode: "1111",),
                  SizedBox(height: screenHeight*0.05,),
                  CustomButton(text: "Verify", onPressed: (){

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
