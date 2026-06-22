import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_card.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_data_model.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_menu_card.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody();

  static const _menuItems = <MenuItem>[
    MenuItem(
      label: 'Organization Info',
      icon: Icons.business_outlined,
      item: MenuAction.organizationInfo,
    ),
    MenuItem(
      label: 'Team Members',
      icon: Icons.group_outlined,
      item: MenuAction.teamMembers,
    ),
    MenuItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      item: MenuAction.settings,
    ),
    MenuItem(
      label: 'Help & Support',
      icon: Icons.help_outline_rounded,
      item: MenuAction.helpSupport,
    ),
    MenuItem(
      label: 'Logout',
      icon: Icons.logout_rounded,
      item: MenuAction.logout,
      isDestructive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const ProfileCard(),
          const SizedBox(height: 20),
          MenuCard(items: _menuItems),
        ],
      ),
    );
  }
}