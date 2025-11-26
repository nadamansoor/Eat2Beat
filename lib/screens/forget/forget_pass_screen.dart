import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/custom_button.dart';
import 'package:eat2beat/widgets/custom_text_field.dart';
import 'package:eat2beat/widgets/leading_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';

class ForgetPassScreen extends StatelessWidget {
  ForgetPassScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: "ahmed@gmail.com");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.light,
        body: Form(
          key: formKey,
          child: Stack(
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
                    Text("Forgot Password?",style: AppStyles.black24Bold,),
                    SizedBox(height: screenHeight*0.01,),
                    Text("Don't worry! It occurs. Please enter the email address linked with your account.",
                      style: AppStyles.grey16w400,),
                    SizedBox(height: screenHeight*0.05,),
                    CustomTextFormField(hintText: "Enter Your Email",
                        controller: emailController,
                        validator: (value){
                          if(value == null || value.trim().isEmpty){
                            return "Email Required";
                          }
                          String pattern = r'^[^@]+@[^@]+\.[^@]+';
                          if (!RegExp(pattern).hasMatch(value)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                    ),
                    SizedBox(height: screenHeight*0.05,),
                    CustomButton(text: "Send Code",
                        onPressed: (){
                           if(formKey.currentState!.validate()){
                             Navigator.pushNamed(context, AppRoutes.otpRouteName);
                           }
                        }
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Remember Password ?", style: AppStyles.black16w500),
                        SizedBox(width: screenWidth * 0.01),

                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.loginRouteName);
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }
}
