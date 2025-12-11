import 'package:flutter/material.dart';

class CategoryFilters extends StatelessWidget {
  final int selected;
  final Function(int) onSelect;
  final List<String> items = const [
    "New",
    "Popular",
    "Near2you",
    "Snack",
  ];

  const CategoryFilters({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final active = selected == index;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: active ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  items[index],
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
