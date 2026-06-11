import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class SearchCharityBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchCharityBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          suffixIcon: Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
