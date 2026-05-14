// ─── Section Label ──────────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: kText,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
