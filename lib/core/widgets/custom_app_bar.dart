import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

AppBar BuildAppBar(context,{required String title}) {
    return AppBar(
      backgroundColor: Colors.white10,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new)),
      centerTitle: true,
      title: Text(title,
      style: AppStyles.black16Bold,
      ),
    );
  }
