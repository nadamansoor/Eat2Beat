import 'dart:async';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpWidget extends StatelessWidget {
  String correctCode;

  OtpWidget({
    super.key,
    required this.correctCode,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;      // 375
    double screenHeight = MediaQuery.of(context).size.height;   // 812
    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      cursorColor: AppColors.grey,
      enableActiveFill: true,

      onChanged: (value) {
        print("Current value: $value");
      },

      onCompleted: (value) {
        //print("OTP Done: $value");
        if(value == correctCode){
          showDialog(context: context,
              builder: (context) {
               return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.purple,
                  ),
                );
              },
          );
          Timer(
              Duration(milliseconds: 500),
                  () => Navigator.pushReplacementNamed(context, AppRoutes.changePassRouteName));
        }
        else{
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("OTP Code",style: AppStyles.black24Bold,),
                content: Text("The code you have entered isn't correct",style: AppStyles.grey16w400,),
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text("Try again" , style: AppStyles.black16w500,),
                  )
                ],
              );
          },);
        }
      },

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: screenHeight*0.08,
        fieldWidth: screenWidth*0.19,
        activeFillColor: Colors.white,
        inactiveColor: AppColors.grey,
        inactiveBorderWidth: 1,
        selectedBorderWidth: 1,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.grey,
        selectedFillColor: Colors.white,
        activeColor: AppColors.blue,
      ),
    );
  }
}
