import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json, int id) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else {
        parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
      }
    }

    int parsedQuantity = 1;
    if (json['quantity'] != null) {
      if (json['quantity'] is num) {
        parsedQuantity = (json['quantity'] as num).toInt();
      } else {
        parsedQuantity = int.tryParse(json['quantity'].toString()) ?? 1;
      }
    }

    return OrderItemModel(
      id: id,
      name: json['title']?.toString() ?? json['name']?.toString() ?? 'Meal',
      price: parsedPrice,
      quantity: parsedQuantity,
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerName,
    required super.phone,
    required super.address,
    required super.city,
    required super.area,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.paymentMethod,
    required super.status,
    required super.timestamp,
  });

  static OrderStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return OrderStatus.pending;
    final val = statusStr.trim().toLowerCase();
    if (val == 'accepted') return OrderStatus.approved;
    if (val == 'on-the-way') return OrderStatus.onTheWay;
    
    for (var status in OrderStatus.values) {
      if (status.name.toLowerCase() == val) {
        return status;
      }
    }
    return OrderStatus.pending;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    int index = 1;
    final items = rawItems.map((item) {
      final itemMap = item as Map<String, dynamic>;
      return OrderItemModel.fromJson(itemMap, index++);
    }).toList();

    final subtotal = items.fold<double>(0.0, (sum, it) => sum + (it.price * it.quantity));
    final tax = subtotal * 0.05;
    final total = subtotal + tax;

    return OrderModel(
      id: json['id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? 'Customer',
      phone: json['customer_phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      paymentMethod: json['payment_method']?.toString() ?? 'unknown',
      status: _parseStatus(json['status']?.toString()),
      timestamp: json['created_at']?.toString() ?? json['timestamp']?.toString() ?? '',
    );
  }
}
