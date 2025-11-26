import 'package:eat2beat/screens/forget/change_password_screen.dart';
import 'package:eat2beat/screens/forget/forget_pass_screen.dart';
import 'package:eat2beat/screens/forget/new_password_screen.dart';
import 'package:eat2beat/screens/forget/otp_screen.dart';
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
      initialRoute: AppRoutes.loginRouteName,
      routes: {
        AppRoutes.loginRouteName: (_) => LoginScreen(),
        AppRoutes.registerRouteName: (_) => RegisterScreen(),
        AppRoutes.forgetRouteName: (_) => ForgetPassScreen(),
        AppRoutes.otpRouteName: (_) => OtpScreen(),
        AppRoutes.newPassRouteName: (_) => NewPasswordScreen(),
        AppRoutes.changePassRouteName: (_) => ChangePasswordScreen(),
      },
    );
  }
}
