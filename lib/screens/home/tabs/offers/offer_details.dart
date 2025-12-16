import 'dart:ui';

import 'package:eat2beat/models/offers_model.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class OfferDetailsScreen extends StatefulWidget {
  final FoodModel item;

  
  const OfferDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  int quantity = 1;


  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// IMAGE
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
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
            /// CART
            Positioned(
              top: 50,
              right: 20,
              child: circleIcon(icon: Icons.shopping_cart),
            ),
        
            /// CONTENT
            Positioned(
              top: 260,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
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
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
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
                            child: Image.asset(
                              widget.item.restauranteIcon,
                              ),
                          ),

                          const SizedBox(width: 8),

                          /// RESTAURANT NAME
                          Text(
                            widget.item.restruanteName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                        
                          GestureDetector(
                            onTap: () { },
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
                      const SizedBox(height: 20,),
                      /// RATE + PRICE + TIME
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          Text(item.rate.toString()),
                          const SizedBox(width: 12),
                          Text('\$ ${item.price}'),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 4),
                          Text(item.time),
                        ],
                      ),        
                      const SizedBox(height: 20),
                      Row(
                          children: [
                            const Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            const SizedBox(width: 12),

                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                               border: Border.all(
                                      color: const Color.fromARGB(175, 216, 153, 252), // لون الحواف
                                      width: 2, // سمك الحافة
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
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        item.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.deepPurple),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Add To Cart',
                                  style: TextStyle(color: Colors.deepPurpleAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  
                                  backgroundColor: Color(0x8966FA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {},
                                child: const Text('Order Now',
                                style: TextStyle(color: Colors.white),),
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
  }
          Widget qtyButton({
            required IconData icon,
            required VoidCallback onTap,
          }) {
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
