import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/custom_button.dart';
import 'package:eat2beat/widgets/custom_text_field.dart';
import 'package:eat2beat/widgets/login_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
   final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   double screenWidth = MediaQuery.of(context).size.width;
   double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Image.asset(AppImages.pattern),
              SizedBox(height: screenHeight*0.0,),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight*0.02
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight*0.1,),
                      Center(
                        child: Text("Welcome back! Glad\n   to see you, Again!",
                          style: AppStyles.black24Bold,
                        ),
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      CustomTextFormField(
                          hintText: "Enter Your Email",
                          keyBoardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value){
                            if (value == null || value.trim().isEmpty) {
                              return "Email required";
                            }
                            String pattern = r'^[^@]+@[^@]+\.[^@]+';
                            if (!RegExp(pattern).hasMatch(value)) {
                              return "Invalid email";
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      CustomTextFormField(
                          hintText: "Enter Your Password",
                          controller: passwordController,
                          obscureText: true,
                          suffixIcon: Icon(Icons.remove_red_eye),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: screenHeight*0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.forgetRouteName);
                            },
                            child: Text(
                              "Forget Password ?",
                              style: AppStyles.grey16w400.copyWith(
                                decorationColor: AppColors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      CustomButton(
                          text: "Login",
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              print("login successfully");
                            }
                          }
                      ),
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
                           Text("OR Login With", style: AppStyles.grey16w400),
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
                      SizedBox(height: screenHeight*0.13,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account ?", style: AppStyles.black16w500),
                          SizedBox(width: screenWidth * 0.01),

                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoutes.registerRouteName);
                            },
                            child: Text(
                              "Register Now",
                              style: AppStyles.blue16w500.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
