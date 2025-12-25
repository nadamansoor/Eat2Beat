import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String deliveryAddress;
  final double totalAmount;
  final String orderId;
  final String paymentMethod; 

  const OrderConfirmationScreen({
    super.key,
    required this.deliveryAddress,
    required this.totalAmount,
    required this.orderId,
    this.paymentMethod = "Mastercard", 
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late double screenWidth;
  late double screenHeight;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    

    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;

  return SafeArea(
    child: Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.PatternCart,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                Expanded(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Image.asset(
                              AppImages.confirm,
                              width: screenWidth * 0.7,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          Text(
                            "Yay! Your order\nhas been placed.",
                            style: AppStyles.black24Bold.copyWith(
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 12),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.12,
                            ),
                            child: Text(
                              "Your order would be delivered in a 30 mins at most",
                              style: AppStyles.grey16Bold.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.05),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _infoRow(
                                  icon: Icons.access_time,
                                  title: "Estimated time",
                                  value: "30 mins",
                                ),
                                const SizedBox(height: 16),
                                _infoRow(
                                  icon: Icons.location_on_outlined,
                                  title: "Deliver to",
                                  value: widget.deliveryAddress,
                                ),
                                const SizedBox(height: 16),
                                _infoRow(
                                  icon: Icons.credit_card,
                                  title: "Amount Paid",
                                  value: "\$${widget.totalAmount.toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _infoRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Row(
    children: [
      Icon(icon, color: Colors.grey),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          title,
          style: AppStyles.grey16Bold.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Text(
        value,
        style: AppStyles.black16Bold,
      ),
    ],
  );
}

    }