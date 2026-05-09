import 'package:flutter/material.dart';
import '../../admin_home/const.dart';

class SettingsTapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const SettingsTapRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (iconColor ?? kPrimary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color: iconColor ?? kPrimary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor ?? kText,
                    ),
                  ),
                ),
                if (value != null)
                  Text(value!,
                      style: const TextStyle(
                          fontSize: 13, color: kMuted)),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded,
                    color: kMuted, size: 20),
              ],
            ),
          ),
        ),
        const Divider(color: kBorder, height: 1, indent: 16),
      ],
    );
  }
}