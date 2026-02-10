import 'package:eat2beat/screens/home/tabs/cart/order_confirmation_screen.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
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
    this.deliveryAddress = "Home ",
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedPaymentMethod = 0;
  late double screenWidth;
  late double screenHeight;

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
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
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
                        "Checkout",
                        style: AppStyles.black24Bold,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

            
                  Expanded(
                    child: ListView(
                      children: [
        
                        _buildSection(
                          title: "Deliver to",
                          content: widget.deliveryAddress,
                          icon: Icons.location_on_outlined,
                        ),

                        SizedBox(height: screenHeight * 0.02),

            
                        _buildPaymentSection(),

                        SizedBox(height: screenHeight * 0.02),

                        SizedBox(height: screenHeight * 0.02),

                     
                        _buildOrderSummary(),

                        SizedBox(height: screenHeight * 0.02),


                        SizedBox(height: screenHeight * 0.02),

             
                        _buildTotalSection(),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

    
                  _buildPlaceOrderButton(),
                  
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSection({
    required String title,
    required String content,
    IconData? icon,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.grey,
                ),
              
              if (icon != null) SizedBox(width: screenWidth * 0.02),
              
              Text(
                title,
                style: AppStyles.black13Bold,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),

       
          Text(
            content,
            style: AppStyles.grey13w400,
          ),
        ],
      ),
    );
  }


  Widget _buildPaymentSection() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 20,
                color: AppColors.grey,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                "Payment from",
                style: AppStyles.black13Bold,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),

    
          _buildPaymentOption(
            title: "Mastercard - Daniel Jones",
            isSelected: selectedPaymentMethod == 0,
            onTap: () {
              setState(() {
                selectedPaymentMethod = 0;
              });
            },
            icon: Icons.credit_card,
            iconColor: Colors.orange,
          ),

          SizedBox(height: screenHeight * 0.01),

     
          _buildPaymentOption(
            title: "Cash",
            isSelected: selectedPaymentMethod == 1,
            onTap: () {
              setState(() {
                selectedPaymentMethod = 1;
              });
            },
            icon: Icons.money,
            iconColor: Colors.green,
          ),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.grey800,
            width: 1,
          ),
        ),
        child: Row(
          children: [
        
            Container(
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

    
            Expanded(
              child: Text(
                title,
                style: isSelected
                    ? AppStyles.purple
                    : AppStyles.black13Bold,
              ),
            ),


            Container(
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.purple : AppColors.grey,
                  width: 2,
                ),
                color: isSelected ? AppColors.purple : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildOrderSummary() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Text(
            "Subtotal",
            style: AppStyles.black13Bold,
          ),

          SizedBox(height: screenHeight * 0.01),

      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${widget.subtotal.toStringAsFixed(2)}",
                style: AppStyles.black16Bold,
              ),
              
            
              Text(
                "Delivery Charges + \$${widget.deliveryCharges.toStringAsFixed(2)}",
                style: AppStyles.grey13w400,
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTotalSection() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     
          Text(
            "Total",
            style: AppStyles.black13Bold,
          ),

          SizedBox(height: screenHeight * 0.01),

        
          Text(
            "\$${widget.total.toStringAsFixed(2)}",
            style: AppStyles.black24Bold,
          ),
        ],
      ),
    );
  }

 
  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: () {

          _placeOrder();
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
          "Place order",
          style: AppStyles.white16Bold,
        ),
      ),
    );
  }


  void _placeOrder() {

    String orderId = "ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: AppColors.purple,
        ),
      ),
    );

  
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); 
      
     
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            deliveryAddress: widget.deliveryAddress,
            totalAmount: widget.total,
            orderId: orderId,
         
          ),
        ),
      );
    });
  }
}