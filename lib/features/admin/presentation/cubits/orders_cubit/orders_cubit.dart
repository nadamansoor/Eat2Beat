import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_orders_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_order_status_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final AuthRepo authRepo;
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final int pageSize = 20;

  OrdersCubit({
    required this.authRepo,
    required this.getOrdersUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(OrdersInitial());

  Future<void> loadOrders({
    String? timeFilter,
    OrderStatus? statusFilter,
    bool clearStatusFilter = false,
  }) async {
    String time = 'today';
    OrderStatus? status;

    final currentState = state;
    if (currentState is OrdersLoaded) {
      time = currentState.timeFilter;
      status = currentState.statusFilter;
    }

    if (timeFilter != null) {
      time = timeFilter;
    }
    if (clearStatusFilter) {
      status = null;
    } else if (statusFilter != null) {
      status = statusFilter;
    }

    emit(OrdersLoading());

    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(const OrdersError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    // Convert OrderStatus enum to worker expected string:
    // e.g. OrderStatus.onTheWay -> 'on-the-way'
    String? statusString;
    if (status != null) {
      if (status == OrderStatus.onTheWay) {
        statusString = 'on-the-way';
      } else {
        statusString = status.name;
      }
    }

    final result = await getOrdersUseCase(
      token: token,
      limit: pageSize,
      time: time,
      status: statusString,
      cursor: null,
      offset: 0,
    );

    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (data) {
        final List<OrderEntity> orders = List<OrderEntity>.from(data['orders']);
        final String? nextCursor = data['nextCursor'] as String?;
        final hasMore = orders.length == pageSize && nextCursor != null;

        emit(OrdersLoaded(
          orders: orders,
          timeFilter: time,
          statusFilter: status,
          nextCursor: nextCursor,
          hasMore: hasMore,
          loadingMore: false,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! OrdersLoaded || currentState.loadingMore || !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(loadingMore: true));

    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(const OrdersError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    String? statusString;
    if (currentState.statusFilter != null) {
      if (currentState.statusFilter == OrderStatus.onTheWay) {
        statusString = 'on-the-way';
      } else {
        statusString = currentState.statusFilter!.name;
      }
    }

    final result = await getOrdersUseCase(
      token: token,
      limit: pageSize,
      time: currentState.timeFilter,
      status: statusString,
      cursor: currentState.nextCursor,
      offset: 0, // offset is not used when cursor is present
    );

    result.fold(
      (failure) {
        // Stop loading more on failure, keep existing state
        emit(currentState.copyWith(loadingMore: false));
      },
      (data) {
        final List<OrderEntity> newOrders = List<OrderEntity>.from(data['orders']);
        final String? nextCursor = data['nextCursor'] as String?;
        final hasMore = newOrders.length == pageSize && nextCursor != null;

        emit(OrdersLoaded(
          orders: [...currentState.orders, ...newOrders],
          timeFilter: currentState.timeFilter,
          statusFilter: currentState.statusFilter,
          nextCursor: nextCursor,
          hasMore: hasMore,
          loadingMore: false,
        ));
      },
    );
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final token = await authRepo.getIdToken();
    if (token == null) {
      emit(const OrdersError(message: 'Authentication failed. Please sign in again.'));
      return;
    }

    String statusString;
    if (status == OrderStatus.onTheWay) {
      statusString = 'on-the-way';
    } else {
      statusString = status.name;
    }

    final result = await updateOrderStatusUseCase(
      token: token,
      orderId: orderId,
      status: statusString,
    );

    await result.fold(
      (failure) async {
        // Emit error state briefly or keep existing loaded state and show error dialog in UI
        // In our case, we will reload orders to ensure UI matches server state
        await loadOrders();
      },
      (_) async {
        // Upon success, refresh the list like the Angular app does
        await loadOrders();
      },
    );
  }
}
