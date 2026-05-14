import 'package:bloc/bloc.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/cubits/notifications_state.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/domain/entities/notifi_model.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit()
      : super(
          const NotificationsState(
            items: [
              NotifItem(
                id: '1',
                title: 'New Order #ORD-2848',
                body:
                    'A new order has arrived from Mohamed Hassan — Caesar Salad × 2',
                timeAgo: 'Now',
                type: NotifType.order,
                isRead: false,
              ),
              NotifItem(
                id: '2',
                title: 'Meal Pending Approval',
                body:
                    'Pasta Primavera by Chef Sara is waiting for your review',
                timeAgo: '5 min',
                type: NotifType.meal,
                isRead: false,
              ),
            ],
          ),
        );

  void markAllRead() {
    emit(
      state.copyWith(
        items: state.items
            .map((e) => e.copyWith(isRead: true))
            .toList(),
      ),
    );
  }

  void markRead(String id) {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (e) => e.id == id
                  ? e.copyWith(isRead: true)
                  : e,
            )
            .toList(),
      ),
    );
  }

  void dismiss(String id) {
    final updated =
        state.items.where((e) => e.id != id).toList();

    emit(state.copyWith(items: updated));
  }
}