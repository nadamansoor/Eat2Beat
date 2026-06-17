import 'package:eat2beat/generated/l10n.dart';
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
    final s = S.of(context);
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
              text: s.termsAgreementPrefix,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: s.termsAgreementConditions,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: s.termsAgreementAnd,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: s.termsAgreementPolicy,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
       // textDirection: TextDirection.rtl, // Important for RTL layout
      ),
    ),
      ],
    );
  }
}