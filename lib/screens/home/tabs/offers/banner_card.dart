import 'package:eat2beat/models/banner_model.dart';
import 'package:flutter/material.dart';

class BannerItem extends StatelessWidget {
  final BannerModel banner;

  const BannerItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E1FF), 
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            /// LEFT SIDE (TEXT)
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6), // 👈 مسافة من جوه الكونتينر
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B2B2B),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B61FF),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Buy now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// RIGHT SIDE (IMAGE + VECTOR)
            SizedBox(
              width: 180, 
              height: 140,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // VECTOR
                  Positioned.fill(
                    right: -14,
                    bottom: -20,
                    child: Image.asset(
                      'assets/imgoffers/Vector 52.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // BURGER
                  Positioned(
                    right: -4, 
                    bottom: -4,
                    child: Image.asset(
                      banner.image,
                      height: 145,
                      fit: BoxFit.contain,
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
}
