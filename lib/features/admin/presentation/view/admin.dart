import 'package:eat2beat/features/admin/presentation/view/admin_home/meals_page.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/admin_upload.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/dashboard.dart';
import 'package:eat2beat/features/admin/presentation/view/orders/admin_orders.dart';
import 'package:eat2beat/features/admin/presentation/view/widgets/custom_navi_bar.dart';
import 'package:eat2beat/features/admin/presentation/cubits/meals_cubit/meals_cubit.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_restaurant_meals_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/delete_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_restaurant_image_usecase.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:eat2beat/features/admin/presentation/cubits/orders_cubit/orders_cubit.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_orders_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_order_status_usecase.dart';
import 'package:eat2beat/features/admin/presentation/cubits/admin_donation_cubit/admin_donation_cubit.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_donations/admin_donations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRouteName extends StatefulWidget {
  const AdminRouteName({super.key});

  @override
  State<AdminRouteName> createState() => _AdminRouteNameState();
}

class _AdminRouteNameState extends State<AdminRouteName> {
  int _selectedIndex = 0;

  late final MealsCubit _mealsCubit;
  late final ProfileCubit _profileCubit;
  late final OrdersCubit _ordersCubit;
  late final AdminDonationCubit _donationCubit;

  @override
  void initState() {
    super.initState();
    _mealsCubit = MealsCubit(
      authRepo: getIt<AuthRepo>(),
      getRestaurantMealsUseCase: getIt<GetRestaurantMealsUseCase>(),
      deleteMealUseCase: getIt<DeleteMealUseCase>(),
      updateRestaurantImageUseCase: getIt<UpdateRestaurantImageUseCase>(),
    )..loadMeals();

    _profileCubit = ProfileCubit(
      authRepo: getIt<AuthRepo>(),
      apiService: getIt<ApiService>(),
    )..loadProfile();

    _ordersCubit = OrdersCubit(
      authRepo: getIt<AuthRepo>(),
      getOrdersUseCase: getIt<GetOrdersUseCase>(),
      updateOrderStatusUseCase: getIt<UpdateOrderStatusUseCase>(),
    );

    _donationCubit = getIt<AdminDonationCubit>();
  }

  @override
  void dispose() {
    _mealsCubit.close();
    _profileCubit.close();
    _ordersCubit.close();
    _donationCubit.close();
    super.dispose();
  }

  /// Called after a meal is published successfully — switches to the meals tab and reloads.
  void _onMealPublished() {
    _mealsCubit.loadMeals();
    setState(() => _selectedIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    // We don't use the route argument anymore, we'll get it from ProfileCubit state!
    return MultiBlocProvider(
      providers: [
        BlocProvider<MealsCubit>.value(value: _mealsCubit),
        BlocProvider<ProfileCubit>.value(value: _profileCubit),
        BlocProvider<OrdersCubit>.value(value: _ordersCubit),
        BlocProvider<AdminDonationCubit>.value(value: _donationCubit),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          String restaurantName = 'Loading...';
          String? restaurantImageUrl;
          if (profileState is ProfileLoaded) {
            restaurantName = profileState.profileData['restaurant_name']?.toString() ?? 'My Restaurant';
            restaurantImageUrl = profileState.profileData['restaurant_img_url']?.toString() ??
                profileState.profileData['img_url']?.toString();
          }

          final List<Widget> pages = [
            MealsPage(
              restaurantName: restaurantName,
              restaurantImageUrl: restaurantImageUrl,
            ),
            AdminUploadPage(onMealPublished: _onMealPublished),
            const OrdersPage(),
            const AdminDonationPage(),
            const DashboardPage(),
          ];

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          );
        },
      ),
    );
  }
}