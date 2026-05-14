enum NotifType { order, meal, system }

class NotifItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotifType type;
  final bool isRead;

  const NotifItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  NotifItem copyWith({bool? isRead}) =>
      NotifItem(
        id: id,
        title: title,
        body: body,
        timeAgo: timeAgo,
        type: type,
        isRead: isRead ?? this.isRead,
      );
}
