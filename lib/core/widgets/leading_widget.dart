import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class LeadingWidget extends StatelessWidget {
  final Widget? icon;
  final void Function()? action;
  const LeadingWidget({
    super.key,
    this.icon,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double size = screenHeight * 0.045;
    if (size < 36) size = 36;

    return InkWell(
      onTap: action ?? () => Navigator.pop(context),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: AppColors.grey
            )
        ),
        child: Center(
          child: icon ?? const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
        ),
      ),
    );
  }
}