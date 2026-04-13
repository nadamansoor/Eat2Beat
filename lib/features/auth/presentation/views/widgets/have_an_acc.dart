import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class HaveAcount extends StatelessWidget {
  const HaveAcount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(               
        TextSpan(                 
          children: [                  
             TextSpan(
              text: 'Already have an account?',
              style: AppStyles.black16Bold.copyWith(
                color: Color(0xFF949D9E),
              )
            ),
          
            TextSpan(           
              text: ' Login Now',
              style:  TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
    
          ],
        ),
      );
  }
}