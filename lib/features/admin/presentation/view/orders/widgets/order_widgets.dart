import 'package:flutter/material.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_cubit.dart';

// ─── Order Status Extension ──────────────────────────────────────────
extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.approved:
        return 'Approved';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.picked:
        return 'Picked';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFF1C40F);
      case OrderStatus.approved:
        return const Color(0xFF1ABC9C);
      case OrderStatus.preparing:
        return kPreparing;
      case OrderStatus.onTheWay:
        return kOnTheWay;
      case OrderStatus.picked:
        return const Color(0xFFE67E22);
      case OrderStatus.delivered:
        return kDelivered;
      case OrderStatus.cancelled:
        return kCancelled;
    }
  }

  Color get bgColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFEF9E7);
      case OrderStatus.approved:
        return const Color(0xFFE8F8F5);
      case OrderStatus.preparing:
        return kPreparingBg;
      case OrderStatus.onTheWay:
        return kOnTheWayBg;
      case OrderStatus.picked:
        return const Color(0xFFFDF2E9);
      case OrderStatus.delivered:
        return kDeliveredBg;
      case OrderStatus.cancelled:
        return kCancelledBg;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.hourglass_empty_rounded;
      case OrderStatus.approved:
        return Icons.thumb_up_alt_outlined;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_outlined;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining_outlined;
      case OrderStatus.picked:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  List<OrderStatus> get allowedNextStatuses {
    switch (this) {
      case OrderStatus.pending:
        return [OrderStatus.approved, OrderStatus.cancelled];
      case OrderStatus.approved:
        return [OrderStatus.preparing, OrderStatus.onTheWay, OrderStatus.picked, OrderStatus.cancelled];
      case OrderStatus.preparing:
        return [OrderStatus.onTheWay, OrderStatus.picked, OrderStatus.delivered, OrderStatus.cancelled];
      case OrderStatus.onTheWay:
        return [OrderStatus.delivered, OrderStatus.cancelled];
      case OrderStatus.picked:
        return [OrderStatus.delivered];
      default:
        return [];
    }
  }
}

// ─── Order Status Badge ───────────────────────────────────────────────
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: statusColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────
class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = order.status.color;
    final cubit = context.read<OrdersCubit>();
    final allowedNext = order.status.allowedNextStatuses;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: statusColor,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORDER ID',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${order.id}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: kBorder, height: 1),
              ),

              // Customer info block
              _buildInfoRow(Icons.person_outline_rounded, order.customerName),
              const SizedBox(height: 6),
              if (order.phone.isNotEmpty) ...[
                _buildInfoRow(Icons.phone_outlined, order.phone),
                const SizedBox(height: 6),
              ],
              if (order.address.isNotEmpty) ...[
                _buildInfoRow(
                  Icons.location_on_outlined,
                  '${order.address}${order.area.isNotEmpty ? ", ${order.area}" : ""}',
                ),
                const SizedBox(height: 6),
              ],
              _buildInfoRow(Icons.access_time_rounded, order.timestamp.isNotEmpty ? _formatDate(order.timestamp) : ''),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: kBorder, height: 1),
              ),

              // Ordered Items
              const Text(
                'Ordered Items',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: kPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kText,
                      ),
                    ),
                  ],
                ),
              )),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: kBorder, height: 1),
              ),

              // Footer: Total Amount + Actions Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 11,
                          color: kMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (allowedNext.isNotEmpty)
                    _buildActionsDropdown(context, cubit, allowedNext)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kBorder.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, color: kMuted, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Completed',
                            style: TextStyle(color: kMuted, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kMuted, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: kText,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp).toLocal();
      final isPm = date.hour >= 12;
      final hour12 = date.hour == 0
          ? 12
          : date.hour > 12
              ? date.hour - 12
              : date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final second = date.second.toString().padLeft(2, '0');
      final amPm = isPm ? 'PM' : 'AM';
      return '${date.month}/${date.day}/${date.year}, $hour12:$minute:$second $amPm';
    } catch (_) {
      return timestamp;
    }
  }

  Widget _buildActionsDropdown(BuildContext context, OrdersCubit cubit, List<OrderStatus> allowedNext) {
    final List<OrderStatus> dropdownItems = [order.status, ...allowedNext];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorder, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrderStatus>(
          value: order.status,
          dropdownColor: kCard,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimary, size: 18),
          style: const TextStyle(
            color: kText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (newStatus) {
            if (newStatus != null && newStatus != order.status) {
              cubit.updateOrderStatus(orderId: order.id, status: newStatus);
            }
          },
          items: dropdownItems.map((status) {
            return DropdownMenuItem<OrderStatus>(
              value: status,
              child: Text(
                status.label,
                style: TextStyle(
                  color: status == order.status ? kPrimary : kText,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}