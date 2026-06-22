import 'package:eat2beat/features/charity/charity_resturants/controllers/res_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_view.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResturantsCharity extends StatelessWidget {
  const ResturantsCharity({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantsController(context.read<CharityCubit>()),
      child: const RestaurantsView(),
    );
  }
}