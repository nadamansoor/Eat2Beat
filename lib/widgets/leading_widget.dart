import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      child: Container(
        height: screenHeight*0.04,
        padding: EdgeInsets.only(
            left: screenWidth*0.027,
            right: screenWidth*0.01
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: AppColors.grey
            )
        ),
        child: Icon(Icons.arrow_back_ios ,size: 15,),
      ),
      onTap: (){
        Navigator.pop(context);
      },
    );
  }
}
