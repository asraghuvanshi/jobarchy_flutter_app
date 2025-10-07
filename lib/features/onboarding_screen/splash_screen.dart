
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobarchy_flutter_app/features/onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutBack,
          child: Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                "images/app_icon.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}