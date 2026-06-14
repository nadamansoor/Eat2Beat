import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryTab extends StatefulWidget {
  final Function(int)? onSwitchTab;

  const OrderHistoryTab({super.key, this.onSwitchTab});

  @override
  State<OrderHistoryTab> createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends State<OrderHistoryTab> {
  final ScrollController _scrollController = ScrollController();
  
  List<dynamic> _orders = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  String? _nextCursor;
  
  String _timeFilter = 'all'; // all, today, week
  String _statusFilter = '';  // empty for all, or pending, preparing, on-the-way, delivered, cancelled

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
      _orders = [];
      _nextCursor = null;
      _hasMore = true;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final response = await apiService.getUserOrderHistoryPage(
          token,
          limit: 10,
          time: _timeFilter,
          status: _statusFilter,
        );

        final rows = response['rows'] as List<dynamic>? ?? [];
        final nextCursor = response['nextCursor'] as String?;

        if (mounted) {
          setState(() {
            _orders = rows;
            _nextCursor = nextCursor;
            _hasMore = rows.length == 10 && nextCursor != null;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load order history: $e')),
      );
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isMoreLoading) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isMoreLoading = true;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final response = await apiService.getUserOrderHistoryPage(
          token,
          limit: 10,
          cursor: _nextCursor,
          time: _timeFilter,
          status: _statusFilter,
        );

        final rows = response['rows'] as List<dynamic>? ?? [];
        final nextCursor = response['nextCursor'] as String?;

        if (mounted) {
          setState(() {
            _orders.addAll(rows);
            _nextCursor = nextCursor;
            _hasMore = rows.length == 10 && nextCursor != null;
            _isMoreLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isMoreLoading = false;
        });
      }
    }
  }

  Future<void> _reorder(dynamic order) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.purple),
      ),
    );

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        
        // Clear current cart first
        await apiService.clearCart(token);
        
        // Add each item from old order back into the cart sequentially
        final items = order['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final mealId = item['meal_id'] ?? item['id'] ?? '';
          final quantity = item['quantity'] is int 
              ? item['quantity'] 
              : int.tryParse(item['quantity']?.toString() ?? '') ?? 1;
          
          if (mealId.isNotEmpty) {
            await apiService.setCartItem(token, mealId, quantity);
          }
        }
        
        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reordered successfully! Redirecting to Cart...')),
        );
        
        widget.onSwitchTab?.call(4); // Switch to Cart tab
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reorder: $e')),
      );
    }
  }

  double _calculateOrderTotal(List<dynamic> items) {
    double total = 0;
    for (final item in items) {
      final quantity = item['quantity'] is int 
          ? item['quantity'] 
          : int.tryParse(item['quantity']?.toString() ?? '') ?? 1;
      final unitPrice = item['unit_price'] is num 
          ? (item['unit_price'] as num).toDouble() 
          : double.tryParse(item['unit_price']?.toString() ?? '') ?? 0.0;
      total += unitPrice * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final user = FirebaseAuth.instance.currentUser;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.light,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ThemeNotifier().isDarkMode ? Assets.imagesPattern : Assets.imagesPatternCart,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: AppColors.black,
                        size: 26,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "Order History",
                        style: AppStyles.black24Bold,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),

                  _buildFiltersRow(),

                  SizedBox(height: screenHeight * 0.02),

                  if (user == null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history_toggle_off,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Login required to view history",
                              style: AppStyles.black16Bold,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.loginRouteName).then((_) => _loadInitial());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                child: Text("Login"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.purple),
                      ),
                    )
                  else if (_orders.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No Orders Yet",
                              style: AppStyles.black16Bold,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Hungry? Explore our menu and place your first order!",
                              style: AppStyles.grey13w400,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                widget.onSwitchTab?.call(0); // Switch to Home
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                child: Text("Go to Menu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadInitial,
                        color: AppColors.purple,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _orders.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _orders.length) {
                              if (_isMoreLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(color: AppColors.purple),
                                  ),
                                );
                              } else if (!_hasMore && _orders.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      "All orders loaded",
                                      style: AppStyles.grey13w400,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            }

                            final order = _orders[index];
                            return _buildOrderCard(order);
                          },
                        ),
                      ),
                    ),
                  
                  SafeArea(
                    top: false,
                    child: SizedBox(height: screenHeight * 0.12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeNotifier().isDarkMode ? Colors.transparent : Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _timeFilter,
                isExpanded: true,
                style: AppStyles.black13Bold,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text("Time: All")),
                  DropdownMenuItem(value: 'today', child: Text("Today")),
                  DropdownMenuItem(value: 'week', child: Text("This Week")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _timeFilter = val;
                    });
                    _loadInitial();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeNotifier().isDarkMode ? Colors.transparent : Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                isExpanded: true,
                style: AppStyles.black13Bold,
                items: const [
                  DropdownMenuItem(value: '', child: Text("Status: All")),
                  DropdownMenuItem(value: 'pending', child: Text("Pending")),
                  DropdownMenuItem(value: 'preparing', child: Text("Preparing")),
                  DropdownMenuItem(value: 'on-the-way', child: Text("On the way")),
                  DropdownMenuItem(value: 'delivered', child: Text("Delivered")),
                  DropdownMenuItem(value: 'cancelled', child: Text("Cancelled")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _statusFilter = val;
                    });
                    _loadInitial();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(dynamic order) {
    final orderId = order['id']?.toString() ?? '';
    final shortId = orderId.isNotEmpty 
        ? (orderId.contains('-') ? orderId.split('-')[0] : orderId.substring(0, 8))
        : '';
    final status = order['status']?.toString() ?? 'pending';
    
    DateTime createdAt = DateTime.now();
    if (order['created_at'] != null) {
      createdAt = DateTime.tryParse(order['created_at'].toString())?.toLocal() ?? DateTime.now();
    }
    
    final items = order['items'] as List<dynamic>? ?? [];
    final double total = _calculateOrderTotal(items);

    Color statusBgColor = Colors.grey.shade100;
    Color statusTextColor = Colors.grey;

    switch (status.toLowerCase()) {
      case 'delivered':
        statusBgColor = const Color(0xff2ecc71).withOpacity(0.12);
        statusTextColor = const Color(0xff27ae60);
        break;
      case 'pending':
        statusBgColor = const Color(0xfff1c40f).withOpacity(0.12);
        statusTextColor = const Color(0xffd35400);
        break;
      case 'preparing':
        statusBgColor = AppColors.purple.withOpacity(0.12);
        statusTextColor = AppColors.purple;
        break;
      case 'on-the-way':
        statusBgColor = Colors.blue.withOpacity(0.12);
        statusTextColor = Colors.blue.shade700;
        break;
      case 'cancelled':
        statusBgColor = Colors.red.withOpacity(0.12);
        statusTextColor = Colors.red.shade700;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: #$shortId",
                style: AppStyles.black13Bold.copyWith(color: const Color(0xffFFC833)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.black12, height: 1),
          ),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map<Widget>((it) {
              final quantity = it['quantity'] is int 
                  ? it['quantity'] 
                  : int.tryParse(it['quantity']?.toString() ?? '') ?? 1;
              final mealTitle = it['meal_title'] ?? it['name'] ?? 'Meal';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeNotifier().isDarkMode ? const Color(0xff8966FA).withOpacity(0.15) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeNotifier().isDarkMode ? Colors.transparent : Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${quantity}x",
                      style: const TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mealTitle,
                      style: AppStyles.black13Bold.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(createdAt),
                        style: AppStyles.grey13w400.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: AppStyles.black16Bold,
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _reorder(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text(
                  "Reorder",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
