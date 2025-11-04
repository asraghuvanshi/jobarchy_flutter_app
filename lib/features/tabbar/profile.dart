import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildOption(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const Icon(CupertinoIcons.chevron_forward,
                size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔮 Animated Gradient Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF1B2735),
                      Color(0xFF090A0F),
                      Color(0xFF1B2735),
                    ],
                    begin: Alignment(
                        _controller.value * 2 - 1, _controller.value * 2 - 1),
                    end: Alignment(
                        1 - _controller.value * 2, 1 - _controller.value * 2),
                  ),
                ),
              );
            },
          ),

          /// 🌌 Floating Particle Effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: ParticlePainter(_controller.value, _random),
                child: Container(),
              );
            },
          ),

          /// 🌈 Profile UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// Profile Image with Pulse Animation
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      double scale =
                          1 + 0.03 * sin(_controller.value * 2 * pi);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4ECDC4), Color(0xFF556270)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(3),
                          child: const CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                AssetImage('images/onboarding4.jpeg'),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Amit Singh Raghuvanshi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "amit@example.com",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  /// Profile Options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildOption(
                              CupertinoIcons.person, "Edit Profile", () {}),
                          buildOption(
                              CupertinoIcons.lock, "Change Password", () {}),
                          buildOption(
                              CupertinoIcons.settings, "Settings", () {}),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Logout Button at Bottom
                  buildOption(CupertinoIcons.square_arrow_right,
                      "Logout", () {}),

                  const SizedBox(height: 20),
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌟 Custom Painter for Animated Floating Particles
class ParticlePainter extends CustomPainter {
  final double animationValue;
  final Random random;
  final int particleCount = 25;

  ParticlePainter(this.animationValue, this.random);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);
    for (int i = 0; i < particleCount; i++) {
      final x = (size.width / particleCount) * i +
          sin(animationValue * 2 * pi + i) * 40;
      final y = (size.height / particleCount) * i +
          cos(animationValue * 2 * pi + i) * 30;
      final radius = 2 + random.nextDouble() * 2;
      canvas.drawCircle(Offset(x % size.width, y % size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
