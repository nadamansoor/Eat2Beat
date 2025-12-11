import 'package:eat2beat/views/home/widgets/bottom_nav.dart';
import 'package:eat2beat/views/home/widgets/category_filters.dart';
import 'package:eat2beat/views/home/widgets/food_grid_card.dart';
import 'package:eat2beat/views/home/widgets/search_field.dart';
import 'package:flutter/material.dart';
import '../../data/food_service.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = FoodService();
  int filter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: service.getFoods(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final foods = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  SearchField(controller: TextEditingController()),
                  const SizedBox(height: 12),
                  CategoryFilters(
                    selected: filter,
                    onSelect: (i) => setState(() => filter = i),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      itemCount: foods.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.8),
                      itemBuilder: (_, i) {
                        return FoodGridCard(
                          item: foods[i],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsPage(id: foods[i].id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(index: 0, onTap: (i) {}),
    );
  }
}
