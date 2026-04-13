import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/features/auth/presentation/views/sign_up_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class dontHaveAcount extends StatelessWidget {
  const dontHaveAcount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(               
        TextSpan(                 
          children: [                  
             TextSpan(
              text: 'Don’t have an account?',
              style: AppStyles.black16Bold.copyWith(
                color: Color(0xFF949D9E),
              )
            ),
          
            TextSpan(           
              text: ' Register Now',
              style:  TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, SignUpView.routeName);
                },
            ),
    
          ],
        ),
      );
  }
}