import 'package:flutter/material.dart';
import 'on_boarding_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.pages,
    required this.onPageChanged,
  });

  final PageController pageController;
  final List<PageViewItem> pages;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) => pages[index],
    );
  }
}