import 'package:eat2beat/models/offers_model.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final FoodModel item;
  final double screenHeight;
  final double screenWidth;

  const FoodCard({
    super.key,
    required this.item,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.image,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(item.rate.toString()),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('\$ ${item.price}'),
              const Icon(Icons.circle, size: 4),
              const Icon(Icons.watch_later_outlined, size: 18),
              Text(item.time),
            ],
          )
        ],
      ),
    );
  }
}
