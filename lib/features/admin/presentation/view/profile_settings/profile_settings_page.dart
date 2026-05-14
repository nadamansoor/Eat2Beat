import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_avatar.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_logout_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_save_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_card.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_toggle.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_settings_text_field.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_tap_row.dart' show SettingsTapRow;
import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  // Controllers
  final _nameController =
      TextEditingController(text: 'Restaurant Name');
  final _emailController =
      TextEditingController(text: 'restaurant@eat2beat.com');
  final _phoneController =
      TextEditingController(text: '+20 100 000 0000');
  final _addressController =
      TextEditingController(text: 'Cairo, Egypt');
  final _passwordController = TextEditingController();

  // Toggles
  bool _isOpen = true;
  bool _notificationsEnabled = true;

  // Working hours
  String _openTime = '09:00 AM';
  String _closeTime = '11:00 PM';

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);
    // TODO: call your update API here
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Updated successfully'),
          backgroundColor: const Color(0xFF6C63FF),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1D23), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D23),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEF0F4)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Avatar ─────────────────────────────────────────────
            ProfileAvatarSection(
              restaurantName: _nameController.text,
              email: _emailController.text,
              onChangPhoto: () {
                // TODO: open image picker
              },
            ),

            const SizedBox(height: 8),

            // ── Basic Info ─────────────────────────────────────────
            SettingsSectionCard(
              title: 'Essential Info',
              children: [
                SettingsFieldRow(
                  icon: Icons.store_rounded,
                  label: 'Restaurant name',
                  hint: 'Restaurant Name',
                  controller: _nameController,
                ),
                SettingsFieldRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SettingsFieldRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  hint: '+20 100 000 0000',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                SettingsFieldRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  hint: 'Restaurant Address',
                  controller: _addressController,
                ),
              ],
            ),

            // ── Operating Settings ─────────────────────────────────
            SettingsSectionCard(
              title: 'Operating Settings',
              children: [
                SettingsToggleRow(
                  icon: Icons.storefront_rounded,
                  label: 'Restaurant Status',
                  subtitle: _isOpen ? 'Open Now' : 'Closed',
                  value: _isOpen,
                  iconColor: _isOpen
                      ? const Color(0xFF10B981)
                      : const Color(0xFF9499A5),
                  onChanged: (v) => setState(() => _isOpen = v),
                ),
                SettingsTapRow(
                  icon: Icons.schedule_rounded,
                  label: 'Opening Time',
                  value: _openTime,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (picked != null) {
                      setState(() => _openTime = picked.format(context));
                    }
                  },
                ),
                SettingsTapRow(
                  icon: Icons.schedule_rounded,
                  label: 'Closing Time',
                  value: _closeTime,
                  iconColor: const Color(0xFFEF4444),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 23, minute: 0),
                    );
                    if (picked != null) {
                      setState(() => _closeTime = picked.format(context));
                    }
                  },
                ),
              ],
            ),

            // ── Account Settings ───────────────────────────────────
            SettingsSectionCard(
              title: 'Account Settings',
              children: [
                SettingsFieldRow(
                  icon: Icons.lock_outline_rounded,
                  label: 'New Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  iconColor: const Color(0xFFF59E0B),
                ),
                SettingsToggleRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  subtitle: 'On',
                  value: _notificationsEnabled,
                  iconColor: const Color(0xFF6C63FF),
                  onChanged: (v) =>
                      setState(() => _notificationsEnabled = v),
                ),
                SettingsTapRow(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  value: 'English',
                  iconColor: const Color(0xFF3B82F6),
                  onTap: () {
                    // TODO: language picker
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Save Button ────────────────────────────────────────
            ProfileSaveButton(
              isLoading: _isSaving,
              onTap: _onSave,
            ),

            // ── Logout ─────────────────────────────────────────────
            ProfileLogoutButton(
              onTap: () {
                // TODO: logout logic
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}