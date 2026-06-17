import 'package:bloc/bloc.dart';
import 'package:eat2beat/core/services/Custom_bloc_observer.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/features/admin/presentation/view/admin.dart';
import 'package:eat2beat/features/auth/presentation/views/forget/change_password_screen.dart';
import 'package:eat2beat/features/auth/presentation/views/forget/forget_pass_screen.dart';
import 'package:eat2beat/features/auth/presentation/views/forget/new_password_screen.dart';
import 'package:eat2beat/features/auth/presentation/views/forget/otp_screen.dart';
import 'package:eat2beat/features/auth/presentation/views/pending_restaurant_screen.dart';
import 'package:eat2beat/features/auth/presentation/views/sign_in_view.dart';
import 'package:eat2beat/features/auth/presentation/views/sign_up_view.dart';

import 'package:eat2beat/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:eat2beat/features/screens/home/home_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/cart_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/donation/choose_donate.dart';
import 'package:eat2beat/features/screens/home/tabs/donation/details_donation.dart';
import 'package:eat2beat/features/screens/home/tabs/order_history/order_history_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/home_tab/details_screen.dart';
import 'package:eat2beat/features/screens/home/tabs/offers/offers_tab.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/profile_screen.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/features/splash/presenation/views/spalsh_view.dart';
import 'package:eat2beat/firebase_options.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/services/language_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // await Prefs.init();
  await UserProfileNotifier().init();
  await ThemeNotifier().init();
  await LanguageNotifier().init();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        final isDark = ThemeNotifier().isDarkMode;
        return ListenableBuilder(
          listenable: LanguageNotifier(),
          builder: (context, child) {
            final locale = LanguageNotifier().locale;
            return MaterialApp(
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                fontFamily: 'Cairo',
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.purple,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                fontFamily: 'Cairo',
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xff8966FA),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.purple,
                  brightness: Brightness.dark,
                ),
              ),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: locale,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            ThemeNavigatorObserver(),
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.15,
                ),
              ),
              child: child!,
            );
          },
          initialRoute: AppRoutes.SplashRouteName,
          routes: {
            AppRoutes.SplashRouteName: (_) => SplashView(),
            AppRoutes.OnboardingRouteName: (_) => OnBoardingView(),
            AppRoutes.loginRouteName: (_) => SignInView(),
            SignUpView.routeName: (context) => SignUpView(),
            AppRoutes.registerRouteName: (_) => SignUpView(),
            AppRoutes.forgetRouteName: (_) => ForgetPassScreen(),
            AppRoutes.otpRouteName: (_) => OtpScreen(),
            AppRoutes.newPassRouteName: (_) => NewPasswordScreen(),
            AppRoutes.changePassRouteName: (_) => ChangePasswordScreen(),
            AppRoutes.homeScreenRouteName: (_) => HomeScreen(),
            AppRoutes.homeRouteName: (_) => HomeScreen(),
            AppRoutes.offersRouteName: (_) => OffersTab(),
            AppRoutes.donationRouteName: (_) => const OrderHistoryTab(),
            AppRoutes.cartRouteName: (_) => CartScreen(),
            AppRoutes.detailDonationRouteName: (_) => DetailsDonation(),
            AppRoutes.chooseDonateRouteName: (_) => ChooseDonate(),
            AppRoutes.detailsRouteName: (_) => DetailsScreen(),
            AppRoutes.profileRouteName: (context) => const ProfileScreen(),
            AppRoutes.adminRouteName: (_) => const AdminRouteName(),
            AppRoutes.pendingRestaurantRouteName: (_) => const PendingRestaurantScreen(),
          },
        );
          },
        );
      },
    );
  }
}

class ThemeNavigatorObserver extends NavigatorObserver {
  void _updateTheme(Route<dynamic>? route) {
    if (route == null) return;
    final name = route.settings.name;
    if (name == null) return;

    final lightModeRoutes = {
      AppRoutes.SplashRouteName,
      AppRoutes.OnboardingRouteName,
      AppRoutes.loginRouteName,
      SignUpView.routeName,
      AppRoutes.registerRouteName,
      AppRoutes.forgetRouteName,
      AppRoutes.otpRouteName,
      AppRoutes.newPassRouteName,
      AppRoutes.changePassRouteName,
      AppRoutes.pendingRestaurantRouteName,
    };

    if (lightModeRoutes.contains(name)) {
      ThemeNotifier().forceLightMode = true;
    } else {
      ThemeNotifier().forceLightMode = false;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateTheme(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateTheme(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateTheme(newRoute);
  }
}
