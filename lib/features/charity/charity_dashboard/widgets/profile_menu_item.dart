import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_data_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem item;
  const MenuItemTile({required this.item});

  void _handleTap(BuildContext context) {
    switch (item.item) {
      case MenuAction.organizationInfo:
        // TODO: Navigator.pushNamed(context, AppRoutes.orgInfoRouteName);
        break;
      case MenuAction.teamMembers:
        // TODO: Navigator.pushNamed(context, AppRoutes.teamMembersRouteName);
        break;
      case MenuAction.settings:
        // TODO: Navigator.pushNamed(context, AppRoutes.settingsRouteName);
        break;
      case MenuAction.helpSupport:
        // TODO: Navigator.pushNamed(context, AppRoutes.helpRouteName);
        break;
      case MenuAction.logout:
        _showLogoutDialog(context);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final navigator = Navigator.of(context);
              try {
                await getIt<AuthRepo>().signOut();
              } catch (e) {
                // Ignore sign out errors
              }
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.loginRouteName,
                (route) => false,
              );
              await UserProfileNotifier().clearActiveSession();
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color =
        item.isDestructive ? const Color(0xFFE53935) : AppColors.textPrimary;

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: item.isDestructive
                  ? const Color(0xFFE53935)
                  : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}