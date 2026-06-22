import 'package:eat2beat/features/charity/charity_resturants/controllers/res_details_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/don_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDetailController()..load(restaurant),
      child: const DetailView(),
    );
  }
}