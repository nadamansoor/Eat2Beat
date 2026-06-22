import 'package:eat2beat/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eat2beat/core/services/shared_pref_singleton.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:eat2beat/core/utils/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final bool onboardingShown = Prefs.getBool('onboarding_shown');
      if (!onboardingShown) {
        Navigator.pushReplacementNamed(context, AppRoutes.OnboardingRouteName);
      } else {
        final profile = UserProfileNotifier();
        if (profile.currentUId.isNotEmpty) {
          String route = AppRoutes.homeRouteName;
          if (profile.role == 'admin') {
            route = AppRoutes.adminRouteName;
          } else if (profile.role == 'charity') {
            route = AppRoutes.charityRouteName;
          }
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8468ff),
              Color(0xFF8468ff),

            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                Assets.imagesSplash,
                
                width: 160,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}