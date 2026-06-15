import 'package:eat2beat/core/services/theme_notifier.dart';
import 'dart:ui';
import 'package:eat2beat/features/models/offers_model.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OfferDetailsScreen extends StatefulWidget {
  final FoodModel item;

  const OfferDetailsScreen({super.key, required this.item});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  int quantity = 1;

  Future<void> _addToCart({bool navigateToCheckout = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Navigator.pushNamed(context, AppRoutes.loginRouteName);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return;
    }

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
        final cart = await apiService.getCart(token);
        int currentQty = 0;
        for (final row in cart) {
          final rowOfferId = row['offer_id']?.toString() ?? '';
          final rowMealId = row['meal_id']?.toString() ?? '';
          if (widget.item.isOffer) {
            if (rowOfferId == widget.item.id) {
              currentQty = row['quantity'] is int 
                  ? row['quantity'] 
                  : int.tryParse(row['quantity']?.toString() ?? '') ?? 0;
              break;
            }
          } else {
            if (rowMealId == widget.item.id) {
              currentQty = row['quantity'] is int 
                  ? row['quantity'] 
                  : int.tryParse(row['quantity']?.toString() ?? '') ?? 0;
              break;
            }
          }
        }
        final targetQty = currentQty + quantity;
        await apiService.setCartItem(token, widget.item.id, targetQty, isOffer: widget.item.isOffer);

        if (!mounted) return;

        Navigator.pop(context); // Pop loading dialog

        if (navigateToCheckout) {
          final double subtotal = widget.item.price * targetQty;
          final double deliveryCharges = 3.99;
          final double total = subtotal + deliveryCharges;

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
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added to Cart (Qty: $quantity)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: ThemeNotifier().isDarkMode ? const Color(0xff1A1A1A) : const Color(0xffF7F7F7),
          body: SizedBox.expand(
            child: Stack(
              children: [
                /// IMAGE
                SizedBox(
                  height: 340,
                  width: double.infinity,
                  child: item.image.startsWith('http')
                      ? Image.network(item.image, fit: BoxFit.cover)
                      : Image.asset(item.image, fit: BoxFit.cover),
                ),

                /// BACK
                Positioned(
                  top: 50,
                  left: 20,
                  child: circleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                /// CONTENT
                Positioned(
                  top: 260,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME + SALE
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  item.sale,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Res name + Icon(not working) + view
                          Row(
                            children: [
                              /// ICON
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.orange,
                                child: widget.item.restauranteIcon.startsWith('http')
                                    ? ClipOval(
                                        child: Image.network(
                                          widget.item.restauranteIcon,
                                          fit: BoxFit.cover,
                                          width: 28,
                                          height: 28,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.restaurant, size: 16, color: Colors.white),
                                        ),
                                      )
                                    : Image.asset(widget.item.restauranteIcon),
                              ),

                              const SizedBox(width: 8),

                              /// RESTAURANT NAME
                              Text(
                                widget.item.restruanteName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),

                              const SizedBox(width: 8),

                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'View',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          /// RATE + PRICE + TIME
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.rate.toString(),
                                style: TextStyle(color: AppColors.grey800),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '\$ ${item.price}',
                                style: TextStyle(color: AppColors.grey800),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: AppColors.grey800,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.time,
                                style: TextStyle(color: AppColors.grey800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Size',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      175,
                                      216,
                                      153,
                                      252,
                                    ), // Border color
                                    width: 2, // Border width
                                  ),
                                  color: const Color.fromARGB(255, 187, 166, 221),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  'L',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          /// INGREDIENTS
                          Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            item.description,
                            style: TextStyle(color: AppColors.grey800),
                          ),
                          const SizedBox(height: 180),
                        ],
                      ),
                    ),
                  ),
                ),

                /// BOTTOM BAR
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.35),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// TOP ROW (PRICE + QUANTITY)
                              Row(
                                children: [
                                  /// PRICE - LEFT
                                  Text(
                                    '\$ ${item.price * quantity}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const Spacer(),

                                  /// QUANTITY BOX - RIGHT
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        qtyButton(
                                          icon: Icons.remove,
                                          onTap: () {
                                            if (quantity > 1) {
                                              setState(() => quantity--);
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        qtyButton(
                                          icon: Icons.add,
                                          onTap: () {
                                            setState(() => quantity++);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              /// BOTTOM BUTTONS
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: ThemeNotifier().isDarkMode ? const Color(0xff45337D) : Colors.white,
                                        side: BorderSide(
                                          color: ThemeNotifier().isDarkMode ? Colors.transparent : Colors.deepPurple,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () => _addToCart(navigateToCheckout: false),
                                      child: Text(
                                        'Add To Cart',
                                        style: TextStyle(
                                          color: ThemeNotifier().isDarkMode ? Colors.white : Colors.deepPurpleAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeNotifier().isDarkMode ? AppColors.purple800 : AppColors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () => _addToCart(navigateToCheckout: true),
                                      child: const Text(
                                        'Order Now',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
