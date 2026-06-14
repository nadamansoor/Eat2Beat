import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'on_boarding_page_view.dart';
import 'on_boarding_view_item.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PageViewItem> pages = const [
    PageViewItem(
      image: Assets.imagesIllustration,
      title: "Turn Leftovers into\nOpportunities",
      description:
          "Together, we can make a real impact.\n"
          "Turning leftover food into meaningful meals\n"
          "that feed people, not landfills.",
    ),
    PageViewItem(
      image: Assets.imagesOnboarding2,
      title: "Save Meal ,Save Money",
      description:
          "Enjoy delicious meals at a lower price while\n"
          "helping restaurants reduce food waste ,\n"
          "It's a win win.",
    ),
    PageViewItem(
      image: Assets.imagesOnboarding3,
      title: "Feed Hearts, Not Waste",
      description:
          "Reduce food waste by connecting surplus\n"
          "meals with charities  every act of giving\n"
          "brings hope to someone's day.",
    ),
  ];

  void _onSkipPressed() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkipPressed();
    }
  }

  Widget _dot(bool active) {
    return Container(
      height: 8,
      width: active ? 18 : 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C63FF) : Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnBoardingPageView(
          pageController: _pageController,
          pages: pages,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              color: const Color(0xFFF9F7FF),
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _onSkipPressed,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _dot(0 == _currentPage),
                        const SizedBox(width: 6),
                        _dot(1 == _currentPage),
                        const SizedBox(width: 6),
                        _dot(2 == _currentPage),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF8468ff),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: _onNextPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}