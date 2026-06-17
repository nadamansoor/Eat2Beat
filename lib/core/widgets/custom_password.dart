import 'package:eat2beat/core/widgets/custom_text.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key, this.onSaved,
  });
  final void Function(String?)? onSaved;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomFormTextField(
      obscureText: obscureText,
          onSaved: widget.onSaved,
          SuffixIcon: GestureDetector(
            onTap: (){
              obscureText = !obscureText;
              setState(() {
              });},
            child:obscureText? Icon(Icons.visibility_off_outlined,
            color: Color(0xFF8C8C8C),):Icon(Icons.visibility_outlined),
          ),

          hintText: S.of(context).password,            
          textInputType: TextInputType.visiblePassword,
        );
  }
}