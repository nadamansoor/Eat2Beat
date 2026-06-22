import 'package:eat2beat/features/charity/widgets/charity_bottom_navi.dart';
import 'package:eat2beat/features/charity/widgets/charity_navi_item.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: bottoomNavigationBarItems.asMap().entries.map((entry) {
                return NavigationBarItem(
                  isSelected: selectedIndex == entry.key,
                  item: entry.value,
                  onTap: () => onTap(entry.key),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}