import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoginWidget extends StatelessWidget {
  String imagePath;
  LoginWidget({super.key , required this.imagePath});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: screenHeight*0.08,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.grey,
            )
        ),
        child: Image.asset(imagePath),
      ),
    );
  }
}
