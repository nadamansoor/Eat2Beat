import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/cubits/notifications_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/notifi.dart';
import 'package:eat2beat/features/admin/presentation/view/profile_settings/profile_settings_page.dart';
import 'package:eat2beat/features/admin/presentation/view/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Enums ────────────────────────────────────────────────────────────
enum FoodCategory { all, vegan, protein }

enum ApprovalStatus { approved, pending, rejected }

// ─── Model ────────────────────────────────────────────────────────────

class CustomAdminAppbar extends StatelessWidget {
  final String userName;
  final String greeting;
  final String? avatarImagePath;
  final VoidCallback? onNotificationTap;

  const CustomAdminAppbar({
    super.key,
    required this.userName,
    this.greeting = 'Hello',
    this.avatarImagePath,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Increased height because search is added under the row
    final double totalHeight = statusBarHeight + 130;

    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      expandedHeight: totalHeight,
      toolbarHeight: totalHeight,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.purple50,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Row: Avatar | Name | 🔔 ──────────────────────────
              Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 20,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final profileCubit = BlocProvider.of<ProfileCubit>(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: profileCubit,
                              child: const ProfileSettingsPage(),
                            ),
                          ),
                        );
                      },
                      child: _buildAvatar(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    //Notification button
                    GestureDetector(
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider(
                                    create: (context) => NotificationsCubit(),
                                    child: const NotificationsPage(),
                                  ),
                            ),
                          ),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF3B82F6),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Search (Unchanged) ──────────
              SizedBox(height: 12),
              const SearchTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3B82F6), width: 2),
      ),
      child: ClipOval(
        child: _buildAvatarImage(),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (avatarImagePath == null || avatarImagePath!.isEmpty) {
      return Container(
        color: const Color(0xFFDBEAFE),
        child: const Icon(
          Icons.store_rounded,
          color: Color(0xFF3B82F6),
          size: 28,
        ),
      );
    }
    if (avatarImagePath!.startsWith('http')) {
      return Image.network(
        avatarImagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFDBEAFE),
          child: const Icon(
            Icons.store_rounded,
            color: Color(0xFF3B82F6),
            size: 28,
          ),
        ),
      );
    }
    return Image.asset(
      avatarImagePath!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFDBEAFE),
        child: const Icon(
          Icons.store_rounded,
          color: Color(0xFF3B82F6),
          size: 28,
        ),
      ),
    );
  }
}
