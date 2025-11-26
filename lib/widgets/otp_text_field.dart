import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OtpTextField extends StatelessWidget {
  TextEditingController controller;
  OtpTextField({super.key , required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: buildOutlineInputBorder(AppColors.grey),
        focusedBorder: buildOutlineInputBorder(AppColors.blue),
        errorBorder: buildOutlineInputBorder(Colors.red),
        focusedErrorBorder: buildOutlineInputBorder(Colors.red),
      ),
      style: AppStyles.black24Bold.copyWith(fontSize: 20),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }

  OutlineInputBorder buildOutlineInputBorder(borderSideColor){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderSideColor,
      )
    );
  }
}
