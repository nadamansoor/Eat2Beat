import 'package:eat2beat/features/admin/presentation/view/orders/const.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/details_view.dart';
import 'package:eat2beat/features/admin/presentation/view/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

// ─── Colors ─────────────────────────────────────────────────────────

// Status colors

// ─── Order Status ────────────────────────────────────────────────────
enum OrderStatus { preparing, onTheWay, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.preparing:
        return kPreparing;
      case OrderStatus.onTheWay:
        return kOnTheWay;
      case OrderStatus.delivered:
        return kDelivered;
      case OrderStatus.cancelled:
        return kCancelled;
    }
  }

  Color get bgColor {
    switch (this) {
      case OrderStatus.preparing:
        return kPreparingBg;
      case OrderStatus.onTheWay:
        return kOnTheWayBg;
      case OrderStatus.delivered:
        return kDeliveredBg;
      case OrderStatus.cancelled:
        return kCancelledBg;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.preparing:
        return Icons.soup_kitchen_outlined;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining_outlined;
      case OrderStatus.delivered:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

// ─── Order Model ──────────────────────────────────────────────────────
class OrderModel {
  final String id;
  final String items;
  final double price;
  final OrderStatus status;
  final String timeAgo;

  const OrderModel({
    required this.id,
    required this.items,
    required this.price,
    required this.status,
    required this.timeAgo,
  });
}

// ─── Orders App Bar ───────────────────────────────────────────────────
class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(165);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Today · 47 orders',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
       
          SizedBox(height: 10),
          const SearchTextField(),
          // Search bar
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search orders...',
          //       hintStyle: TextStyle(
          //         fontSize: 13,
          //         color: _kMuted,
          //       ),
          //       prefixIcon: Icon(
          //         Icons.search_rounded,
          //         color: _kMuted,
          //         size: 20,
          //       ),
          //       border: InputBorder.none,
          //       contentPadding: EdgeInsets.symmetric(vertical: 10),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ─── Filter Tabs ──────────────────────────────────────────────────────
class OrderFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<String> tabs;

  const OrderFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCard,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? kPrimary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? kPrimary : kMuted,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Order Status Badge ───────────────────────────────────────────────
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailPage(
                      orderId: order.id,
                      status: order.status.label,
                    ),
                  ),
                );
              },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  order.timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: kMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Items
            Text(
              order.items,
              style: const TextStyle(
                fontSize: 12,
                color: kMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            // Price + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}