import 'package:flutter/material.dart';
import '../../admin_home/const.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileLogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: kRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kRed.withOpacity(0.3)),
        ),
        child: const Text(
          'Logout',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kRed,
          ),
        ),
      ),
    );
  }
}