import 'package:eat2beat/features/admin/presentation/view/orders/widgets/order_widgets.dart';
import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_state.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().loadOrders(timeFilter: 'today', clearStatusFilter: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                children: [
                  const Text(
                    'Restaurant Orders',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: kTextMain,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage and track incoming orders in real-time',
                    style: TextStyle(
                      fontSize: 12,
                      color: kTextSub,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Filters row
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      String activeTime = 'today';
                      OrderStatus? activeStatus;
                      if (state is OrdersLoaded) {
                        activeTime = state.timeFilter;
                        activeStatus = state.statusFilter;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time buttons
                          Row(
                            children: [
                              _buildTimeBtn(context, 'today', 'Today', activeTime),
                              const SizedBox(width: 6),
                              _buildTimeBtn(context, 'week', 'This Week', activeTime),
                              const SizedBox(width: 6),
                              _buildTimeBtn(context, 'all', 'All Time', activeTime),
                            ],
                          ),
                          // Status dropdown
                          _buildStatusDropdown(context, activeStatus),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),

            // ── Orders list
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kAccent),
                    );
                  }

                  if (state is OrdersError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: kRed, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: kTextMain,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<OrdersCubit>().loadOrders(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Retry', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is OrdersLoaded) {
                    final orders = state.orders;

                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              size: 48,
                              color: kTextSub.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No orders yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: kTextMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'When customers order meals, they will appear here.',
                              style: TextStyle(fontSize: 12, color: kTextSub),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => context.read<OrdersCubit>().loadOrders(),
                      color: kAccent,
                      backgroundColor: kSurface2,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: orders.length + (state.loadingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == orders.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: CircularProgressIndicator(color: kAccent),
                              ),
                            );
                          }
                          return OrderCard(order: orders[i]);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBtn(BuildContext context, String value, String label, String active) {
    final isSelected = value == active;
    return GestureDetector(
      onTap: () => context.read<OrdersCubit>().loadOrders(timeFilter: value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kAccent.withValues(alpha: 0.12) : Colors.transparent,
          border: Border.all(
            color: isSelected ? kAccent : Colors.white.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? kAccent : kTextSub,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, OrderStatus? activeStatus) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: kSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrderStatus?>(
          value: activeStatus,
          dropdownColor: kSurface2,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: activeStatus != null ? kAccent : kTextSub,
            size: 18,
          ),
          style: TextStyle(
            color: activeStatus != null ? kAccent : kTextMain,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (status) {
            context.read<OrdersCubit>().loadOrders(
              statusFilter: status,
              clearStatusFilter: status == null,
            );
          },
          items: [
            const DropdownMenuItem<OrderStatus?>(
              value: null,
              child: Text('All Status', style: TextStyle(color: kTextMain)),
            ),
            ...OrderStatus.values.map(
              (s) => DropdownMenuItem<OrderStatus?>(
                value: s,
                child: Text(
                  s.label,
                  style: TextStyle(
                    color: activeStatus == s ? kAccent : kTextMain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}