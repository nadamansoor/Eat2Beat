
import 'dart:io';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_text_field.dart';
import 'package:eat2beat/features/models/home_model.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/models/restaurant_model.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:eat2beat/core/utils/localization_helper.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  bool isSearching = false;
  String searchQuery = '';

  List<String> categories = [
    "All Meals",
    "Recommended",
    "Restaurants",
    "Top Rated",
    "Favorites",
  ];

  List<RestaurantModel> restaurants = [];
  bool loadingRestaurants = false;
  String? restaurantsError;

  RestaurantModel? selectedRestaurant;
  List<HomeFoodModel> restaurantMeals = [];
  bool loadingMeals = false;
  String? mealsError;

  List<HomeFoodModel> favoriteMeals = [];
  bool loadingFavorites = false;
  String? favoritesError;
  Set<String> favoriteMealIds = {};

  List<HomeFoodModel> recommendedMeals = [];
  bool loadingRecommendations = false;
  String? recommendationsError;

  List<HomeFoodModel> topRatedMeals = [];
  bool loadingTopRated = false;
  String? topRatedError;

  List<HomeFoodModel> allMeals = [];
  bool loadingAllMeals = false;
  String? allMealsError;

  @override
  void initState() {
    super.initState();
    _fetchAllMeals();
    _fetchFavoriteMealIds();
  }

  Future<void> _fetchRecommendedMeals() async {
    if (loadingRecommendations) return;
    setState(() {
      loadingRecommendations = true;
      recommendationsError = null;
    });
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) {
        throw Exception("Please log in to view recommendations.");
      }
      final rawMeals = await getIt<ApiService>().getRecommendedMeals(token);
      final List<HomeFoodModel> mappedMeals = [];
      for (final m in rawMeals) {
        final id = m['id']?.toString() ?? m['meal_id']?.toString() ?? '';
        final restaurantId = m['restaurant_id']?.toString() ?? 
                             m['restaurants_id']?.toString() ?? 
                             m['restaurant']?['id']?.toString() ?? 
                             '';
        final title = m['title']?.toString() ?? m['name']?.toString() ?? 'Meal';
        final description = m['description']?.toString() ?? '';
        final priceVal = m['price'];
        double price = 0.0;
        if (priceVal is num) {
          price = priceVal.toDouble();
        } else if (priceVal is String && priceVal.isNotEmpty) {
          price = double.tryParse(priceVal) ?? 0.0;
        }
        final mealImgUrl = m['meal_img_url']?.toString() ?? m['image']?.toString() ?? '';
        final restName = m['restaurant_name']?.toString() ?? 
                         m['rest_name']?.toString() ?? 
                         m['restaurant']?['name']?.toString() ?? 
                         'Restaurant';
        final restIcon = m['restaurant_img_url']?.toString() ?? 
                         m['restaurant']?['logo_url']?.toString() ?? 
                         m['restaurant']?['img_url']?.toString() ?? 
                         m['restaurant']?['rest_img_url']?.toString() ?? 
                         m['restaurant']?['image']?.toString() ?? 
                         Assets.imagesBurgerKing;
        
        final rateVal = m['rate'] ?? m['rating'] ?? m['avg_rating'] ?? m['average_rating'];
        double rate = 0.0;
        if (rateVal is num) {
          rate = rateVal.toDouble();
        } else if (rateVal is String && rateVal.isNotEmpty) {
          rate = double.tryParse(rateVal) ?? 0.0;
        }
        
        final isActiveVal = m['is_active'] ?? m['isActive'] ?? m['restaurant']?['is_active'] ?? m['restaurant']?['isActive'];
        final bool? isActive = isActiveVal == null ? null : (isActiveVal == true || isActiveVal == 1 || isActiveVal?.toString() == 'true' || isActiveVal?.toString() == '1');

        final isAcceptingOrdersVal = m['is_accepting_orders'] ?? m['isAcceptingOrders'] ?? m['restaurant']?['is_accepting_orders'] ?? m['restaurant']?['isAcceptingOrders'];
        final bool? isAcceptingOrders = isAcceptingOrdersVal == null ? null : (isAcceptingOrdersVal == true || isAcceptingOrdersVal == 1 || isAcceptingOrdersVal?.toString() == 'true' || isAcceptingOrdersVal?.toString() == '1');

        final isOpenNowVal = m['is_open_now'] ?? m['isOpenNow'] ?? m['restaurant']?['is_open_now'] ?? m['restaurant']?['isOpenNow'];
        final bool? isOpenNow = isOpenNowVal == null ? null : (isOpenNowVal == true || isOpenNowVal == 1 || isOpenNowVal?.toString() == 'true' || isOpenNowVal?.toString() == '1');

        final isOrderableNowVal = m['is_orderable_now'] ?? m['isOrderableNow'] ?? m['restaurant']?['is_orderable_now'] ?? m['restaurant']?['isOrderableNow'];
        final bool? isOrderableNow = isOrderableNowVal == null ? null : (isOrderableNowVal == true || isOrderableNowVal == 1 || isOrderableNowVal?.toString() == 'true' || isOrderableNowVal?.toString() == '1');

        final pauseReason = m['pause_reason']?.toString() ?? m['pauseReason']?.toString() ?? m['restaurant']?['pause_reason']?.toString() ?? m['restaurant']?['pauseReason']?.toString();

        mappedMeals.add(HomeFoodModel(
          id: id,
          restaurantId: restaurantId.isNotEmpty ? restaurantId : null,
          restName: restName,
          restIcon: restIcon,
          size: 'M',
          title: title,
          image: mealImgUrl.isNotEmpty ? mealImgUrl : Assets.imagesFood,
          price: price,
          rate: rate,
          description: description,
          time: '20 Min',
          restIsOpen: true,
          restOpenTime: '09:00 AM',
          restCloseTime: '11:00 PM',
          isActive: isActive,
          isAcceptingOrders: isAcceptingOrders,
          isOpenNow: isOpenNow,
          isOrderableNow: isOrderableNow,
          pauseReason: pauseReason,
        ));
      }
      setState(() {
        recommendedMeals = mappedMeals;
        loadingRecommendations = false;
      });
    } catch (e) {
      setState(() {
        recommendationsError = e.toString().replaceFirst("Exception: ", "");
        loadingRecommendations = false;
      });
    }
  }

  Future<void> _fetchAllMeals() async {
    if (loadingAllMeals) return;
    setState(() {
      loadingAllMeals = true;
      allMealsError = null;
    });
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      
      List<HomeFoodModel> compiledMeals = [];
      
      // 1. Add static meals
      compiledMeals.addAll(HomeFoodModel.mealDetails);
      
      // 2. Fetch meals from API if token is available
      if (token != null) {
        // Fetch all restaurants first
        final rawRestaurants = await getIt<ApiService>().getUserRestaurants(token);
        final List<RestaurantModel> parsedRestaurants = rawRestaurants.map((r) => RestaurantModel.fromJson(r)).toList();
        
        // Fetch meals for all restaurants in parallel
        final futures = parsedRestaurants.map((restaurant) async {
          try {
            final rawMeals = await getIt<ApiService>().getRestaurantMeals(token, restaurant.id);
            final List<HomeFoodModel> mappedMeals = [];
            for (final m in rawMeals) {
              final id = m['id']?.toString() ?? m['meal_id']?.toString() ?? '';
              final title = m['title']?.toString() ?? m['name']?.toString() ?? 'Meal';
              final description = m['description']?.toString() ?? '';
              final priceVal = m['price'];
              double price = 0.0;
              if (priceVal is num) {
                price = priceVal.toDouble();
              } else if (priceVal is String && priceVal.isNotEmpty) {
                price = double.tryParse(priceVal) ?? 0.0;
              }
              final mealImgUrl = m['meal_img_url']?.toString() ?? m['image']?.toString() ?? '';
              
              final rateVal = m['rate'] ?? m['rating'] ?? m['avg_rating'] ?? m['average_rating'];
              double rate = 0.0;
              if (rateVal is num) {
                rate = rateVal.toDouble();
              } else if (rateVal is String && rateVal.isNotEmpty) {
                rate = double.tryParse(rateVal) ?? 0.0;
              }
              
              final isActiveVal = m['is_active'] ?? m['isActive'];
              final bool? isActive = isActiveVal == null ? restaurant.isActive : (isActiveVal == true || isActiveVal == 1 || isActiveVal?.toString() == 'true' || isActiveVal?.toString() == '1');

              final isAcceptingOrdersVal = m['is_accepting_orders'] ?? m['isAcceptingOrders'];
              final bool? isAcceptingOrders = isAcceptingOrdersVal == null ? restaurant.isAcceptingOrders : (isAcceptingOrdersVal == true || isAcceptingOrdersVal == 1 || isAcceptingOrdersVal?.toString() == 'true' || isAcceptingOrdersVal?.toString() == '1');

              final isOpenNowVal = m['is_open_now'] ?? m['isOpenNow'];
              final bool? isOpenNow = isOpenNowVal == null ? restaurant.isOpenNow : (isOpenNowVal == true || isOpenNowVal == 1 || isOpenNowVal?.toString() == 'true' || isOpenNowVal?.toString() == '1');

              final isOrderableNowVal = m['is_orderable_now'] ?? m['isOrderableNow'];
              final bool? isOrderableNow = isOrderableNowVal == null ? restaurant.isOrderableNow : (isOrderableNowVal == true || isOrderableNowVal == 1 || isOrderableNowVal?.toString() == 'true' || isOrderableNowVal?.toString() == '1');

              final pauseReason = m['pause_reason']?.toString() ?? m['pauseReason']?.toString() ?? restaurant.pauseReason;

              mappedMeals.add(HomeFoodModel(
                id: id,
                restaurantId: restaurant.id,
                restName: restaurant.name,
                restIcon: restaurant.image.isNotEmpty ? restaurant.image : Assets.imagesBurgerKing,
                size: 'M',
                title: title,
                image: mealImgUrl.isNotEmpty ? mealImgUrl : Assets.imagesFood,
                price: price,
                rate: rate,
                description: description,
                time: '20 Min',
                restIsOpen: restaurant.isOpen,
                restOpenTime: restaurant.openTime,
                restCloseTime: restaurant.closeTime,
                isActive: isActive,
                isAcceptingOrders: isAcceptingOrders,
                isOpenNow: isOpenNow,
                isOrderableNow: isOrderableNow,
                pauseReason: pauseReason,
              ));
            }
            return mappedMeals;
          } catch (_) {
            return <HomeFoodModel>[];
          }
        }).toList();
        
        final results = await Future.wait(futures);
        for (final meals in results) {
          compiledMeals.addAll(meals);
        }
      }
      
      // Filter out duplicates
      final Map<String, HomeFoodModel> uniqueMealsMap = {};
      for (final meal in compiledMeals) {
        final key = (meal.id != null && meal.id!.isNotEmpty) ? meal.id! : meal.title;
        if (!uniqueMealsMap.containsKey(key) || uniqueMealsMap[key]!.rate < meal.rate) {
          uniqueMealsMap[key] = meal;
        }
      }
      
      setState(() {
        allMeals = uniqueMealsMap.values.toList();
        loadingAllMeals = false;
      });
    } catch (e) {
      setState(() {
        allMealsError = e.toString().replaceFirst("Exception: ", "");
        loadingAllMeals = false;
      });
    }
  }

  Future<void> _fetchTopRatedMeals() async {
    if (loadingTopRated) return;
    setState(() {
      loadingTopRated = true;
      topRatedError = null;
    });
    try {
      if (allMeals.isEmpty) {
        await _fetchAllMeals();
      }
      
      final sortedMeals = allMeals
          .where((meal) => meal.rate >= 3.0)
          .toList();
      sortedMeals.sort((a, b) => b.rate.compareTo(a.rate));
      
      setState(() {
        topRatedMeals = sortedMeals;
        loadingTopRated = false;
      });
    } catch (e) {
      setState(() {
        topRatedError = e.toString().replaceFirst("Exception: ", "");
        loadingTopRated = false;
      });
    }
  }

  bool _isFavorite(String id) {
    return favoriteMealIds.contains(id);
  }

  Future<void> _fetchFavoriteMealIds() async {
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) return;
      final rawIds = await getIt<ApiService>().getFavoriteMealIds(token);
      final Set<String> ids = {};
      for (final row in rawIds) {
        final mealId = row['meal_id']?.toString() ?? '';
        if (mealId.isNotEmpty) {
          ids.add(mealId);
        }
      }
      setState(() {
        favoriteMealIds = ids;
      });
    } catch (_) {}
  }

  Future<void> _fetchFavoriteMeals() async {
    if (loadingFavorites) return;
    setState(() {
      loadingFavorites = true;
      favoritesError = null;
    });
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) {
        throw Exception("Failed to get authorization token.");
      }
      final rawMeals = await getIt<ApiService>().getFavoriteMealsList(token);
      
      final List<HomeFoodModel> mappedMeals = [];
      final Set<String> updatedFavIds = {};
      for (final m in rawMeals) {
        final id = m['id']?.toString() ?? m['meal_id']?.toString() ?? '';
        if (id.isEmpty) continue;
        updatedFavIds.add(id);

        final restaurantId = m['restaurant_id']?.toString() ?? 
                             m['restaurants_id']?.toString() ?? 
                             m['restaurant']?['id']?.toString() ?? 
                             '';
        final title = m['title']?.toString() ?? m['name']?.toString() ?? 'Meal';
        final description = m['description']?.toString() ?? '';
        final priceVal = m['price'];
        double price = 0.0;
        if (priceVal is num) {
          price = priceVal.toDouble();
        } else if (priceVal is String && priceVal.isNotEmpty) {
          price = double.tryParse(priceVal) ?? 0.0;
        }
        final mealImgUrl = m['meal_img_url']?.toString() ?? m['image']?.toString() ?? '';
        
        final restName = m['restaurant_name']?.toString() ?? 
                         m['rest_name']?.toString() ?? 
                         m['restaurant']?['name']?.toString() ?? 
                         'Restaurant';
        final restIcon = m['restaurant_img_url']?.toString() ?? 
                         m['restaurant']?['logo_url']?.toString() ?? 
                         m['restaurant']?['img_url']?.toString() ?? 
                         m['restaurant']?['rest_img_url']?.toString() ?? 
                         m['restaurant']?['image']?.toString() ?? 
                         Assets.imagesBurgerKing;
                         
        final rateVal = m['rate'] ?? m['rating'] ?? m['avg_rating'] ?? m['average_rating'];
        double rate = 0.0;
        if (rateVal is num) {
          rate = rateVal.toDouble();
        } else if (rateVal is String && rateVal.isNotEmpty) {
          rate = double.tryParse(rateVal) ?? 0.0;
        }
        
        final restIsOpenVal = m['is_open'] ?? m['isOpen'];
        final bool restIsOpen;
        if (restIsOpenVal == null) {
          restIsOpen = true;
        } else {
          restIsOpen = restIsOpenVal == true ||
              restIsOpenVal == 1 ||
              restIsOpenVal?.toString() == 'true' ||
              restIsOpenVal?.toString() == '1';
        }
        final restOpenTime = m['open_time']?.toString() ?? m['openTime']?.toString() ?? '09:00 AM';
        final restCloseTime = m['close_time']?.toString() ?? m['closeTime']?.toString() ?? '11:00 PM';

        final isActiveVal = m['is_active'] ?? m['isActive'] ?? m['restaurant']?['is_active'] ?? m['restaurant']?['isActive'];
        final bool? isActive = isActiveVal == null ? null : (isActiveVal == true || isActiveVal == 1 || isActiveVal?.toString() == 'true' || isActiveVal?.toString() == '1');

        final isAcceptingOrdersVal = m['is_accepting_orders'] ?? m['isAcceptingOrders'] ?? m['restaurant']?['is_accepting_orders'] ?? m['restaurant']?['isAcceptingOrders'];
        final bool? isAcceptingOrders = isAcceptingOrdersVal == null ? null : (isAcceptingOrdersVal == true || isAcceptingOrdersVal == 1 || isAcceptingOrdersVal?.toString() == 'true' || isAcceptingOrdersVal?.toString() == '1');

        final isOpenNowVal = m['is_open_now'] ?? m['isOpenNow'] ?? m['restaurant']?['is_open_now'] ?? m['restaurant']?['isOpenNow'];
        final bool? isOpenNow = isOpenNowVal == null ? null : (isOpenNowVal == true || isOpenNowVal == 1 || isOpenNowVal?.toString() == 'true' || isOpenNowVal?.toString() == '1');

        final isOrderableNowVal = m['is_orderable_now'] ?? m['isOrderableNow'] ?? m['restaurant']?['is_orderable_now'] ?? m['restaurant']?['isOrderableNow'];
        final bool? isOrderableNow = isOrderableNowVal == null ? null : (isOrderableNowVal == true || isOrderableNowVal == 1 || isOrderableNowVal?.toString() == 'true' || isOrderableNowVal?.toString() == '1');

        final pauseReason = m['pause_reason']?.toString() ?? m['pauseReason']?.toString() ?? m['restaurant']?['pause_reason']?.toString() ?? m['restaurant']?['pauseReason']?.toString();

        mappedMeals.add(HomeFoodModel(
          id: id,
          restaurantId: restaurantId.isNotEmpty ? restaurantId : null,
          restName: restName,
          restIcon: restIcon,
          size: 'M',
          title: title,
          image: mealImgUrl.isNotEmpty ? mealImgUrl : Assets.imagesFood,
          price: price,
          rate: rate,
          description: description,
          time: '20 Min',
          restIsOpen: restIsOpen,
          restOpenTime: restOpenTime,
          restCloseTime: restCloseTime,
          isActive: isActive,
          isAcceptingOrders: isAcceptingOrders,
          isOpenNow: isOpenNow,
          isOrderableNow: isOrderableNow,
          pauseReason: pauseReason,
        ));
      }
      
      setState(() {
        favoriteMeals = mappedMeals;
        favoriteMealIds = updatedFavIds;
        loadingFavorites = false;
      });
    } catch (e) {
      setState(() {
        favoritesError = e.toString().replaceFirst("Exception: ", "");
        loadingFavorites = false;
      });
    }
  }

  Future<void> _toggleFavorite(HomeFoodModel item) async {
    final mealId = item.id;
    if (mealId == null) return;

    final isFav = _isFavorite(mealId);

    setState(() {
      if (isFav) {
        favoriteMealIds.remove(mealId);
        if (selectedIndex == 4) {
          favoriteMeals.removeWhere((m) => m.id == mealId);
        }
      } else {
        favoriteMealIds.add(mealId);
      }
    });

    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) {
        throw Exception("Failed to get authorization token.");
      }

      if (isFav) {
        await getIt<ApiService>().unfavoriteMeal(token, mealId);
      } else {
        await getIt<ApiService>().favoriteMeal(token, mealId);
      }
      
      if (!isFav && selectedIndex == 4) {
        _fetchFavoriteMeals();
      }
    } catch (e) {
      setState(() {
        if (isFav) {
          favoriteMealIds.add(mealId);
        } else {
          favoriteMealIds.remove(mealId);
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update favorite: ${e.toString()}")),
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

  Future<void> _fetchRestaurants() async {
    if (loadingRestaurants) return;
    setState(() {
      loadingRestaurants = true;
      restaurantsError = null;
    });
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) {
        throw Exception("Failed to get authorization token.");
      }
      final rawRestaurants = await getIt<ApiService>().getUserRestaurants(token);
      debugPrint("E2B_DEBUG: getUserRestaurants response: $rawRestaurants");
      setState(() {
        restaurants = rawRestaurants.map((r) => RestaurantModel.fromJson(r)).toList();
        loadingRestaurants = false;
      });
    } catch (e) {
      debugPrint("E2B_DEBUG: getUserRestaurants failed: $e");
      setState(() {
        restaurantsError = e.toString().replaceFirst("Exception: ", "");
        loadingRestaurants = false;
      });
    }
  }

  Future<void> _fetchRestaurantMeals(RestaurantModel restaurant) async {
    setState(() {
      selectedRestaurant = restaurant;
      loadingMeals = true;
      mealsError = null;
      restaurantMeals = [];
    });
    try {
      final authRepo = getIt<AuthRepo>();
      final token = await authRepo.getIdToken();
      if (token == null) {
        throw Exception("Failed to get authorization token.");
      }
      final rawMeals = await getIt<ApiService>().getRestaurantMeals(token, restaurant.id);
      
      final List<HomeFoodModel> mappedMeals = [];
      for (final m in rawMeals) {
        final id = m['id']?.toString() ?? m['meal_id']?.toString() ?? '';
        final title = m['title']?.toString() ?? m['name']?.toString() ?? 'Meal';
        final description = m['description']?.toString() ?? '';
        final priceVal = m['price'];
        double price = 0.0;
        if (priceVal is num) {
          price = priceVal.toDouble();
        } else if (priceVal is String && priceVal.isNotEmpty) {
          price = double.tryParse(priceVal) ?? 0.0;
        }
        final mealImgUrl = m['meal_img_url']?.toString() ?? m['image']?.toString() ?? '';
        
        final rateVal = m['rate'] ?? m['rating'] ?? m['avg_rating'] ?? m['average_rating'];
        double rate = 0.0;
        if (rateVal is num) {
          rate = rateVal.toDouble();
        } else if (rateVal is String && rateVal.isNotEmpty) {
          rate = double.tryParse(rateVal) ?? 0.0;
        }
        
        final isActiveVal = m['is_active'] ?? m['isActive'];
        final bool? isActive = isActiveVal == null ? restaurant.isActive : (isActiveVal == true || isActiveVal == 1 || isActiveVal?.toString() == 'true' || isActiveVal?.toString() == '1');

        final isAcceptingOrdersVal = m['is_accepting_orders'] ?? m['isAcceptingOrders'];
        final bool? isAcceptingOrders = isAcceptingOrdersVal == null ? restaurant.isAcceptingOrders : (isAcceptingOrdersVal == true || isAcceptingOrdersVal == 1 || isAcceptingOrdersVal?.toString() == 'true' || isAcceptingOrdersVal?.toString() == '1');

        final isOpenNowVal = m['is_open_now'] ?? m['isOpenNow'];
        final bool? isOpenNow = isOpenNowVal == null ? restaurant.isOpenNow : (isOpenNowVal == true || isOpenNowVal == 1 || isOpenNowVal?.toString() == 'true' || isOpenNowVal?.toString() == '1');

        final isOrderableNowVal = m['is_orderable_now'] ?? m['isOrderableNow'];
        final bool? isOrderableNow = isOrderableNowVal == null ? restaurant.isOrderableNow : (isOrderableNowVal == true || isOrderableNowVal == 1 || isOrderableNowVal?.toString() == 'true' || isOrderableNowVal?.toString() == '1');

        final pauseReason = m['pause_reason']?.toString() ?? m['pauseReason']?.toString() ?? restaurant.pauseReason;

        mappedMeals.add(HomeFoodModel(
          id: id,
          restaurantId: restaurant.id,
          restName: restaurant.name,
          restIcon: restaurant.image.isNotEmpty ? restaurant.image : Assets.imagesBurgerKing,
          size: 'M',
          title: title,
          image: mealImgUrl.isNotEmpty ? mealImgUrl : Assets.imagesFood,
          price: price,
          rate: rate,
          description: description,
          time: '20 Min',
          restIsOpen: restaurant.isOpen,
          restOpenTime: restaurant.openTime,
          restCloseTime: restaurant.closeTime,
          isActive: isActive,
          isAcceptingOrders: isAcceptingOrders,
          isOpenNow: isOpenNow,
          isOrderableNow: isOrderableNow,
          pauseReason: pauseReason,
        ));
      }
      
      setState(() {
        restaurantMeals = mappedMeals;
        loadingMeals = false;
      });
    } catch (e) {
      setState(() {
        mealsError = e.toString().replaceFirst("Exception: ", "");
        loadingMeals = false;
      });
    }
  }

  void onSearch(String value) {
    setState(() {
      searchQuery = value.trim();
      isSearching = searchQuery.isNotEmpty;
    });
  }

  Color _getToneColor(String tone) {
    if (tone == 'success') return const Color(0xFF10B981);
    if (tone == 'warning') return const Color(0xFFF59E0B);
    if (tone == 'danger') return const Color(0xFFEF4444);
    return const Color(0xFF9499A5);
  }

  String _getCategoryTitle(BuildContext context, String key) {
    switch (key) {
      case "All Meals":
        return S.of(context).allMeals;
      case "Recommended":
        return S.of(context).recommended;
      case "Restaurants":
        return S.of(context).restaurants;
      case "Top Rated":
        return S.of(context).topRated;
      case "Favorites":
        return S.of(context).favorites;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final filteredMeals = restaurantMeals
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredRestaurants = restaurants
        .where((r) => r.name
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredFavMeals = favoriteMeals
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredTopRatedMeals = topRatedMeals
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredAllMeals = allMeals
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredGeneralMeals = HomeFoodModel.mealDetails
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredRecMeals = recommendedMeals
        .where((item) => item.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.light,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListenableBuilder(
          listenable: UserProfileNotifier(),
          builder: (context, child) {
            final profile = UserProfileNotifier();
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.profileRouteName,
                    );
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.purple50,
                    backgroundImage: profile.profileImagePath.isNotEmpty
                        ? FileImage(File(profile.profileImagePath)) as ImageProvider
                        : null,
                    child: profile.profileImagePath.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 22,
                            color: AppColors.purple,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).hello, style: AppStyles.black13w400),
                    Text(profile.name, style: AppStyles.black16Bold),
                  ],
                )
              ],
            );
          },
        ),
        actions: const [],
      ),
      body: Stack(
        children: [
          Image.asset(Assets.imagesPattern),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),

                  CustomTextFormField(
                    hintText: S.of(context).search,
                    controller: searchController,
                    onChanged: onSearch,
                    prefixIcon: Icon(Icons.search,
                        color: AppColors.black),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              onSearch('');
                            },
                          )
                        : null,
                    focusedBorderColor: AppColors.purple,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  if (selectedRestaurant != null) ...[
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: ThemeNotifier().isDarkMode ? Colors.white : AppColors.purple,
                          ),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                              isSearching = false;
                              selectedRestaurant = null;
                            });
                          },
                        ),
                        Text(
                          "Back to restaurants",
                          style: AppStyles.black16w500.copyWith(
                            color: ThemeNotifier().isDarkMode ? Colors.white : AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${selectedRestaurant!.name} Menu",
                            style: AppStyles.black20Bold,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getToneColor(selectedRestaurant!.orderabilityTone),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                selectedRestaurant!.orderabilityLabel,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _getToneColor(selectedRestaurant!.orderabilityTone),
                                ),
                              ),
                            ],
                          ),
                          if (selectedRestaurant!.orderabilityReason != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              selectedRestaurant!.orderabilityReason!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (loadingMeals)
                      const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                    else if (mealsError != null)
                      Center(
                        child: Column(
                          children: [
                            Text(mealsError!, style: AppStyles.black16w500),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _fetchRestaurantMeals(selectedRestaurant!),
                              child: Text(S.of(context).retry),
                            ),
                          ],
                        ),
                      )
                    else if (filteredMeals.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            isSearching
                                ? S.of(context).noMealsFound(searchQuery)
                                : S.of(context).noMealsAvailable,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredMeals.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 12,
                          mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredMeals[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _buildImage(
                                          item.image,
                                          width: double.infinity,
                                          height: screenHeight * 0.12,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      if (item.rate > 0)
                                        Positioned(
                                          left: 8,
                                          top: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ImageIcon(
                                                  AssetImage(Assets.imagesRateIcon),
                                                  color: AppColors.yellow,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "${item.rate}",
                                                  style: AppStyles.grey13w400.copyWith(fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (item.id != null && item.id!.isNotEmpty)
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: InkWell(
                                            onTap: () => _toggleFavorite(item),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _isFavorite(item.id!)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.black13Bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      "\$ ${item.price.toStringAsFixed(2)}",
                                      style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ] else ...[
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: screenWidth * 0.02),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = '';
                                isSearching = false;
                                selectedIndex = index;
                              });
                              if (index == 0) {
                                _fetchAllMeals();
                              } else if (index == 1) {
                                _fetchRecommendedMeals();
                              } else if (index == 2 && restaurants.isEmpty) {
                                _fetchRestaurants();
                              } else if (index == 3) {
                                _fetchTopRatedMeals();
                              } else if (index == 4) {
                                _fetchFavoriteMeals();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? AppColors.purple
                                    : (ThemeNotifier().isDarkMode
                                        ? const Color(0xff45337D)
                                        : AppColors.lightPurple),
                                borderRadius: BorderRadius.circular(40),
                                border: selectedIndex == index
                                    ? Border.all(color: Colors.white, width: 1.5)
                                    : null,
                              ),
                              child: Text(
                                _getCategoryTitle(context, categories[index]),
                                style: selectedIndex == index
                                    ? AppStyles.black16w500
                                        .copyWith(color: Colors.white)
                                    : AppStyles.black16w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (selectedIndex == 0) ...[
                      if (loadingAllMeals && allMeals.isEmpty)
                        const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                      else if (allMealsError != null)
                        Center(
                          child: Column(
                            children: [
                              Text(allMealsError!, style: AppStyles.black16w500),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _fetchAllMeals,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      else if (filteredAllMeals.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              isSearching
                                  ? S.of(context).noMealsFound(searchQuery)
                                  : S.of(context).noMealsAvailable,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredAllMeals.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredAllMeals[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildImage(
                                            item.image,
                                            width: double.infinity,
                                            height: screenHeight * 0.12,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (item.rate > 0)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(Assets.imagesRateIcon),
                                                    color: AppColors.yellow,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "${item.rate}",
                                                    style: AppStyles.grey13w400.copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (item.id != null && item.id!.isNotEmpty)
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: InkWell(
                                              onTap: () => _toggleFavorite(item),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _isFavorite(item.id!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.title),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black13Bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.description),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        "\$ ${item.price.toStringAsFixed(2)}",
                                        style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ] else if (selectedIndex == 1) ...[
                      if (loadingRecommendations && recommendedMeals.isEmpty)
                        const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                      else if (recommendationsError != null)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                recommendationsError!, 
                                style: AppStyles.black16w500,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              if (recommendationsError!.contains("log in") || recommendationsError!.contains("sign in") || recommendationsError!.contains("login"))
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoutes.loginRouteName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(S.of(context).signIn),
                                )
                              else
                                ElevatedButton(
                                  onPressed: _fetchRecommendedMeals,
                                  child: Text(S.of(context).retry),
                                ),
                            ],
                          ),
                        )
                      else if (filteredRecMeals.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              isSearching
                                  ? S.of(context).noRecsFound(searchQuery)
                                  : S.of(context).noRecsAvailable,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRecMeals.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredRecMeals[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildImage(
                                            item.image,
                                            width: double.infinity,
                                            height: screenHeight * 0.12,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (item.rate > 0)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(Assets.imagesRateIcon),
                                                    color: AppColors.yellow,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "${item.rate}",
                                                    style: AppStyles.grey13w400.copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (item.id != null && item.id!.isNotEmpty)
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: InkWell(
                                              onTap: () => _toggleFavorite(item),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _isFavorite(item.id!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.title),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black13Bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.description),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        "\$ ${item.price.toStringAsFixed(2)}",
                                        style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ] else if (selectedIndex == 2) ...[
                      if (loadingRestaurants)
                        const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                      else if (restaurantsError != null)
                        Center(
                          child: Column(
                            children: [
                              Text(restaurantsError!, style: AppStyles.black16w500),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _fetchRestaurants,
                                child: Text(S.of(context).retry),
                              ),
                            ],
                          ),
                        )
                      else if (filteredRestaurants.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              isSearching
                                  ? S.of(context).noRestFound(searchQuery)
                                  : S.of(context).noRestAvailable,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRestaurants.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final restaurant = filteredRestaurants[index];
                            return InkWell(
                              onTap: () {
                                searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                  isSearching = false;
                                });
                                _fetchRestaurantMeals(restaurant);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: _buildImage(
                                        restaurant.image,
                                        width: double.infinity,
                                        height: screenHeight * 0.14,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                      child: Text(
                                        getLocalizedText(context, restaurant.name),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black16Bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                      child: Text(
                                        restaurant.description.isNotEmpty ? getLocalizedText(context, restaurant.description) : 'Restaurant',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.grey13w400,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.003),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: _getToneColor(restaurant.orderabilityTone),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  restaurant.orderabilityLabel,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: _getToneColor(restaurant.orderabilityTone),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (restaurant.orderabilityReason != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              restaurant.orderabilityReason!,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ] else if (selectedIndex == 3) ...[
                      if (loadingTopRated && topRatedMeals.isEmpty)
                        const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                      else if (topRatedError != null)
                        Center(
                          child: Column(
                            children: [
                              Text(topRatedError!, style: AppStyles.black16w500),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _fetchTopRatedMeals,
                                child: Text(S.of(context).retry),
                              ),
                            ],
                          ),
                        )
                      else if (filteredTopRatedMeals.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              isSearching
                                  ? S.of(context).noMealsFound(searchQuery)
                                  : S.of(context).noMealsAvailable,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredTopRatedMeals.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredTopRatedMeals[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildImage(
                                            item.image,
                                            width: double.infinity,
                                            height: screenHeight * 0.12,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (item.rate > 0)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(Assets.imagesRateIcon),
                                                    color: AppColors.yellow,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "${item.rate}",
                                                    style: AppStyles.grey13w400.copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (item.id != null && item.id!.isNotEmpty)
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: InkWell(
                                              onTap: () => _toggleFavorite(item),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _isFavorite(item.id!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.title),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black13Bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.description),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        "\$ ${item.price.toStringAsFixed(2)}",
                                        style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ] else if (selectedIndex == 4) ...[
                      if (loadingFavorites && favoriteMeals.isEmpty)
                        const Center(child: CircularProgressIndicator(color: AppColors.purple800))
                      else if (favoritesError != null)
                        Center(
                          child: Column(
                            children: [
                              Text(favoritesError!, style: AppStyles.black16w500),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _fetchFavoriteMeals,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      else if (filteredFavMeals.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: isSearching ? screenHeight * 0.02 : screenHeight * 0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  size: 80,
                                  color: AppColors.purple.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isSearching
                                      ? S.of(context).noFavsFound
                                      : S.of(context).noFavsYet,
                                  style: AppStyles.black20Bold,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isSearching
                                      ? S.of(context).noFavsMatch(searchQuery)
                                      : S.of(context).startExploring,
                                  style: AppStyles.grey13w400,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredFavMeals.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredFavMeals[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildImage(
                                            item.image,
                                            width: double.infinity,
                                            height: screenHeight * 0.12,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (item.rate > 0)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(Assets.imagesRateIcon),
                                                    color: AppColors.yellow,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "${item.rate}",
                                                    style: AppStyles.grey13w400.copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (item.id != null && item.id!.isNotEmpty)
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: InkWell(
                                              onTap: () => _toggleFavorite(item),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _isFavorite(item.id!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.title),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black13Bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.description),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        "\$ ${item.price.toStringAsFixed(2)}",
                                        style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ] else ...[
                      if (filteredGeneralMeals.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              isSearching
                                  ? S.of(context).noMealsFound(searchQuery)
                                  : S.of(context).noMealsAvailable,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredGeneralMeals.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            mainAxisExtent: (screenHeight * 0.28).clamp(220.0, 280.0),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredGeneralMeals[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.detailsRouteName,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildImage(
                                            item.image,
                                            width: double.infinity,
                                            height: screenHeight * 0.12,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (item.rate > 0)
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ImageIcon(
                                                  AssetImage(Assets.imagesRateIcon),
                                                  color: AppColors.yellow,
                                                ),
                                                Text("${item.rate}", style: AppStyles.grey13w400),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.title),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.black13Bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        getLocalizedText(context, item.description),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        "\$ ${item.price.toStringAsFixed(2)}",
                                        style: AppStyles.grey13w400.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ],

                  SizedBox(height: screenHeight * 0.14),
                ],
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
