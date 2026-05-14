import 'package:eat2beat/features/admin/presentation/view/orders/widgets/action_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/card_details.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/customer_info.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/order_details.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/order_item.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/orders_app_bar.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/widgets/payment.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final String status;

  const OrderDetailPage({
    super.key,
    this.orderId = '#2847',
    this.status = 'Preparing now',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: OrderDetailAppBar(orderId: orderId, status: status),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Customer
            DetailCard(
              title: 'Customer',
              child: CustomerInfo(
                name: 'Mohammed Hassan',
                address: '123 Main St, Apt 4b',
                initials: 'MH',
                avatarColor: const Color(0xFFFF8C42),
              ),
            ),
            const SizedBox(height: 12),

            // ── Order Items
            DetailCard(
              title: 'Order Items',
              child: Column(
                children: [
                  const OrderItemRow(
                    name: 'Caesar Salad',
                    quantity: 2,
                    price: 16.00,
                    dotColor: Color(0xFF6C63FF),
                  ),
                  const OrderItemRow(
                    name: 'Beef Burger',
                    quantity: 1,
                    price: 8.50,
                    dotColor: Color(0xFFFF8C42),
                  ),
                  OrderTotalRow(total: 24.50),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Payment
            DetailCard(
              title: 'Payment',
              child: PaymentRow(
                method: 'Mastercard •••• 5821',
                isPaid: true,
              ),
            ),
            const SizedBox(height: 24),

            // ── Action buttons
            OrderActionButtons(
              onCancel: () {
                // TODO: cancel order
              },
              onMarkReady: () {
                // TODO: mark as ready
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}