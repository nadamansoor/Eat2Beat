  import 'package:flutter/material.dart';

void BuildErrorBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(               
      SnackBar(                
        content: Text(message)));
  }