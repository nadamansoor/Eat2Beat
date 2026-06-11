import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),

      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          hintStyle: AppStyles.black16Bold.copyWith(
            color: Color.fromARGB(255, 202, 201, 201),
          ) ,           
          hintText: 'Search',
          filled: true,
          fillColor: Color(0xFFF9FAFA),
          border: buildBorder(),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(),
        ),
      ),
    );
  }
}

OutlineInputBorder buildBorder(){
  return OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Color(0xFFE6E9E9),
              width: 1,

            )
          );  
}