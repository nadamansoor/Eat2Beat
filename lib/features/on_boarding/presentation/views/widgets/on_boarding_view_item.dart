import 'package:flutter/material.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: screenHeight * 0.35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Pattern.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              Container(
                height: screenHeight * 0.36,
                margin: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
              ),
              const Spacer(),
              SizedBox(height: screenHeight * 0.11),
            ],
          ),
        ),
      ],
    );
  }
}