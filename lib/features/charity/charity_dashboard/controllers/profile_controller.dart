import 'package:eat2beat/features/charity/charity_dashboard/model/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  final ProfileModel profile = const ProfileModel(
    organizationName: 'Hope Foundation',
    organizationType: 'Charity Organization',
  );

  void onMenuTap(BuildContext context, ProfileMenuItem item) {
    switch (item) {
      case ProfileMenuItem.organizationInfo:
        // TODO: push organization info page
        debugPrint('Organization Info');
      case ProfileMenuItem.teamMembers:
        // TODO: push team members page
        debugPrint('Team Members');
      case ProfileMenuItem.settings:
        // TODO: push settings page
        debugPrint('Settings');
      case ProfileMenuItem.helpSupport:
        // TODO: push help page
        debugPrint('Help & Support');
      case ProfileMenuItem.logout:
        _showLogoutDialog(context);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: call auth logout and navigate to login
              debugPrint('Logged out');
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: Color(0xFFE53935), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}