import 'package:eat2beat/features/admin/presentation/view/orders/widgets/order_widgets.dart';
import 'package:flutter/material.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedTab = 0;

  final List<String> _tabs = ['All', 'Preparing', 'Delivered', 'Cancelled'];

  // Mock data — استبدليها بـ API calls
  final List<OrderModel> _allOrders = const [
    OrderModel(
      id: '#ORD-2847',
      items: 'Caesar Salad × 2, Burger × 1',
      price: 24.50,
      status: OrderStatus.preparing,
      timeAgo: '2 min ago',
    ),
    OrderModel(
      id: '#ORD-2846',
      items: 'Pasta Primavera × 1, Lentil Stew × 2',
      price: 31.00,
      status: OrderStatus.onTheWay,
      timeAgo: '8 min ago',
    ),
    OrderModel(
      id: '#ORD-2845',
      items: 'Thai Noodle × 1',
      price: 14.00,
      status: OrderStatus.delivered,
      timeAgo: '15 min ago',
    ),
    OrderModel(
      id: '#ORD-2844',
      items: 'Grilled Wrap × 3',
      price: 27.00,
      status: OrderStatus.cancelled,
      timeAgo: '22 min ago',
    ),
    OrderModel(
      id: '#ORD-2843',
      items: 'Veggie Bowl × 2, Juice × 2',
      price: 19.50,
      status: OrderStatus.delivered,
      timeAgo: '35 min ago',
    ),
    OrderModel(
      id: '#ORD-2842',
      items: 'Margherita Pizza × 1',
      price: 12.00,
      status: OrderStatus.preparing,
      timeAgo: '41 min ago',
    ),
  ];

  List<OrderModel> get _filteredOrders {
    if (_selectedTab == 0) return _allOrders;
    final statusMap = {
      1: OrderStatus.preparing,
      2: OrderStatus.delivered,
      3: OrderStatus.cancelled,
    };
    return _allOrders
        .where((o) => o.status == statusMap[_selectedTab])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const OrdersAppBar(),
      body: Column(
        children: [
          // Filter tabs
          OrderFilterTabs(
            selectedIndex: _selectedTab,
            tabs: _tabs,
            onTap: (i) => setState(() => _selectedTab = i),
          ),
          // Divider
          Container(height: 1, color: const Color(0xFFEEF0F4)),
          const SizedBox(height: 6),
          // Orders list
          Expanded(
            child: _filteredOrders.isEmpty
                ? const Center(
                    child: Text(
                      'No orders found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9499A5),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, i) {
                      return OrderCard(
                        order: _filteredOrders[i],
                        onTap: () {
                          // TODO: navigate to order details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}