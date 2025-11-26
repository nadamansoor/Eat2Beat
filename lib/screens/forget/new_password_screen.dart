import 'package:eat2beat/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/leading_widget.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LeadingWidget(),
                      SizedBox(height: screenHeight*0.04,),
                      Text("Create New Password",style: AppStyles.black24Bold,),
                      SizedBox(height: screenHeight*0.01,),
                      Text("Your new password must be unique from those previously used.",
                        style: AppStyles.grey16w400,),
                      SizedBox(height: screenHeight*0.05,),
                      CustomTextFormField(
                          hintText: "New Password",
                          controller: passwordController,
                          validator: (value){
                            if(value == null || value.trim().isEmpty){
                              return "Password Required";
                            }
                            else if(value.length < 6){
                              return "Password must be at least 6 numbers";
                            }
                            else{
                              return null;
                            }
                          },
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      CustomTextFormField(
                          hintText: "Confirm Password",
                          controller: confirmController,
                          validator: (value){
                            if(value == null || value.trim().isEmpty){
                              return "Password Required";
                            }
                            else if(value.length < 6){
                              return "Password must be at least 6 numbers";
                            }
                            else if(value != passwordController.text){
                              return "Confirmed Password doesn't match the previous";
                            }
                            else{
                              return null;
                            }
                          },
                      ),
                      SizedBox(height: screenHeight*0.05,),
                      CustomButton(text: "Reset Password", onPressed: (){
                        if(formKey.currentState!.validate()){
                          Navigator.pushNamed(context, AppRoutes.changePassRouteName);
                        }
                      }
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}
