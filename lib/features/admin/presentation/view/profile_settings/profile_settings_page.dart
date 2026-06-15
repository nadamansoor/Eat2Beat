import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_avatar.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_logout_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_save_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_card.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_setting_toggle.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_settings_text_field.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/profile_tap_row.dart' show SettingsTapRow;
import 'package:flutter/material.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/widgets/preset_image_picker_dialog.dart';
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

  // Orderability and weekly opening hours state
  bool _orderabilityLoading = false;
  bool _orderabilitySaving = false;
  bool _openingHoursLoading = false;
  bool _openingHoursSaving = false;
  Map<String, dynamic>? _orderabilityStatus;
  String? _orderabilityMessage;
  String? _openingHoursMessage;
  bool _openingHoursConfigured = false;
  List<Map<String, dynamic>> _openingHoursRows = [];
  bool _formIsAcceptingOrders = true;
  final _pauseReasonController = TextEditingController();

  final List<Map<String, dynamic>> _weekDays = const [
    {'value': 0, 'label': 'Monday'},
    {'value': 1, 'label': 'Tuesday'},
    {'value': 2, 'label': 'Wednesday'},
    {'value': 3, 'label': 'Thursday'},
    {'value': 4, 'label': 'Friday'},
    {'value': 5, 'label': 'Saturday'},
    {'value': 6, 'label': 'Sunday'},
  ];

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
    _loadRestaurantOrderability();
    _loadRestaurantOpeningHours();
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
    _pauseReasonController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurantOrderability() async {
    setState(() {
      _orderabilityLoading = true;
      _orderabilityMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      if (token == null) return;

      final apiService = getIt<ApiService>();
      final data = await apiService.getRestaurantOrderability(token);
      
      setState(() {
        _orderabilityStatus = data;
        final res = data['restaurant'];
        _formIsAcceptingOrders = res?['is_accepting_orders'] == true;
        _pauseReasonController.text = res?['pause_reason']?.toString() ?? '';
        _orderabilityLoading = false;
      });
    } catch (e) {
      setState(() {
        _orderabilityLoading = false;
        _orderabilityMessage = 'Failed to load orderability status.';
      });
    }
  }

  Future<void> _saveOrderability() async {
    if (_orderabilitySaving) return;
    setState(() {
      _orderabilitySaving = true;
      _orderabilityMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      if (token == null) return;

      final apiService = getIt<ApiService>();
      final pauseReason = _formIsAcceptingOrders ? null : _pauseReasonController.text.trim();
      await apiService.updateRestaurantOrderability(
        token,
        isAcceptingOrders: _formIsAcceptingOrders,
        pauseReason: pauseReason,
      );
      setState(() {
        _orderabilitySaving = false;
        _orderabilityMessage = 'Orderability updated successfully.';
      });
      _loadRestaurantOrderability();
    } catch (e) {
      setState(() {
        _orderabilitySaving = false;
        _orderabilityMessage = 'Failed to update orderability: $e';
      });
    }
  }

  Future<void> _loadRestaurantOpeningHours() async {
    setState(() {
      _openingHoursLoading = true;
      _openingHoursMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      if (token == null) return;

      final apiService = getIt<ApiService>();
      final List<dynamic> rows = await apiService.getRestaurantOpeningHours(token);
      
      setState(() {
        _openingHoursConfigured = rows.isNotEmpty;
        _openingHoursRows = _normalizeOpeningHours(rows);
        _openingHoursLoading = false;
      });
    } catch (e) {
      setState(() {
        _openingHoursRows = _defaultOpeningHours();
        _openingHoursConfigured = false;
        _openingHoursLoading = false;
        _openingHoursMessage = 'Failed to load opening hours.';
      });
    }
  }

  List<Map<String, dynamic>> _defaultOpeningHours() {
    return _weekDays.map((day) => {
      'day_of_week': day['value'],
      'open_time': '09:00',
      'close_time': '22:00',
      'is_closed': true,
    }).toList();
  }

  List<Map<String, dynamic>> _normalizeOpeningHours(List<dynamic> rows) {
    final Map<int, Map<String, dynamic>> byDay = {};
    for (final row in rows) {
      if (row is! Map) continue;
      final rawDay = row['day_of_week'];
      final dayNum = rawDay is int 
          ? rawDay 
          : int.tryParse(rawDay?.toString() ?? '') ?? -1;
      if (dayNum < 0 || dayNum > 6) continue;
      
      final open = row['open_time']?.toString() ?? '';
      final close = row['close_time']?.toString() ?? '';
      byDay[dayNum] = {
        'day_of_week': dayNum,
        'open_time': open.length >= 5 ? open.substring(0, 5) : '09:00',
        'close_time': close.length >= 5 ? close.substring(0, 5) : '22:00',
        'is_closed': row['is_closed'] == true,
      };
    }

    return _weekDays.map((day) {
      final value = day['value'] as int;
      return byDay[value] ?? {
        'day_of_week': value,
        'open_time': '09:00',
        'close_time': '22:00',
        'is_closed': true,
      };
    }).toList();
  }

  Future<void> _saveOpeningHours() async {
    if (_openingHoursSaving) return;
    
    // Validate rows
    final invalidRow = _openingHoursRows.firstWhere(
      (row) => !row['is_closed'] && (row['open_time'] == null || row['close_time'] == null || row['open_time'].toString().trim().isEmpty || row['close_time'].toString().trim().isEmpty),
      orElse: () => {},
    );
    if (invalidRow.isNotEmpty) {
      final int dayOfWeek = invalidRow['day_of_week'];
      setState(() {
        _openingHoursMessage = 'Open and close times are required for ${_weekDays[dayOfWeek]['label']}.';
      });
      return;
    }

    setState(() {
      _openingHoursSaving = true;
      _openingHoursMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      if (token == null) return;

      final payloadRows = _openingHoursRows.map((row) {
        final open = row['open_time'].toString().trim();
        final close = row['close_time'].toString().trim();
        return {
          'day_of_week': row['day_of_week'],
          'open_time': row['is_closed'] ? null : (open.contains(':') && open.split(':').length == 2 ? '$open:00' : open),
          'close_time': row['is_closed'] ? null : (close.contains(':') && close.split(':').length == 2 ? '$close:00' : close),
          'is_closed': row['is_closed'],
        };
      }).toList();

      final apiService = getIt<ApiService>();
      await apiService.upsertRestaurantOpeningHours(token, {'hours': payloadRows});

      setState(() {
        _openingHoursSaving = false;
        _openingHoursMessage = 'Opening hours updated successfully.';
      });
      _loadRestaurantOpeningHours();
      _loadRestaurantOrderability();
    } catch (e) {
      setState(() {
        _openingHoursSaving = false;
        _openingHoursMessage = 'Failed to update opening hours: $e';
      });
    }
  }

  String _getOrderabilityLabel() {
    final status = _orderabilityStatus;
    if (status == null) return 'Loading...';
    final res = status['restaurant'];
    if (res == null) return 'Unknown';
    if (res['is_orderable_now'] == true) return 'Open Now';
    if (res['is_accepting_orders'] == false) {
      final reason = res['pause_reason']?.toString() ?? '';
      return 'Paused${reason.isNotEmpty ? " ($reason)" : ""}';
    }
    if (res['is_open_now'] == false) return 'Closed now';
    return 'Not orderable';
  }

  Color _getOrderabilityColor() {
    final status = _orderabilityStatus;
    if (status == null) return Colors.grey;
    final res = status['restaurant'];
    if (res == null) return Colors.grey;
    if (res['is_orderable_now'] == true) return const Color(0xFF10B981);
    if (res['is_accepting_orders'] == false) return const Color(0xFFEF4444);
    if (res['is_open_now'] == false) return const Color(0xFFF59E0B);
    return Colors.grey;
  }

  Widget _buildMiniStatusRow(String label, dynamic value) {
    final boolVal = value == true || value == 1 || value?.toString() == 'true' || value?.toString() == '1';
    String statusText = 'Unknown';
    Color statusColor = Colors.grey;
    if (value != null) {
      if (label == 'Restaurant Active') {
        statusText = boolVal ? 'Active' : 'Inactive';
        statusColor = boolVal ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      } else if (label == 'Open Now') {
        statusText = boolVal ? 'Open now' : 'Closed now';
        statusColor = boolVal ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
      } else if (label == 'Accepting Orders') {
        statusText = boolVal ? 'Accepting orders' : 'Not accepting orders';
        statusColor = boolVal ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      } else if (label == 'Orderable Now') {
        statusText = boolVal ? 'Orderable now' : 'Not orderable now';
        statusColor = boolVal ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: kMuted),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
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

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
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

  void _showPresetImagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PresetImagePickerDialog(
          onImageSelected: (url) async {
            await context.read<ProfileCubit>().updateProfileImage(url);
          },
        );
      },
    );
  }

  void _pickAndUploadImage() {
    final isDark = ThemeNotifier().isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? kSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pull handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'تحديث صورة المطعم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'اختر الطريقة المناسبة لتحديث صورة مطعمك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Option 1: Preset Helper (Recommended)
              _buildPickerOption(
                icon: Icons.auto_awesome_rounded,
                title: 'مساعد الصور الجاهزة (موصى به)',
                subtitle: 'اختر صورة احترافية من معرض الصور الجاهزة لمختلف الأطعمة',
                iconColor: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFF5F3FF),
                onTap: () {
                  Navigator.of(context).pop();
                  _showPresetImagePicker();
                },
              ),
              const SizedBox(height: 12),
              
              // Option 2: Camera
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                title: 'التقاط صورة بالكاميرا',
                subtitle: 'التقط صورة حية لمطعمك أو أطباقك الآن باستخدام الكاميرا',
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromSource(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              
              // Option 3: Gallery
              _buildPickerOption(
                icon: Icons.image_rounded,
                title: 'اختيار من معرض الصور',
                subtitle: 'اختر صورة محفوظة بالفعل على جهازك لتكون صورة لمطعمك',
                iconColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    final isDark = ThemeNotifier().isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.transparent : kBorder),
          color: isDark ? kSurface2 : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
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

                // ── Orderability & Pause Settings ──────────────────────
                SettingsSectionCard(
                  title: 'Orderability & Pause',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getOrderabilityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getOrderabilityColor().withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _orderabilityStatus?['restaurant']?['is_orderable_now'] == true
                                  ? Icons.check_circle_rounded
                                  : Icons.warning_rounded,
                              color: _getOrderabilityColor(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Final Orderability Status',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: kMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getOrderabilityLabel(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _getOrderabilityColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, color: kPrimary),
                              onPressed: _loadRestaurantOrderability,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_orderabilityStatus != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: ThemeNotifier().isDarkMode ? kSurface2 : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBorder),
                          ),
                          child: Column(
                            children: [
                              _buildMiniStatusRow('Restaurant Active', _orderabilityStatus?['restaurant']?['is_active'] ?? _orderabilityStatus?['is_active']),
                              const Divider(color: kBorder, height: 8),
                              _buildMiniStatusRow('Open Now', _orderabilityStatus?['restaurant']?['is_open_now'] ?? _orderabilityStatus?['is_open_now']),
                              const Divider(color: kBorder, height: 8),
                              _buildMiniStatusRow('Accepting Orders', _orderabilityStatus?['restaurant']?['is_accepting_orders'] ?? _orderabilityStatus?['is_accepting_orders']),
                              const Divider(color: kBorder, height: 8),
                              _buildMiniStatusRow('Orderable Now', _orderabilityStatus?['restaurant']?['is_orderable_now'] ?? _orderabilityStatus?['is_orderable_now']),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manual Order Pause',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _formIsAcceptingOrders = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _formIsAcceptingOrders ? const Color(0xFF10B981) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: _formIsAcceptingOrders ? const Color(0xFF10B981) : kBorder),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Accepting Orders',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _formIsAcceptingOrders ? Colors.white : kText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _formIsAcceptingOrders = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_formIsAcceptingOrders ? const Color(0xFFEF4444) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: !_formIsAcceptingOrders ? const Color(0xFFEF4444) : kBorder),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Pause Orders',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: !_formIsAcceptingOrders ? Colors.white : kText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!_formIsAcceptingOrders)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pause Reason',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: kText),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _pauseReasonController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'e.g., Kitchen maintenance until 6 PM',
                                hintStyle: const TextStyle(color: kMuted, fontSize: 13),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: kBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: kPrimary),
                                ),
                                filled: true,
                                fillColor: ThemeNotifier().isDarkMode ? kSurface2 : const Color(0xFFF9FAFB),
                              ),
                              style: const TextStyle(fontSize: 14, color: kText),
                            ),
                          ],
                        ),
                      ),
                    if (_orderabilityMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Text(
                          _orderabilityMessage!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _orderabilityMessage!.contains('successfully') ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _orderabilitySaving || _orderabilityLoading ? null : _saveOrderability,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: _orderabilitySaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Orderability',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Weekly Opening Hours ────────────────────────────────
                SettingsSectionCard(
                  title: 'Weekly Opening Hours',
                  children: [
                    if (_openingHoursLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.purple800),
                        ),
                      )
                    else if (!_openingHoursConfigured)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_today_rounded, size: 40, color: kPrimary),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No opening hours configured yet',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kText),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Set up your weekly operating schedule to automatically open and close your restaurant.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: kMuted),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _openingHoursConfigured = true;
                                    _openingHoursRows = _defaultOpeningHours();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Initialize Schedule',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: List.generate(_openingHoursRows.length, (index) {
                            final row = _openingHoursRows[index];
                            final int dayVal = row['day_of_week'] as int;
                            final dayName = _weekDays.firstWhere(
                              (d) => d['value'] == dayVal,
                              orElse: () => {'label': 'Unknown'},
                            )['label'] as String;
                            final isClosed = row['is_closed'] == true;
                            final openTimeStr = row['open_time']?.toString() ?? '09:00';
                            final closeTimeStr = row['close_time']?.toString() ?? '22:00';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      dayName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: kText,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isClosed,
                                        activeColor: kPrimary,
                                        onChanged: (val) {
                                          setState(() {
                                            row['is_closed'] = val == true;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Closed',
                                        style: TextStyle(fontSize: 13, color: kMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: Opacity(
                                      opacity: isClosed ? 0.4 : 1.0,
                                      child: IgnorePointer(
                                        ignoring: isClosed,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            final parts = openTimeStr.split(':');
                                            final initHour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 9 : 9;
                                            final initMin = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
                                            
                                            final picked = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(hour: initHour, minute: initMin),
                                            );
                                            if (picked != null) {
                                              final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                              setState(() {
                                                row['open_time'] = formatted;
                                              });
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                            side: const BorderSide(color: kBorder),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: Text(
                                            openTimeStr,
                                            style: const TextStyle(fontSize: 13, color: kText),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 2,
                                    child: Opacity(
                                      opacity: isClosed ? 0.4 : 1.0,
                                      child: IgnorePointer(
                                        ignoring: isClosed,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            final parts = closeTimeStr.split(':');
                                            final initHour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 22 : 22;
                                            final initMin = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

                                            final picked = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(hour: initHour, minute: initMin),
                                            );
                                            if (picked != null) {
                                              final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                              setState(() {
                                                row['close_time'] = formatted;
                                              });
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                            side: const BorderSide(color: kBorder),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: Text(
                                            closeTimeStr,
                                            style: const TextStyle(fontSize: 13, color: kText),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      if (_openingHoursMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(
                            _openingHoursMessage!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _openingHoursMessage!.contains('successfully') ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _openingHoursSaving || _openingHoursLoading ? null : _saveOpeningHours,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: _openingHoursSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Opening Hours',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ],
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