import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_avatar.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_logout_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_save_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_card.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_toggle.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_settings_text_field.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_tap_row.dart' show SettingsTapRow;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/features/models/restaurant_model.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  // Toggles
  bool _isOpen = true;
  bool _notificationsEnabled = true;

  // Working hours
  String _openTime = '09:00 AM';
  String _closeTime = '11:00 PM';

  bool _hasInitialized = false;
  String? _restaurantImageUrl;

  void _autoUpdateStatus() {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    final openMin = RestaurantModel.parseTimeToMinutes(_openTime);
    final closeMin = RestaurantModel.parseTimeToMinutes(_closeTime);

    if (openMin != null && closeMin != null) {
      bool computedOpen = false;
      if (closeMin >= openMin) {
        computedOpen = nowMin >= openMin && nowMin <= closeMin;
      } else {
        computedOpen = nowMin >= openMin || nowMin <= closeMin;
      }
      setState(() {
        _isOpen = computedOpen;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);

    // Initialize fields with current ProfileCubit state if it's already loaded
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      final data = state.profileData;
      _restaurantImageUrl = data['restaurant_img_url']?.toString() ?? data['img_url']?.toString();
      _nameController.text = data['restaurant_name']?.toString() ?? '';
      _emailController.text = data['email']?.toString() ??
          (FirebaseAuth.instance.currentUser?.email ?? '');
      _phoneController.text = data['phone']?.toString() ?? '';
      _addressController.text = data['address']?.toString() ?? '';
      final isOpenVal = data['is_open'] ?? data['isOpen'];
      if (isOpenVal == null) {
        _isOpen = true;
      } else {
        _isOpen = isOpenVal == true ||
            isOpenVal == 1 ||
            isOpenVal?.toString() == 'true' ||
            isOpenVal?.toString() == '1';
      }
      _openTime = data['open_time']?.toString() ?? data['openTime']?.toString() ?? '09:00 AM';
      _closeTime = data['close_time']?.toString() ?? data['closeTime']?.toString() ?? '11:00 PM';
      _hasInitialized = true;
      _autoUpdateStatus();
    }
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    await context.read<ProfileCubit>().updateProfile(
      restaurantName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      openTime: _openTime,
      closeTime: _closeTime,
      isOpen: _isOpen,
    );
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final ext = image.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png'
            ? 'image/png'
            : ext == 'webp'
                ? 'image/webp'
                : 'image/jpeg';
        final rawBase64 = base64Encode(bytes);
        final base64Data = 'data:$mimeType;base64,$rawBase64';

        if (mounted) {
          await context.read<ProfileCubit>().updateProfileImage(base64Data);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick/upload image: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            final data = state.profileData;
            setState(() {
              _restaurantImageUrl = data['restaurant_img_url']?.toString() ?? data['img_url']?.toString();
            });
            if (!_hasInitialized) {
              _nameController.text = data['restaurant_name']?.toString() ?? '';
              _emailController.text = data['email']?.toString() ??
                  (FirebaseAuth.instance.currentUser?.email ?? '');
              _phoneController.text = data['phone']?.toString() ?? '';
              _addressController.text = data['address']?.toString() ?? '';
              final isOpenVal = data['is_open'] ?? data['isOpen'];
              if (isOpenVal == null) {
                _isOpen = true;
              } else {
                _isOpen = isOpenVal == true ||
                    isOpenVal == 1 ||
                    isOpenVal?.toString() == 'true' ||
                    isOpenVal?.toString() == '1';
              }
              _openTime = data['open_time']?.toString() ?? data['openTime']?.toString() ?? '09:00 AM';
              _closeTime = data['close_time']?.toString() ?? data['closeTime']?.toString() ?? '11:00 PM';
              _hasInitialized = true;
              _autoUpdateStatus();
            }
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF6C63FF),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state is ProfileLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ── Avatar ─────────────────────────────────────────────
                ProfileAvatarSection(
                  imagePath: _restaurantImageUrl,
                  restaurantName: _nameController.text.isNotEmpty ? _nameController.text : 'Loading...',
                  email: _emailController.text,
                  onChangPhoto: _pickAndUploadImage,
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
                          _autoUpdateStatus();
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
                          _autoUpdateStatus();
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

                const SizedBox(height: 16),

                // ── Save Button ────────────────────────────────────────
                ProfileSaveButton(
                  isLoading: isSaving,
                  onTap: _onSave,
                ),

                // ── Logout ─────────────────────────────────────────────
                ProfileLogoutButton(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    try {
                      await getIt<AuthRepo>().signOut();
                    } catch (_) {}
                    navigator.pushNamedAndRemoveUntil(
                      AppRoutes.loginRouteName,
                      (route) => false,
                    );
                  },
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          );
        },
      ),
    );
  }
}