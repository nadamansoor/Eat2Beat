import 'package:eat2beat/views/home_view.dart';
import 'package:flutter/material.dart';
import 'onboarding_view1.dart';
import 'onboarding_view2.dart';
import 'onboarding_view3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onSkipPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FF),
      body: SafeArea( 
        child: Stack(
          children: [
   
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: const [
                OnboardingView1(),
                OnboardingView2(),
                OnboardingView3(),
              ],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0, 
              child: Container(
                color: Color(0xFFF9F7FF), 
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
                          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                          onPressed: _onNextPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}