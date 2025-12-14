import 'package:eat2beat/data/dummy_offer_data.dart';
import 'package:eat2beat/screens/home/tabs/offers/banner_card.dart';
import 'package:eat2beat/screens/home/tabs/offers/food_card.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:flutter/material.dart';


class OffersTab extends StatelessWidget {
  const OffersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
       backgroundColor: AppColors.light,
      body: Stack(
        children: [
          Image.asset(AppImages.pattern),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth*0.02,
                vertical: screenHeight*0.02
            ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================> banner <=================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.1),
                child: Container(
                  height: screenHeight * 0.23,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), 
                    color: Colors.transparent, 
                  ),
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 1), 
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.9, end: 1),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16), 
                          child: BannerItem(banner: banner),
                        ),
                      );
                    },
                  ),
                ),
              ),

           SizedBox(height: 15),

          const Text(
            'Popular Today',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
          ),
          // =================>food grid <=================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
              mainAxisExtent: screenHeight * 0.28,
            ),
            itemBuilder: (context, index) {
              final item = foodList[index];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + index * 40),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: FoodCard(
                  item: item,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
        ],
      ),
        ),
          ),
        ],
      ),
    );
  }
}
