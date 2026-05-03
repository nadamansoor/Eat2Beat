import 'package:eat2beat/features/admin/presentation/view/admin_home/meals_page.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/admin_upload.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/cubits/analysis_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/view/analy_page.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/admin_orders.dart';
import 'package:eat2beat/features/admin/presentation/view/widgets/custom_navi_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRouteName extends StatefulWidget {
  const AdminRouteName({super.key});

  @override
  State<AdminRouteName> createState() => _AdminRouteNameState();
}

class _AdminRouteNameState extends State<AdminRouteName> {
  int _selectedIndex = 0;

  // كل صفحة ملفوفة بالـ BlocProvider بتاعها هنا
  late final List<Widget> _pages = [
    const MealsPage(),
    const AdminUploadPage(),
    const OrdersPage(),
    // ✅ AnalyticsPage ملفوفة بـ BlocProvider هنا
    BlocProvider(
      create: (_) => AnalyticsCubit(),
      child: const AnalyticsPage(),
    ),
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