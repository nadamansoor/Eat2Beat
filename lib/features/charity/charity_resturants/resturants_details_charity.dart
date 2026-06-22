import 'package:eat2beat/features/charity/charity_resturants/controllers/res_details_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/don_details_view.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantModel restaurant;
  final CharityCubit charityCubit;
  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
    required this.charityCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: charityCubit,
      child: ChangeNotifierProvider(
        create: (_) => RestaurantDetailController(charityCubit)..load(restaurant.id),
        child: const DetailView(),
      ),
    );
  }
}