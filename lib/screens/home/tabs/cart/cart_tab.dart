import 'package:eat2beat/data/dummy_offer_data.dart';
import 'package:eat2beat/models/offers_model.dart';
import 'package:eat2beat/screens/home/tabs/cart/checkout_screen.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
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

  double get subtotal {
    return foodList.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryCharges => 3.99;

  double get total => subtotal + deliveryCharges;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Image.asset(
              AppImages.PatternCart,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              //  vertical: screenHeight * 0.0001,
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///Back button
                      circleIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      SizedBox(width: screenWidth * 0.20),
                      //Cart icon
                      Image.asset(
                        AppImages.carrtIcon,
                        color: AppColors.black,
                        height: 24,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      //Cart text
                      Text(
                        "Cart",
                        style: AppStyles.black24Bold,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                 
                  Expanded(
                    child: ListView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final item = foodList[index];
                        return _buildCartItem(item, index);
                      },
                    ),
                  ),

                 
                  _buildCouponSection(),

                  SizedBox(height: screenHeight * 0.02),

              
                  _buildOrderSummary(),

                  SizedBox(height: screenHeight * 0.02),

                
                  _buildProceedButton(),
                  
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//display items => Edited API
  Widget _buildCartItem(FoodModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
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
      child: Row(
        children: [
         
          Container(
            width: screenWidth * 0.18,
            height: screenWidth * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(item.image), 
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
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.grey800, width: 1),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove, size: 16),
                    onPressed: () {
                      _updateQuantity(index, item.quantity - 1);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
                
               
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: AppStyles.blue14w500,
                  ),
                ),
                
               
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.grey, width: 1),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 16),
                    onPressed: () {
                      _updateQuantity(index, item.quantity + 1);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        foodList[index].quantity = newQuantity ;
      } else {
    
        foodList.removeAt(index);
      }
    });
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
        
        Icon(
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
          onTap: () {
            
          },
          child: Icon(
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
          Divider(color: AppColors.grey, height: 1),
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
      onPressed: () {
 
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
        "Proceed to pay",
        style: AppStyles.white16Bold,
      ),
    ),
  );
}
}