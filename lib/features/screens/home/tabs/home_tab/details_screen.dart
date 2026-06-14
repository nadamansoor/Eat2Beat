import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../models/home_model.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/leading_widget.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;
  late HomeFoodModel model;

  Future<void> _addToCart({bool navigateToCheckout = false}) async {
    if (!model.isCurrentlyOpen) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'The restaurant is currently closed, please try again later',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (model.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This mock meal cannot be ordered',
          ),
        ),
      );
      return;
    }

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
          if (row['meal_id'] == model.id) {
            currentQty = row['quantity'] is int 
                ? row['quantity'] 
                : int.tryParse(row['quantity']?.toString() ?? '') ?? 0;
            break;
          }
        }
        final targetQty = currentQty + quantity;
        await apiService.setCartItem(token, model.id!, targetQty);

        if (!mounted) return;

        Navigator.pop(context); // Pop loading dialog

        if (navigateToCheckout) {
          final double subtotal = model.price * targetQty;
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

  Widget _buildImage(String imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.imagesFood,
            width: width,
            height: height,
            fit: fit,
          );
        },
      );
    } else {
      final path = imagePath.trim().isEmpty ? Assets.imagesFood : imagePath.trim();
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.imagesFood,
            width: width,
            height: height,
            fit: fit,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 375
    double screenHeight = MediaQuery.of(context).size.height; // 812

    model = ModalRoute.of(context)?.settings.arguments as HomeFoodModel;
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _buildImage(
                      model.image,
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.08,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LeadingWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.title, style: AppStyles.black20Bold),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _buildImage(
                              model.restIcon,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02,),
                          Text(model.restName, style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.02,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: model.isCurrentlyOpen
                                  ? const Color(0x1F10B981)
                                  : const Color(0x1FEF4444),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              model.isCurrentlyOpen ? 'open' : 'closed',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: model.isCurrentlyOpen
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(Assets.imagesRateIcon ,width: 20, height: 20,),
                          SizedBox(width: screenWidth * 0.01,),
                          Text("${model.rate}" , style: AppStyles.grey16w400,),
                          SizedBox(width: screenWidth * 0.06,),
                          Image.asset(Assets.imagesDotIcon, color: AppColors.grey,),
                          SizedBox(width: screenWidth * 0.06,),
                          Text("\$ ${model.price}", style: AppStyles.grey16w400,),
                          SizedBox(width: screenWidth * 0.06,),
                          Image.asset(Assets.imagesDotIcon, color: AppColors.grey,),
                          SizedBox(width: screenWidth * 0.06,),
                          Icon(Icons.watch_later_outlined ,
                            color: AppColors.grey,
                            size: 20,
                          ),
                          SizedBox(width: screenWidth * 0.01,),
                          Text(model.time, style: AppStyles.grey16w400,),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: [
                          Text("Size ", style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.01,),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.085,
                            height: screenHeight*0.044,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.purple50,
                              borderRadius: BorderRadius.circular(110),
                            ),
                            child: Text(model.size , style: AppStyles.black16w500,),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text("Ingredients", style: AppStyles.black16Bold,),
                      SizedBox(height: screenHeight * 0.01),
                      Text(model.description, style: AppStyles.grey13w400,),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Some Place", style: AppStyles.black16Bold,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02
          ),
          decoration: BoxDecoration(
            color: Color(0xd9c4b2fc),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("\$ ${model.price * quantity}" , style: AppStyles.white25Bold,),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth*0.03,
                      vertical: screenHeight * 0.015
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x1a1b1432),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            if(quantity > 1){
                              quantity--;
                            }
                            setState(() {

                            });
                          },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0x33f9f7ff),
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.remove, color: Colors.white,))),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,

                          ),
                          child: Text("$quantity", style: AppStyles.white16Bold,),
                        ),
                        InkWell(
                            onTap: (){

                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0x33f9f7ff),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.add, color: Colors.white,))),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02,),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        text: "Add To Cart",
                        backgroundColor: ThemeNotifier().isDarkMode ? const Color(0xff45337D) : AppColors.lightPurple,
                        textColor: ThemeNotifier().isDarkMode ? Colors.white : AppColors.purple,
                        onPressed: () => _addToCart(navigateToCheckout: false),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.06,),

                  Expanded(
                    child: CustomButton(
                        text: "Order Now",
                        backgroundColor: ThemeNotifier().isDarkMode ? AppColors.purple800 : AppColors.purple,
                        onPressed: () => _addToCart(navigateToCheckout: true),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
