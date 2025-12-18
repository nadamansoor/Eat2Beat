import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RestContainer extends StatelessWidget {
  double width;
  String restName;
  String logoPath;

  RestContainer({
    super.key ,
    required this.width,
    required this.restName,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // 812
    return Column(
      children: [
        Container(
          height: screenHeight * 0.06,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(logoPath),
        ),
        SizedBox(height: screenHeight*0.003,),
        Text(restName, style: AppStyles.black13w400,)
      ],
    );
  }
}