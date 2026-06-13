import 'package:eat2beat/features/models/offers_model.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/checkout_screen.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int selectedIndex = 0;
  late double screenWidth;
  late double screenHeight;

  List<FoodModel> cartItems = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        cartItems = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final rows = await apiService.getCart(token);
        
        final List<FoodModel> items = [];
        for (final row in rows) {
          final mealId = row['meal_id'] ?? '';
          final quantity = row['quantity'] is int 
              ? row['quantity'] 
              : int.tryParse(row['quantity']?.toString() ?? '') ?? 1;
          final unitPrice = row['unit_price'] is num 
              ? (row['unit_price'] as num).toDouble() 
              : double.tryParse(row['unit_price']?.toString() ?? '') ?? 0.0;
          final mealTitle = row['meal_title'] ?? 'Meal';
          final mealImg = row['meal_img_url'] ?? Assets.imagesFood2;
          final category = row['category'] ?? 'Food';

          items.add(FoodModel(
            id: mealId,
            name: mealTitle,
            image: mealImg.toString(),
            price: unitPrice,
            sale: '10% OFF',
            rate: 4.5,
            time: '20 Min',
            quantity: quantity,
            description: category,
            size: 'L',
            restruanteName: 'Restaurant',
            restauranteIcon: Assets.imagesBurgerKing,
          ));
        }

        setState(() {
          cartItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _updateCartItemQuantity(FoodModel item, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        if (newQuantity > 0) {
          await apiService.setCartItem(token, item.id, newQuantity);
        } else {
          await apiService.removeCartItem(token, item.id);
        }
        await _loadCart();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryCharges => cartItems.isEmpty ? 0.0 : 3.99;

  double get total => subtotal + deliveryCharges;

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    return AssetImage(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Image.asset(
              Assets.imagesPatternCart,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesCarrtIcon,
                        color: AppColors.black,
                        height: 24,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "Cart",
                        style: AppStyles.black24Bold,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  if (user == null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Please login to view your cart",
                              style: AppStyles.black16Bold,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.loginRouteName).then((_) => _loadCart());
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
                  else if (isLoading && cartItems.isEmpty)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.purple),
                      ),
                    )
                  else if (cartItems.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Your cart is empty",
                              style: AppStyles.black16Bold,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadCart,
                        color: AppColors.purple,
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _buildCartItem(item, index);
                          },
                        ),
                      ),
                    ),

                  if (cartItems.isNotEmpty) ...[
                    _buildCouponSection(),
                    SizedBox(height: screenHeight * 0.02),
                    _buildOrderSummary(),
                    SizedBox(height: screenHeight * 0.02),
                  ],

                  _buildProceedButton(),
                   
                  SafeArea(
                    top: false,
                    child: SizedBox(height: screenHeight * 0.14),
                  ),
                ],
              ),
            ),
            if (isLoading && cartItems.isNotEmpty)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.purple),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(FoodModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.02,
        top: screenWidth * 0.04,
        bottom: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.18,
            height: screenWidth * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: _getImageProvider(item.image), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: screenWidth * 0.04),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name, 
                  style: AppStyles.black13Bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '\$${item.price.toStringAsFixed(2)}', 
                  style: AppStyles.grey13w400,
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey800, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.085,
                  height: screenWidth * 0.085,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.grey800, width: 1),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, size: 14),
                    onPressed: () {
                      _updateCartItemQuantity(item, item.quantity - 1);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
                
                Container(
                  width: screenWidth * 0.085,
                  height: screenWidth * 0.085,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: AppStyles.blue14w500,
                  ),
                ),
                
                Container(
                  width: screenWidth * 0.085,
                  height: screenWidth * 0.085,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.grey, width: 1),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 14),
                    onPressed: () {
                      _updateCartItemQuantity(item, item.quantity + 1);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.015),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            onPressed: () {
              _updateCartItemQuantity(item, 0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.discount_outlined,
            size: 24,
            color: AppColors.grey,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Add a coupon",
                hintStyle: AppStyles.grey13w400,
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", subtotal),
          SizedBox(height: screenHeight * 0.01),
          _buildSummaryRow("Delivery Charges", deliveryCharges),
          SizedBox(height: screenHeight * 0.01),
          const Divider(color: AppColors.grey, height: 1),
          SizedBox(height: screenHeight * 0.01),
          _buildTotalRow("Total", total),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.black13Bold,
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: AppStyles.black13Bold,
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.black13Bold,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${subtotal.toStringAsFixed(2)} + \$${deliveryCharges.toStringAsFixed(2)}',
              style: AppStyles.grey13w400,
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: AppStyles.grey13w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Login Required'),
                content: const Text(
                  'Please login first to complete your order.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.loginRouteName).then((_) => _loadCart());
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
            return;
          }

          if (cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your cart is empty')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                subtotal: subtotal,
                deliveryCharges: deliveryCharges,
                total: total,
                deliveryAddress: "Home", 
              ),
            ),
          ).then((_) => _loadCart());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          "Order Now",
          style: AppStyles.white16Bold,
        ),
      ),
    );
  }
}