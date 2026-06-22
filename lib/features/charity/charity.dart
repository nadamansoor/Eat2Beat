import 'package:eat2beat/features/charity/charity_analytics/analy_charity.dart';
import 'package:eat2beat/features/charity/charity_dashboard/dash_charity.dart';
import 'package:eat2beat/features/charity/charity_donations/donations_charity.dart';
import 'package:eat2beat/features/charity/charity_resturants/resturants_charity.dart';
import 'package:eat2beat/features/charity/widgets/custom_naiv_bar.dart';
import 'package:flutter/material.dart';

class CharityDashboardScreen extends StatefulWidget {
  const CharityDashboardScreen({super.key});

  @override
  State<CharityDashboardScreen> createState() => _CharityDashboardScreenState();
}

class _CharityDashboardScreenState extends State<CharityDashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const CharityHomePage(),
    const ResturantsCharity(),
    const DonationsCharity(),
    const AnalyCharity(),
  ];

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}