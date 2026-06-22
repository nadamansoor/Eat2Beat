import 'package:eat2beat/features/charity/charity_donations/controllers/don_charity_contoller.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DonationsCharity extends StatelessWidget {
  const DonationsCharity({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonationsController(),
      child: const DonationsView(),
    );
  }
}