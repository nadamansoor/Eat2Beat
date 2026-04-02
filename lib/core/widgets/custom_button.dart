
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  String text;
  Color backgroundColor;
  Color borderColor;
  bool iconExist;
  Widget? iconWidget;
  TextStyle textStyle;
  MainAxisAlignment mainAxisAlignment;
  VoidCallback onPressed;
  double? width;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.purple,
    this.borderColor = AppColors.purple,
    this.textStyle = AppStyles.white20Regular,
    this.iconExist = false,
    this.iconWidget,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          fixedSize: Size(width ?? screenWidth, screenHeight*0.08,),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: borderColor
              )
          ),
        ),
        child: iconExist ?
        Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            iconWidget!,
            SizedBox(width: screenWidth*0.02,),
            Text(
              text , style: textStyle,
            )
          ],
        )
            :Text(
          text , style: textStyle,
        )
    );
  }
}
