import 'package:eat2beat/features/admin/presentation/view/widgets/bottom_navi_bar.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:flutter/material.dart';

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.isSelected,
    required this.item,
    required this.onTap,
  });

  final bool isSelected;
  final BottomNaviBar item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon animation
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      size: 24,
                      color: isSelected
                          ? kPrimary
                          : Colors.grey,
                    )
                  : Image.asset(
                      isSelected ? item.activeImage! : item.inActiveImage!,
                      width: 24,
                      height: 24,
                    ),
            ),
            const SizedBox(height: 4),
            // Text animation
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                color: isSelected
                    ? kPrimary 
                    : Colors.grey,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(item.name),
            ),
          ],
        ),
      ),
    );
  }
}