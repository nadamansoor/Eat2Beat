import 'dart:async';
import 'dart:math';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/leading_widget.dart';
import 'package:eat2beat/core/widgets/otp_widget.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final TextEditingController pinController;
  String? currentOtpCode;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentOtpCode == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      currentOtpCode = args?['otpCode'] ?? '1111';
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  void _verifyOtp(String pin) {
    if (pin == currentOtpCode) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.purple),
        ),
      );

      final navigator = Navigator.of(context);
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = args?['email'] ?? '';

      Timer(
        const Duration(milliseconds: 500),
        () {
          navigator.pop(); // Pop loading dialog
          navigator.pushReplacementNamed(
            AppRoutes.newPassRouteName,
            arguments: {'email': email},
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("OTP Code", style: AppStyles.black24Bold),
            content: Text("The code you have entered isn't correct", style: AppStyles.grey16w400),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Try again",
                  style: AppStyles.black16w500.copyWith(color: AppColors.purple),
                ),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] ?? '';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Image.asset(Assets.imagesPattern),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LeadingWidget(),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Text(
                    "OTP Verification",
                    style: AppStyles.black24Bold,
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    "Enter the verification code we just sent to:\n$email",
                    style: AppStyles.grey16w400,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  OtpWidget(
                    controller: pinController,
                    onCompleted: (pin) {
                      _verifyOtp(pin);
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  CustomButton(
                    text: "Verify",
                    onPressed: () {
                      final pin = pinController.text;
                      if (pin.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter the complete 4-digit code"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      _verifyOtp(pin);
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive code ?",
                          style: AppStyles.black16w500),
                      SizedBox(width: screenWidth * 0.01),
                      InkWell(
                        onTap: () {
                          final newOtp = (1000 + Random().nextInt(9000)).toString();
                          setState(() {
                            currentOtpCode = newOtp;
                          });
                          pinController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("New verification code sent: $newOtp"),
                              backgroundColor: AppColors.purple,
                              duration: const Duration(seconds: 6),
                            ),
                          );
                        },
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
