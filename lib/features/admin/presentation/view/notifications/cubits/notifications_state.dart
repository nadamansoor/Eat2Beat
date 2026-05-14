import 'package:eat2beat/features/admin/presentation/view/notifications/domain/entities/notifi_model.dart';

class NotificationsState {
  final List<NotifItem> items;

  const NotificationsState({
    required this.items,
  });

  int get unreadCount =>
      items.where((e) => !e.isRead).length;

  NotificationsState copyWith({
    List<NotifItem>? items,
  }) {
    return NotificationsState(
      items: items ?? this.items,
    );
  }
}