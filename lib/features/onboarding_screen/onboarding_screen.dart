import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Find Genuine Jobs",
      "subtitle": "We filter out fake posts, showing only verified job opportunities.",
      "image": "images/onboarding3.jpeg",
      // "lottie": "assets/lottie/job_search.json", // Uncomment for Lottie
    },
    {
      "title": "Smart Notifications",
      "subtitle": "Get notified instantly for jobs that match your skills.",
      "image": "images/onboarding9.jpeg",
      // "lottie": "assets/lottie/notifications.json",
    },
    {
      "title": "Apply & Grow",
      "subtitle": "Apply easily and track your career growth in one place.",
      "image": "images/onboarding7.jpeg",
      // "lottie": "assets/lottie/career_growth.json",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1B2735),
              Color(0xFF090A0F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // PageView for onboarding screens
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingData[index]['title']!,
                  subtitle: onboardingData[index]['subtitle']!,
                  image: onboardingData[index]['image']!,
                  // lottie: onboardingData[index]['lottie'], // Uncomment for Lottie
                );
              },
            ),
            // Skip button
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Bottom section with dots and button
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingData.length,
                    effect: WormEffect(
                      dotColor: Colors.white.withOpacity(0.3),
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Next/Get Started button
                  GestureDetector(
                    onTapDown: (_) => _animationController.forward(),
                    onTapUp: (_) => _animationController.reverse(),
                    onTap: () {
                      if (_currentPage < onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentPage < onboardingData.length - 1 ? 'Next' : 'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B2735),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  // final String? lottie; // Uncomment for Lottie

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.image,
    // this.lottie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image or Lottie animation
        Expanded(
          flex: 3,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              child: 
                  // lottie != null
                  //     ? Lottie.asset(
                  //         lottie!,
                  //         fit: BoxFit.cover,
                  //         width: double.infinity,
                  //       )
                  //     : 
                      Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
            ),
          ),
        ),
        // Title and subtitle
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSlide(
                  offset: Offset(0, 0),
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15),
                AnimatedSlide(
                  offset: Offset(0, 0),
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  child: Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}