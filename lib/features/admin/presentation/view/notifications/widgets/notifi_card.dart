
// ─── Notification Card ────────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/notifications/color_const.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/domain/entities/notifi_model.dart';
import 'package:eat2beat/features/admin/presentation/view/notifications/helpers/icon_color.dart';
import 'package:flutter/material.dart';

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
    final color = colorFor(item.type);

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
            color: item.isRead ? kCard : color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isRead ? kBorder : color.withOpacity(0.25),
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
                child: Icon(iconFor(item.type), color: color, size: 20),
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
                              color: kText,
                            ),
                          ),
                        ),
                        Text(item.timeAgo,
                            style: const TextStyle(
                                fontSize: 10, color: kMuted)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: const TextStyle(
                          fontSize: 12, color: kMuted, height: 1.4),
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
