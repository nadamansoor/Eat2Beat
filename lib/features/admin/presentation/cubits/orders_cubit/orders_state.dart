import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  final String timeFilter; // 'today' | 'week' | 'all'
  final OrderStatus? statusFilter; // null means 'All'
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;

  const OrdersLoaded({
    required this.orders,
    required this.timeFilter,
    this.statusFilter,
    this.nextCursor,
    required this.hasMore,
    this.loadingMore = false,
  });

  OrdersLoaded copyWith({
    List<OrderEntity>? orders,
    String? timeFilter,
    OrderStatus? statusFilter,
    bool clearStatusFilter = false,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      timeFilter: timeFilter ?? this.timeFilter,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});
}
