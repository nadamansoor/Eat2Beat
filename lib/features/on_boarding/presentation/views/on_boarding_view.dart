import 'package:eat2beat/features/on_boarding/presentation/views/widgets/on_boarding_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  static const String routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return const Scaffold(
      backgroundColor: Color(0xFFF9F7FF),
      body: OnBoardingViewBody(),     
    );
  }
}