import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const BottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(Icons.home_filled, 0),
          _item(Icons.search, 1),
          _item(Icons.shopping_bag, 2),
          _item(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _item(IconData icon, int i) {
    return GestureDetector(
      onTap: () => onTap(i),
      child: Icon(
        icon,
        color: index == i ? Colors.white : Colors.white54,
        size: 28,
      ),
    );
  }
}
