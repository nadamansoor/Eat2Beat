import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class LeadingWidget extends StatelessWidget {
  Widget? icon;
  void Function()? action;
  LeadingWidget({
    super.key,
    this.icon,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: action ?? () => Navigator.pop(context)
      ,
      child: Container(
        alignment: Alignment.center,
        height: screenHeight*0.04,
        padding: EdgeInsets.only(
            left: screenWidth*0.025,
            right: screenWidth*0.016
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: AppColors.grey
            )
        ),
        child: icon ?? Icon(Icons.arrow_back_ios ,size: 15,),
      ),
    );
  }
}