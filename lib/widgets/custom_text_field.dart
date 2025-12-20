import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../utils/app_styles.dart';

typedef OnValidator = String? Function(String?)?;
class CustomTextFormField extends StatelessWidget {
  Color borderSideColor ;
  Color? focusedBorderColor ;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String hintText;
  TextStyle hintStyle;
  TextEditingController controller;
  OnValidator validator;
  bool obscureText;
  TextInputType keyBoardType;
  int? maxLines;
  double? radius;
  final Function(String)? onChanged;

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
    this.maxLines,
    this.focusedBorderColor,
    this.radius,
    this.onChanged,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: builtOutlineBorder(borderSideColor),
          focusedBorder: builtOutlineBorder(focusedBorderColor ?? AppColors.blue),
          errorBorder: builtOutlineBorder(Colors.red),
          focusedErrorBorder: builtOutlineBorder(Colors.red),
          prefixIcon: prefixIcon,
          prefixIconColor: borderSideColor,
          suffixIcon: suffixIcon,
          suffixIconColor: borderSideColor,
          hintText: hintText,
          hintStyle: hintStyle,
          fillColor: Colors.white,
          filled: true
      ),
      style: hintStyle,
      cursorColor: borderSideColor,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyBoardType,
      maxLines: maxLines?? 1,
    );
  }

  OutlineInputBorder builtOutlineBorder(borderSideColor){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? 8),
        borderSide: BorderSide(
          color: borderSideColor,
        )
    );
  }

  static bool appearPassword(int counter){
    if(counter%2 ==0){
      return true;
    }
    else{
      return false;
    }
  }

}