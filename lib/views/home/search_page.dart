import 'package:eat2beat/views/home/widgets/bottom_nav.dart';
import 'package:eat2beat/views/home/widgets/food_list_card.dart';
import 'package:eat2beat/views/home/widgets/search_field.dart';
import 'package:flutter/material.dart';
import '../../data/food_service.dart';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final service = FoodService();
  final controller = TextEditingController();
  List results = [];

  void doSearch(String q) async {
    final r = await service.search(q);
    setState(() => results = r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchField(
                controller: controller,
                onChanged: doSearch,
              ),
              Expanded(
                child: results.isEmpty
                    ? const Center(child: Text("Search something..."))
                    : ListView(
                        children: results.map<Widget>((item) {
                          return FoodListCard(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsPage(id: item.id),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(index: 1, onTap: (i) {}),
    );
  }
}
