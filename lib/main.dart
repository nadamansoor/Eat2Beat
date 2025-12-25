import 'package:eat2beat/screens/forget/change_password_screen.dart';
import 'package:eat2beat/screens/forget/forget_pass_screen.dart';
import 'package:eat2beat/screens/forget/new_password_screen.dart';
import 'package:eat2beat/screens/forget/otp_screen.dart';
import 'package:eat2beat/screens/home/home_screen.dart';
import 'package:eat2beat/screens/home/tabs/cart/cart_tab.dart';
import 'package:eat2beat/screens/home/tabs/donation/choose_donate.dart';
import 'package:eat2beat/screens/home/tabs/donation/details_donation.dart';
import 'package:eat2beat/screens/home/tabs/donation/donation_tab.dart';
import 'package:eat2beat/screens/home/tabs/home_tab/details_screen.dart';
import 'package:eat2beat/screens/home/tabs/home_tab/home_tab.dart';
import 'package:eat2beat/screens/home/tabs/impact/impact_tab.dart';
import 'package:eat2beat/screens/home/tabs/offers/offers_tab.dart';
import 'package:eat2beat/screens/login/login_screen.dart';
import 'package:eat2beat/screens/register/register_screen.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homeScreenRouteName,
      routes: {
        AppRoutes.loginRouteName: (_) => LoginScreen(),
        AppRoutes.registerRouteName: (_) => RegisterScreen(),
        AppRoutes.forgetRouteName: (_) => ForgetPassScreen(),
        AppRoutes.otpRouteName: (_) => OtpScreen(),
        AppRoutes.newPassRouteName: (_) => NewPasswordScreen(),
        AppRoutes.changePassRouteName: (_) => ChangePasswordScreen(),
        AppRoutes.homeScreenRouteName: (_) => HomeScreen(),
        AppRoutes.homeRouteName: (_) => HomeTab(),
        AppRoutes.offersRouteName: (_) => OffersTab(),
        AppRoutes.impactRouteName: (_) => ImpactTab(),
        AppRoutes.donationRouteName: (_) => DonationTab(),
        AppRoutes.cartRouteName: (_) => CartScreen(),
        AppRoutes.detailDonationRouteName: (_) => DetailsDonation(),
        AppRoutes.chooseDonateRouteName: (_) => ChooseDonate(),
        AppRoutes.detailsRouteName: (_) => DetailsScreen(),
      },
    );
  }
}
