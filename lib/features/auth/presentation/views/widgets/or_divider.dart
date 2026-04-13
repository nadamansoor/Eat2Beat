import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider()),
        SizedBox(width: 18,),
        Text('Or Login with',
        style: AppStyles.grey16Bold,),
        SizedBox(width: 18,),
        Expanded(
          child: Divider()),
      ],
    );
  }
}