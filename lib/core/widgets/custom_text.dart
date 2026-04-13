import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({super.key, required this.hintText, required this.textInputType, this.SuffixIcon, this.onSaved,  this.obscureText= false});

  final String hintText;
  final TextInputType textInputType;
  final Widget ? SuffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      obscureText: obscureText,
      onSaved: onSaved,
      validator:(value){
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      } ,
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: SuffixIcon,
        hintStyle: AppStyles.black16Bold.copyWith(
          color: Color.fromARGB(255, 202, 201, 201),
        ) ,           
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFF9FAFA),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }
}

OutlineInputBorder buildBorder(){
  return OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Color(0xFFE6E9E9),
              width: 1
            )
          );  
}