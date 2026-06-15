import 'package:eat2beat/data/dummy_offer_data.dart';
import 'package:eat2beat/features/screens/home/tabs/offers/banner_card.dart';
import 'package:eat2beat/features/screens/home/tabs/offers/food_card.dart';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/models/offers_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({super.key});

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  List<FoodModel> _offers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _offers = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final rawOffers = await apiService.getUserOffers(token);
        
        final mappedOffers = rawOffers.map((row) {
          if (row is Map<String, dynamic>) {
            return _mapJsonToFoodModel(row);
          }
          return null;
        }).whereType<FoodModel>().toList();

        if (mounted) {
          setState(() {
            _offers = mappedOffers;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _offers = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load offers: $e')),
        );
      }
    }
  }

  FoodModel _mapJsonToFoodModel(Map<String, dynamic> json) {
    final id = json['offer_id']?.toString() ?? json['id']?.toString() ?? '';
    final title = json['title']?.toString() ?? 'Offer';
    
    // Image URL mapping
    final imageUrl = json['image_url']?.toString() ?? 
                     json['offer_img_url']?.toString() ?? 
                     'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80';
                     
    // Prices mapping
    final double price = (json['offer_price'] as num?)?.toDouble() ?? 
                         (json['price'] as num?)?.toDouble() ?? 0.0;
    final double originalPrice = (json['original_price'] as num?)?.toDouble() ?? 0.0;
    
    // Sale text mapping (discount percent)
    String saleText = '';
    if (originalPrice > 0 && price > 0) {
      final discount = ((1 - price / originalPrice) * 100).round();
      if (discount > 0) {
        saleText = '$discount% OFF';
      }
    }
    
    // Restaurant mapping
    final restName = json['restaurant_name']?.toString() ?? 
                     json['restaurant']?['name']?.toString() ?? 
                     'Restaurant';
    final restIcon = json['restaurant']?['logo_url']?.toString() ?? '';
    
    final qty = (json['quantity'] as num?)?.toInt() ?? 1;
    final desc = json['description']?.toString() ?? '';
    
    return FoodModel(
      id: id,
      name: title,
      image: imageUrl,
      price: price,
      sale: saleText.isNotEmpty ? saleText : 'Special Offer',
      rate: 4.8,
      time: '20 Min',
      quantity: qty,
      description: desc,
      size: 'L',
      restruanteName: restName,
      restauranteIcon: restIcon,
      isOffer: true,
      offerId: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.light,
          body: Stack(
            children: [
              Image.asset(Assets.imagesPattern),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02,
                ),
                child: RefreshIndicator(
                  onRefresh: _loadOffers,
                  color: AppColors.purple,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =================> banner <=================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.1),
                          child: Container(
                            height: (screenHeight * 0.23).clamp(160.0, 200.0),
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

                        const SizedBox(height: 15),

                        const Text(
                          'Popular Today',
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // =================> State Handling / Food Grid <=================
                        if (user == null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    size: 64,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Login required to view offers",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.loginRouteName).then((_) => _loadOffers());
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
                        else if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.purple),
                            ),
                          )
                        else if (_offers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                "No offers available now",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _offers.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 12,
                              mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                            ),
                            itemBuilder: (context, index) {
                              final item = _offers[index];

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
                        SizedBox(height: screenHeight * 0.14),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
