import 'dart:async';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpWidget({
    super.key,
    required this.controller,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;      // 375
    double screenHeight = MediaQuery.of(context).size.height;   // 812
    return PinCodeTextField(
      appContext: context,
      length: 4,
      controller: controller,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      cursorColor: AppColors.grey,
      enableActiveFill: true,

      onChanged: onChanged ?? (value) {
        print("Current value: $value");
      },

      onCompleted: onCompleted,

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: screenHeight*0.08,
        fieldWidth: screenWidth*0.19,
        activeFillColor: Colors.white,
        inactiveColor: AppColors.grey,
        inactiveBorderWidth: 1,
        selectedBorderWidth: 1,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.grey,
        selectedFillColor: Colors.white,
        activeColor: AppColors.blue,
      ),
    );
  }
}
