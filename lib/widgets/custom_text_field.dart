import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../utils/app_styles.dart';

typedef OnValidator = String? Function(String?)?;
class CustomTextFormField extends StatelessWidget {
  Color borderSideColor ;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String hintText;
  TextStyle hintStyle;
  TextEditingController controller;
  OnValidator validator;
  bool obscureText;
  TextInputType keyBoardType;
  int? maxLines;

  CustomTextFormField({
    super.key,
    this.borderSideColor = AppColors.grey,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    this.hintStyle = AppStyles.grey16w400,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyBoardType = TextInputType.text,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: builtOutlineBorder(borderSideColor),
        focusedBorder: builtOutlineBorder(borderSideColor),
        errorBorder: builtOutlineBorder(Colors.red),
        focusedErrorBorder: builtOutlineBorder(Colors.red),
        prefixIcon: prefixIcon,
        prefixIconColor: borderSideColor,
        suffixIcon: suffixIcon,
        suffixIconColor: borderSideColor,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      style: hintStyle,
      cursorColor: borderSideColor,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyBoardType,
      maxLines: maxLines?? 1,
    );
  }

  OutlineInputBorder builtOutlineBorder(borderSideColor){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderSideColor,
        )
    );
  }
}
