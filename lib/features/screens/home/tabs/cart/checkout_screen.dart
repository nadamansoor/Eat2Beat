import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/core/widgets/custom_text_field.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryCharges;
  final double total;
  final String deliveryAddress; 

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.deliveryCharges,
    required this.total,
    this.deliveryAddress = "Home",
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _areaController;

  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;

  int _selectedPaymentMethod = 0; // 0 for Cash, 1 for Card
  bool _isProcessing = false;
  bool _showSuccess = false;
  String _orderId = '';

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    final profile = UserProfileNotifier();
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController();
    _cityController = TextEditingController(text: "Cairo");
    _areaController = TextEditingController();

    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).fillDeliveryDetails),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).loginToPlaceOrder),
        ),
      );
      return;
    }

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final response = await apiService.checkoutCart(
          token,
          address: _addressController.text,
          area: _areaController.text,
          name: _nameController.text,
          phone: _phoneController.text,
        );

        if (!mounted) return;

        // Success state
        final orderId = response['order_id'] ?? '';
        setState(() {
          _isProcessing = false;
          _orderId = orderId.isNotEmpty ? orderId : 'E2B-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';
          _showSuccess = true;
        });

        // Clear local cart if possible on backend clearCart endpoint
        try {
          await apiService.clearCart(token);
        } catch (_) {
          // Ignore cart clear issues
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(S.of(context).orderFailed),
          content: Text(S.of(context).failedPlaceOrder(e.toString())),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.light,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  ThemeNotifier().isDarkMode ? Assets.imagesPattern : Assets.imagesPatternCart,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              
              SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        circleIcon(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(width: screenWidth * 0.20),
                        Text(
                          S.of(context).checkout,
                          style: AppStyles.black24Bold,
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Expanded(
                      child: ListView(
                        children: [
                          _buildDeliveryDetailsCard(),
                          SizedBox(height: screenHeight * 0.025),
                          _buildPaymentMethodCard(),
                          SizedBox(height: screenHeight * 0.025),
                          _buildOrderSummaryCard(),
                          SizedBox(height: screenHeight * 0.025),
                          _buildTotalCard(),
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      text: _selectedPaymentMethod == 0 ? S.of(context).placeOrderCash : S.of(context).placeOrderCard,
                      backgroundColor: AppColors.white,
                      textColor: ThemeNotifier().isDarkMode ? Colors.white : AppColors.purple,
                      isLoading: _isProcessing,
                      onPressed: _placeOrder,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
          if (_showSuccess)
            Positioned.fill(
              child: SuccessOverlay(
                orderId: _orderId,
                onGoHome: () {
                  // Navigate home
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    AppRoutes.homeRouteName, 
                    (route) => false
                  );
                },
              ),
            ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildDeliveryDetailsCard() {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                size: 20,
                color: AppColors.purple,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                S.of(context).deliveryDetails,
                style: AppStyles.black13Bold,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          
          Text(S.of(context).fullName, style: AppStyles.grey13w400),
          SizedBox(height: screenHeight * 0.005),
          CustomTextFormField(
            hintText: S.of(context).enterName,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).enterName;
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.015),

          Text(S.of(context).phoneNumber, style: AppStyles.grey13w400),
          SizedBox(height: screenHeight * 0.005),
          CustomTextFormField(
            hintText: S.of(context).enterPhoneNumber,
            controller: _phoneController,
            keyBoardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).pleaseEnterPhone;
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.015),

          Text(S.of(context).deliveryAddress, style: AppStyles.grey13w400),
          SizedBox(height: screenHeight * 0.005),
          CustomTextFormField(
            hintText: S.of(context).addressPlaceholder,
            controller: _addressController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).pleaseEnterAddress;
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.015),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).city, style: AppStyles.grey13w400),
                    SizedBox(height: screenHeight * 0.005),
                    CustomTextFormField(
                      hintText: Localizations.localeOf(context).languageCode == 'ar' ? "القاهرة" : "Cairo",
                      controller: _cityController,
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).area, style: AppStyles.grey13w400),
                    SizedBox(height: screenHeight * 0.005),
                    CustomTextFormField(
                      hintText: Localizations.localeOf(context).languageCode == 'ar' ? "المعادي" : "Maadi",
                      controller: _areaController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_outlined,
                size: 20,
                color: AppColors.purple,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                S.of(context).paymentMethod,
                style: AppStyles.black13Bold,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          
          Row(
            children: [
              Expanded(
                child: _buildPaymentOption(
                  title: S.of(context).cash,
                  isSelected: _selectedPaymentMethod == 0,
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 0;
                    });
                  },
                  icon: Icons.money,
                  iconColor: Colors.green,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: _buildPaymentOption(
                  title: S.of(context).card,
                  isSelected: _selectedPaymentMethod == 1,
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 1;
                    });
                  },
                  icon: Icons.credit_card,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
          
          if (_selectedPaymentMethod == 1) ...[
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).cardNumber, style: AppStyles.grey13w400),
                  SizedBox(height: screenHeight * 0.005),
                  CustomTextFormField(
                    hintText: "0000 0000 0000 0000",
                    controller: _cardNumberController,
                    keyBoardType: TextInputType.number,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).expiry, style: AppStyles.grey13w400),
                            SizedBox(height: screenHeight * 0.005),
                            CustomTextFormField(
                              hintText: "MM/YY",
                              controller: _expiryDateController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).cvv, style: AppStyles.grey13w400),
                            SizedBox(height: screenHeight * 0.005),
                            CustomTextFormField(
                              hintText: "123",
                              controller: _cvvController,
                              obscureText: true,
                              keyBoardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withOpacity(0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.grey800,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.purple : iconColor, size: 28),
            SizedBox(height: screenHeight * 0.008),
            Text(
              title,
              style: isSelected ? AppStyles.purple.copyWith(fontWeight: FontWeight.bold) : AppStyles.black13Bold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderSummary,
            style: AppStyles.black13Bold,
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).subtotal, style: AppStyles.grey13w400),
              Text("\$${widget.subtotal.toStringAsFixed(2)}", style: AppStyles.black13Bold),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).deliveryCharges, style: AppStyles.grey13w400),
              Text("\$${widget.deliveryCharges.toStringAsFixed(2)}", style: AppStyles.black13Bold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).total,
            style: AppStyles.black16Bold,
          ),
          Text(
            "\$${widget.total.toStringAsFixed(2)}",
            style: AppStyles.black24Bold.copyWith(color: AppColors.purple),
          ),
        ],
      ),
    );
  }
}

class SuccessOverlay extends StatefulWidget {
  final String orderId;
  final VoidCallback onGoHome;

  const SuccessOverlay({super.key, required this.orderId, required this.onGoHome});

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _driveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _driveAnimation = Tween<double>(begin: -150.0, end: 150.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xff2ecc71).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Color(0xff2ecc71),
                        size: 48,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _driveAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_driveAnimation.value, 40),
                        child: const Icon(
                          Icons.local_shipping,
                          color: Color(0xffFFC833),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).thankYou,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).orderOnTheWay(widget.orderId),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).driverOnTheWay,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onGoHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.of(context).trackOrder,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}