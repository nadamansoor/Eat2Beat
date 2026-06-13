import 'package:eat2beat/features/admin/presentation/view/orders/widgets/order_widgets.dart';
import 'package:eat2beat/features/admin/domain/entities/order_entity.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_state.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();
  String _activeTime = 'today';
  OrderStatus? _activeStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().loadOrders(
        timeFilter: 'today',
        clearStatusFilter: true,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          // ── Header (Light purple background to match Meals tab)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.purple50,
              border: Border(bottom: BorderSide(color: kBorder, width: 1)),
            ),
            padding: EdgeInsets.fromLTRB(20, statusBarHeight + 20, 20, 16),
            child: Column(
              children: [
                const Text(
                  'Restaurant Orders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage and track incoming orders in real-time',
                  style: TextStyle(fontSize: 12, color: kMuted),
                ),
                const SizedBox(height: 16),

                // ── Filters row
                BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoaded) {
                      _activeTime = state.timeFilter;
                      _activeStatus = state.statusFilter;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Time buttons
                        Row(
                          children: [
                            _buildTimeBtn(
                              context,
                              'today',
                              'Today',
                              _activeTime,
                            ),
                            const SizedBox(width: 6),
                            _buildTimeBtn(
                              context,
                              'week',
                              'This Week',
                              _activeTime,
                            ),
                            const SizedBox(width: 6),
                            _buildTimeBtn(
                              context,
                              'all',
                              'All Time',
                              _activeTime,
                            ),
                          ],
                        ),
                        // Status dropdown
                        _buildStatusDropdown(context, _activeStatus),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Orders list
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimary),
                  );
                }

                if (state is OrdersError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: kRed,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: kText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                () => context.read<OrdersCubit>().loadOrders(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
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
                            color: kMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No orders yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: kText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'When customers order meals, they will appear here.',
                            style: TextStyle(fontSize: 12, color: kMuted),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh:
                        () async => context.read<OrdersCubit>().loadOrders(),
                    color: kPrimary,
                    backgroundColor: kCard,
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
                              child: CircularProgressIndicator(color: kPrimary),
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
    );
  }

  Widget _buildTimeBtn(
    BuildContext context,
    String value,
    String label,
    String active,
  ) {
    final isSelected = value == active;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTime = value;
        });
        context.read<OrdersCubit>().loadOrders(timeFilter: value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? kPrimary.withValues(alpha: 0.12)
                  : Colors.transparent,
          border: Border.all(color: isSelected ? kPrimary : kBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? kPrimary : kMuted,
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
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrderStatus?>(
          value: activeStatus,
          dropdownColor: kCard,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: activeStatus != null ? kPrimary : kMuted,
            size: 18,
          ),
          style: TextStyle(
            color: activeStatus != null ? kPrimary : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (status) {
            setState(() {
              _activeStatus = status;
            });
            context.read<OrdersCubit>().loadOrders(
              statusFilter: status,
              clearStatusFilter: status == null,
            );
          },
          items: [
            const DropdownMenuItem<OrderStatus?>(
              value: null,
              child: Text('All Status', style: TextStyle(color: kText)),
            ),
            ...OrderStatus.values.map(
              (s) => DropdownMenuItem<OrderStatus?>(
                value: s,
                child: Text(
                  s.label,
                  style: TextStyle(color: activeStatus == s ? kPrimary : kText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
