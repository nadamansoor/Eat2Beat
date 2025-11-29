import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_validators.dart';
import 'package:flutter/material.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/leading_widget.dart';
import '../../widgets/login_widget.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmController = TextEditingController();

  int counter1 = 0 ;
  int counter2 = 0 ;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LeadingWidget(),
                      SizedBox(height: screenHeight*0.04,),
                      Center(
                        child: Text("Hello! Register to get\n            started",
                          style: AppStyles.black24Bold,
                        ),
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      CustomTextFormField(
                          hintText: "Username",
                          controller: nameController,
                          validator: (value){
                            return AppValidators.nameValidator(value);
                          },
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      CustomTextFormField(
                        hintText: "Email",
                        controller: emailController,
                        keyBoardType: TextInputType.emailAddress,
                        validator: (value){
                          return AppValidators.emailValidator(value);
                        },
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      CustomTextFormField(
                          hintText: "Password",
                          obscureText: CustomTextFormField.appearPassword(counter1),
                          controller: passwordController,
                          suffixIcon: InkWell(
                              onTap: (){
                                counter1++;
                                setState(() {

                                });
                              },
                              child:
                              CustomTextFormField.appearPassword(counter1) == true ?
                              Icon(Icons.visibility_off_outlined)
                              : Icon(Icons.visibility_outlined)
                          ),
                          validator: (value) {
                            return AppValidators.passwordValidator(value);
                          },
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      CustomTextFormField(
                        hintText: "Confirm Password",
                        controller: confirmController,
                        obscureText: CustomTextFormField.appearPassword(counter2),
                        suffixIcon: InkWell(
                            onTap: (){
                              counter2++;
                              setState(() {

                              });
                            },
                            child:
                            CustomTextFormField.appearPassword(counter2) == true ?
                            Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined)
                        ),
                        validator: (value) {
                          return AppValidators.confirmValidator(value, passwordController: passwordController);
                        },
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      CustomButton(text: "Register",
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              print("registered successfully");
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
                      SizedBox(height: screenHeight*0.08,),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
