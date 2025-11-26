import 'package:eat2beat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/login_widget.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        children: [
          Image.asset(AppImages.pattern),
          SizedBox(height: screenHeight*0.0,),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight*0.02
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight*0.1,),
                Center(
                  child: Text("Hello! Register to get\n            started",
                    style: AppStyles.black24Bold,
                  ),
                ),
                SizedBox(height: screenHeight*0.03,),
                CustomTextFormField(
                    hintText: "Username",
                    controller: nameController
                ),
                SizedBox(height: screenHeight*0.02,),
                CustomTextFormField(
                  hintText: "Email",
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                ),
                SizedBox(height: screenHeight*0.02,),
                CustomTextFormField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                    suffixIcon: Icon(Icons.remove_red_eye),
                ),
                SizedBox(height: screenHeight*0.02,),
                CustomTextFormField(
                  hintText: "Confirm Password",
                  controller: confirmController,
                  obscureText: true,
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
                SizedBox(height: screenHeight*0.03,),
                CustomButton(text: "Register", onPressed: (){}),
                SizedBox(height: screenHeight*0.04,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.25,
                      height: 1,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text("OR Register With", style: AppStyles.grey16w400),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      width: screenWidth * 0.25,
                      height: 1,
                      color: AppColors.grey,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.04,),
                Row(
                  children: [
                    Expanded(
                        child: LoginWidget(imagePath: AppImages.facebookLogo)
                    ),
                    SizedBox(width: screenWidth*0.02,),
                    Expanded(
                        child: LoginWidget(imagePath: AppImages.googleLogo)
                    ),
                    SizedBox(width: screenWidth*0.02,),
                    Expanded(
                        child: LoginWidget(imagePath: AppImages.appleLogo)
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?", style: AppStyles.black16w500),
                    SizedBox(width: screenWidth * 0.01),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.loginRouteName);
                      },
                      child: Text(
                        "Login Now",
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
    );
  }
}
