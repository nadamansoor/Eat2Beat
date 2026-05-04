import 'package:flutter/material.dart';

// ─── Colors ───────────────────────────────────────────────────────────
const _kBg      = Color(0xFFF5F7FA);
const _kCard    = Color(0xFFFFFFFF);
const _kBorder  = Color(0xFFEEF0F4);
const _kText    = Color(0xFF1A1D23);
const _kMuted   = Color(0xFF9499A5);
const _kPrimary = Color(0xFF6C63FF);

// ─── Model ────────────────────────────────────────────────────────────
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

// ─── Helpers ──────────────────────────────────────────────────────────
IconData _iconFor(NotifType t) {
  switch (t) {
    case NotifType.order:  return Icons.receipt_long_rounded;
    case NotifType.meal:   return Icons.restaurant_menu_rounded;
    case NotifType.system: return Icons.info_outline_rounded;
  }
}

Color _colorFor(NotifType t) {
  switch (t) {
    case NotifType.order:  return const Color(0xFF10B981);
    case NotifType.meal:   return _kPrimary;
    case NotifType.system: return const Color(0xFFF59E0B);
  }
}

// ─── Notification Card ────────────────────────────────────────────────
class NotifCard extends StatelessWidget {
  final NotifItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotifCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(item.type);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 22),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead ? _kCard : color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isRead ? _kBorder : color.withOpacity(0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_iconFor(item.type), color: color, size: 20),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: _kText,
                            ),
                          ),
                        ),
                        Text(item.timeAgo,
                            style: const TextStyle(
                                fontSize: 10, color: _kMuted)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: const TextStyle(
                          fontSize: 12, color: _kMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
              // Unread dot
              if (!item.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────
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
              color: _kPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded,
                color: _kPrimary, size: 34),
          ),
          const SizedBox(height: 16),
          const Text('لا توجد إشعارات',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _kText)),
          const SizedBox(height: 6),
          const Text('ستظهر هنا عند وصول إشعارات جديدة',
              style: TextStyle(fontSize: 12, color: _kMuted)),
        ],
      ),
    );
  }
}

// ─── Notifications Page ───────────────────────────────────────────────
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Mock data — استبدليها بـ API
  List<NotifItem> _items = const [
    NotifItem(
      id: '1',
      title: 'طلب جديد #ORD-2848',
      body: 'وصل طلب جديد من محمد حسن — Caesar Salad × 2',
      timeAgo: 'الآن',
      type: NotifType.order,
      isRead: false,
    ),
    NotifItem(
      id: '2',
      title: 'وجبة في انتظار الموافقة',
      body: 'Pasta Primavera من الشيف سارة تنتظر مراجعتك',
      timeAgo: '5 د',
      type: NotifType.meal,
      isRead: false,
    ),
    NotifItem(
      id: '3',
      title: 'طلب تم تسليمه',
      body: 'تم تسليم الطلب #ORD-2845 بنجاح',
      timeAgo: '20 د',
      type: NotifType.order,
      isRead: true,
    ),
    NotifItem(
      id: '4',
      title: 'تحديث النظام',
      body: 'تم تحديث لوحة التحكم إلى الإصدار الجديد',
      timeAgo: '1 س',
      type: NotifType.system,
      isRead: true,
    ),
    NotifItem(
      id: '5',
      title: 'طلب ملغي #ORD-2840',
      body: 'قام العميل بإلغاء الطلب — Grilled Wrap × 3',
      timeAgo: '2 س',
      type: NotifType.order,
      isRead: true,
    ),
  ];

  int get _unreadCount => _items.where((e) => !e.isRead).length;

  void _markAllRead() {
    setState(() {
      _items = _items.map((e) => e.copyWith(isRead: true)).toList();
    });
  }

  void _markRead(String id) {
    setState(() {
      _items = _items
          .map((e) => e.id == id ? e.copyWith(isRead: true) : e)
          .toList();
    });
  }

  void _dismiss(String id) {
    setState(() => _items.removeWhere((e) => e.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _kText, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const Text('الإشعارات',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kText)),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _kPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$_unreadCount',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('قراءة الكل',
                  style: TextStyle(
                      fontSize: 12,
                      color: _kPrimary,
                      fontWeight: FontWeight.w600)),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _kBorder),
        ),
      ),
      body: _items.isEmpty
          ? const NotifEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: _items.length,
              itemBuilder: (_, i) => NotifCard(
                item: _items[i],
                onTap: () => _markRead(_items[i].id),
                onDismiss: () => _dismiss(_items[i].id),
              ),
            ),
    );
  }
}