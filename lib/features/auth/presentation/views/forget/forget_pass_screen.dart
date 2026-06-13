import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/custom_text_field.dart';
import 'package:eat2beat/core/widgets/leading_widget.dart';
import 'package:flutter/material.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
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
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LeadingWidget(),
                    SizedBox(height: screenHeight * 0.04),
                    Text("Forgot Password?", style: AppStyles.black24Bold),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Don't worry! It occurs. Please enter the email address linked with your account.",
                      style: AppStyles.grey16w400,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextFormField(
                      hintText: "Enter Your Email",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email Required";
                        }
                        String pattern = r'^[^@]+@[^@]+\.[^@]+';
                        if (!RegExp(pattern).hasMatch(value)) {
                          return "Invalid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomButton(
                      text: "Send Code",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final email = emailController.text.trim();

                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.purple,
                                  ),
                                ),
                          );

                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );

                          // Generate mock OTP
                          final otp =
                              (1000 + Random().nextInt(9000)).toString();

                          try {
                            // Try sending real Firebase reset email
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: email,
                            );
                          } catch (e) {
                            debugPrint("Firebase reset email failed: $e");
                          }

                          // Pop loading dialog and navigate
                          navigator.pop();

                          // Show snackbar with code
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Verification code sent: $otp (Email reset link also sent)",
                              ),
                              backgroundColor: AppColors.purple,
                              duration: const Duration(seconds: 6),
                            ),
                          );

                          // Navigate to OTP screen
                          navigator.pushNamed(
                            AppRoutes.otpRouteName,
                            arguments: {'email': email, 'otpCode': otp},
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember Password ?",
                          style: AppStyles.black16w500,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.loginRouteName);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
