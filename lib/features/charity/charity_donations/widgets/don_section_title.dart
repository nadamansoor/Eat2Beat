import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 15));
}