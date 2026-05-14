import 'package:eat2beat/features/admin/presentation/view/notifications/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/cubits/notifications_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/cubits/notifications_state.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/widgets/notifi_card.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/widgets/notifi_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBg,
          appBar: AppBar(
            title: Row(
              children: [
                const Text('Notifications'),

                if (state.unreadCount > 0) ...[
                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text('${state.unreadCount}'),
                  ),
                ],
              ],
            ),

            actions: [
              if (state.unreadCount > 0)
                TextButton(
                  onPressed: () {
                    context
                        .read<NotificationsCubit>()
                        .markAllRead();
                  },
                  child: const Text('Read All'),
                ),
            ],
          ),

          body: state.items.isEmpty
              ? const NotifEmptyState()
              : ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (_, i) {
                    final item = state.items[i];

                    return NotifCard(
                      item: item,

                      onTap: () {
                        context
                            .read<NotificationsCubit>()
                            .markRead(item.id);
                      },

                      onDismiss: () {
                        context
                            .read<NotificationsCubit>()
                            .dismiss(item.id);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}