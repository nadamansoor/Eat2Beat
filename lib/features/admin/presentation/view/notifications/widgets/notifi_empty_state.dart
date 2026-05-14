import 'package:eat2beat/features/admin/presentation/view/notifications/color_const.dart';
import 'package:flutter/material.dart';

class NotifEmptyState extends StatelessWidget {
  const NotifEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded,
                color: kPrimary, size: 34),
          ),
          const SizedBox(height: 16),
          const Text('no notifications yet',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kText)),
          const SizedBox(height: 6),
          const Text('When you receive a notification, it will appear here.',
              style: TextStyle(fontSize: 12, color: kMuted)),
        ],
      ),
    );
  }
}
