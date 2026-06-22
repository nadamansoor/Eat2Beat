import 'package:eat2beat/features/charity/charity_dashboard/controllers/dash_controller.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_screen.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';

class Header extends StatelessWidget {
  final DashboardController ctrl;
  final VoidCallback? onProfileTap;
  const Header({required this.ctrl, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final cubit = context.read<CharityCubit>();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: const CharityProfileScreen(),
                ),
              ),
            );
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.volunteer_activism_rounded,
                color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Charity Dashboard',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 17)),
              const SizedBox(height: 2),
              Text(
                (ctrl.charityCubit.state is CharityLoaded)
                    ? (ctrl.charityCubit.state as CharityLoaded).profile.name
                    : 'Charity Partner',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        //notifi - NotificationsCharityPage
        GestureDetector(
          onTap: ctrl.onNotificationTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textPrimary, size: 22),
          ),
        ),
      ],
    );
  }
}