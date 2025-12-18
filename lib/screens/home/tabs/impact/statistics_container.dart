import 'package:flutter/material.dart';
import '../../../../utils/app_styles.dart';

class StatisticsContainer extends StatelessWidget {
  Color textColor;
  Color containerColor;
  int number;
  String text;
  double? width;
  StatisticsContainer({
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
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      height: screenHeight * 0.14,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("$number", style: AppStyles.bold40Green800.copyWith(
              color: textColor
          )),
          Text(text, style: AppStyles.sBold14Green800.copyWith(
              color: textColor
          )),
        ],
      ),
    );
  }
}