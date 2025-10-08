
import 'package:flutter/material.dart';
import 'package:jobarchy_flutter_app/features/auth/presentation/views/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Find Genuine Jobs",
      "subtitle":
          "We filter out fake posts, showing only verified job opportunities.",
      "image": "images/onboarding3.jpeg",
    },
    {
      "title": "Smart Notifications",
      "subtitle": "Get notified instantly for jobs that match your skills.",
      "image": "images/onboarding9.jpeg",
    },
    {
      "title": "Apply & Grow",
      "subtitle": "Apply easily and track your career growth in one place.",
      "image": "images/onboarding7.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            image: onboardingData[index]['image']!,
            title: onboardingData[index]['title']!,
            subtitle: onboardingData[index]['subtitle']!,
          );
        },
      ),
      bottomSheet: currentPage == onboardingData.length - 1
          ? GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupScreen()));
              },
              child: Container(
                height: 60,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(onboardingData.length - 1);
                    },
                    child: const Text("Skip", style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (i) => buildDot(i, context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Text("Next",style: TextStyle(color: Colors.white))
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 5,
      width: currentPage == index ? 30 : 30,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: currentPage == index ? Colors.deepOrange : Colors.white,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(image),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
