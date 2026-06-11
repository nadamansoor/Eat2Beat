enum OrderStatus { pending, approved, preparing, onTheWay, picked, delivered, cancelled }

class OrderItemEntity {
  final int id;
  final String name;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class OrderEntity {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String city;
  final String area;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;
  final OrderStatus status;
  final String timestamp;

  const OrderEntity({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.city,
    required this.area,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });

  String get itemsSummary {
    return items.map((it) => '${it.name} × ${it.quantity}').join(', ');
  }

  String get timeAgo {
    if (timestamp.isEmpty) return '';
    try {
      final date = DateTime.parse(timestamp).toLocal();
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }
}
