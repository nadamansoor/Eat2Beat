import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/core/services/firebase_auth_service.dart';
import 'package:eat2beat/features/auth/data/repos/auth_repo_impl.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/admin/data/datasources/meal_remote_datasource.dart';
import 'package:eat2beat/features/admin/data/repos/meal_repo_impl.dart';
import 'package:eat2beat/features/admin/domain/repo/meal_repo.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_restaurant_meals_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/add_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/delete_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_restaurant_image_usecase.dart';
import 'package:eat2beat/features/admin/data/datasources/order_remote_datasource.dart';
import 'package:eat2beat/features/admin/data/repos/order_repo_impl.dart';
import 'package:eat2beat/features/admin/domain/repo/order_repo.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_orders_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_order_status_usecase.dart';
import 'package:eat2beat/features/admin/data/datasources/demand_remote_datasource.dart';
import 'package:eat2beat/features/admin/data/repos/demand_repo_impl.dart';
import 'package:eat2beat/features/admin/domain/repo/demand_repo.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_demand_dashboard_usecase.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;
 void setupGetIt(){
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  //                      type      obj
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
        firebaseAuthService: getIt<FirebaseAuthService>(),
  ));
  getIt.registerSingleton<ApiService>(ApiService());

  // ── Admin enhancement registration ──────────────────────────────
  getIt.registerSingleton<MealRemoteDataSource>(
    MealRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerSingleton<MealRepo>(
    MealRepoImpl(remoteDataSource: getIt<MealRemoteDataSource>()),
  );
  getIt.registerSingleton<GetRestaurantMealsUseCase>(
    GetRestaurantMealsUseCase(getIt<MealRepo>()),
  );
  getIt.registerSingleton<AddMealUseCase>(
    AddMealUseCase(getIt<MealRepo>()),
  );
  getIt.registerSingleton<UpdateMealUseCase>(
    UpdateMealUseCase(getIt<MealRepo>()),
  );
  getIt.registerSingleton<DeleteMealUseCase>(
    DeleteMealUseCase(getIt<MealRepo>()),
  );
  getIt.registerSingleton<UpdateRestaurantImageUseCase>(
    UpdateRestaurantImageUseCase(getIt<MealRepo>()),
  );

  // ── Order registration ──────────────────────────────────────────
  getIt.registerSingleton<OrderRemoteDataSource>(
    OrderRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerSingleton<OrderRepo>(
    OrderRepoImpl(remoteDataSource: getIt<OrderRemoteDataSource>()),
  );
  getIt.registerSingleton<GetOrdersUseCase>(
    GetOrdersUseCase(getIt<OrderRepo>()),
  );
  getIt.registerSingleton<UpdateOrderStatusUseCase>(
    UpdateOrderStatusUseCase(getIt<OrderRepo>()),
  );

  // ── Demand Prediction registration ────────────────────────────────
  getIt.registerSingleton<DemandRemoteDataSource>(
    DemandRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerSingleton<DemandRepository>(
    DemandRepositoryImpl(remoteDataSource: getIt<DemandRemoteDataSource>()),
  );
  getIt.registerSingleton<GetDemandDashboardUseCase>(
    GetDemandDashboardUseCase(getIt<DemandRepository>()),
  );
}