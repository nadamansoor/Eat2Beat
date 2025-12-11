import 'package:flutter/material.dart';
import '../../data/food_service.dart';
import '../../domain/food_item.dart';

class DetailsPage extends StatelessWidget {
  final String id;
  DetailsPage({super.key, required this.id});

  final service = FoodService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: FutureBuilder<FoodItem>(
        future: service.getFoodDetails(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(item.image),
                const SizedBox(height: 16),
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text("⭐ ${item.rating}   🕒 ${item.time} min"),
                const SizedBox(height: 16),
                Text(item.description),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Order Now"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
