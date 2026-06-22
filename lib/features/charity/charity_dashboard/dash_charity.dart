import 'package:eat2beat/features/charity/charity_dashboard/controllers/dash_controller.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CharityHomePage extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const CharityHomePage({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController(),
      child: DashboardView(onProfileTap: onProfileTap),
    );
  }
}