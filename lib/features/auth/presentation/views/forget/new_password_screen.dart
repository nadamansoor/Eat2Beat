import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/custom_text_field.dart';
import 'package:eat2beat/core/widgets/leading_widget.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController passwordController;
  late final TextEditingController confirmController;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

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
              Image.asset(Assets.imagesPattern),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LeadingWidget(),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Text(
                        S.of(context).createNewPasswordTitle,
                        style: AppStyles.black24Bold,
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        S.of(context).createNewPasswordDesc,
                        style: AppStyles.grey16w400,
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      CustomTextFormField(
                        hintText: S.of(context).newPassword,
                        controller: passwordController,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.of(context).passwordRequired;
                          } else if (value.length < 6) {
                            return S.of(context).passwordMinLength;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      CustomTextFormField(
                        hintText: S.of(context).confirmPassword,
                        controller: confirmController,
                        obscureText: obscureConfirm,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirm = !obscureConfirm;
                            });
                          },
                          icon: Icon(
                            obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.of(context).passwordRequired;
                          } else if (value.length < 6) {
                            return S.of(context).passwordMinLength;
                          } else if (value != passwordController.text) {
                            return S.of(context).passwordsDontMatch;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      CustomButton(
                        text: S.of(context).resetPasswordBtn,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pushNamed(
                                context, AppRoutes.changePassRouteName);
                          }
                        },
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
