import 'package:eat2beat/features/charity/widgets/charity_bottom_navi.dart';
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
    const activeColor = Color(0xFF7B5EA7); // Charity primary brand color
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
              ? activeColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      size: 24,
                      color: isSelected ? activeColor : Colors.grey,
                    )
                  : Image.asset(
                      isSelected ? item.activeImage! : item.inActiveImage!,
                      width: 24,
                      height: 24,
                      color: isSelected ? activeColor : Colors.grey,
                    ),
            ),
            const SizedBox(height: 4),
            // انيميشن على النص
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                color: isSelected
                    ? activeColor 
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