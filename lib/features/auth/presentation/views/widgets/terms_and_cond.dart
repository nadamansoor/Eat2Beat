import 'package:flutter/material.dart';

class TermsandConditions extends StatefulWidget {
  const TermsandConditions({super.key, required this.onChanged});
    final ValueChanged <bool> onChanged;

  @override
  State<TermsandConditions> createState() => TermsandConditionsState();
}

class TermsandConditionsState extends State<TermsandConditions> {
  
  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
            Checkbox(             
              onChanged: (value) {
                isTermsAccepted = value!;               
                widget.onChanged(value);
                setState(() {
                  
                });
              },
              value: isTermsAccepted,
            ),
        Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'من خلال إنشاء حساب، فإنك توافق على ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: 'الشروط',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: ' و',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: 'الأحكام الخاصة بنا',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textDirection: TextDirection.rtl, // مهم عشان العربي
      ),
    ),
      ],
    );
  }
}