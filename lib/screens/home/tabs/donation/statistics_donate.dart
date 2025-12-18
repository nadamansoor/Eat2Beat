import 'package:flutter/material.dart';
import '../../../../utils/app_styles.dart';

class StatisticsDonate extends StatelessWidget {
  Color textColor;
  Color containerColor;
  int number;
  String text;
  double? width;
  StatisticsDonate({
    super.key,
    required this.containerColor,
    required this.textColor,
    required this.text,
    required this.number,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // 812
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      height: screenHeight * 0.17,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(text, style: AppStyles.sBold14Green800.copyWith(
                color: textColor,
                fontSize: 10
            )),
            SizedBox(height: screenHeight*0.03,),
            Text("$number", style: AppStyles.bold40Green800.copyWith(
                color: textColor
            )),
          ],
        ),
      ),
    );
  }
}