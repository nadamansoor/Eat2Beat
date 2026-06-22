import 'package:eat2beat/features/charity/charity_dashboard/controllers/dash_controller.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/dashboard_view.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CharityHomePage extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const CharityHomePage({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardController(context.read<CharityCubit>()),
      child: DashboardView(onProfileTap: onProfileTap),
    );
  }
}