import 'package:eat2beat/domain/food_item.dart' show FoodItem;
import 'package:flutter/material.dart';

class FoodGridCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;

  const FoodGridCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                item.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("${item.price}"),
          ],
        ),
      ),
    );
  }
}
