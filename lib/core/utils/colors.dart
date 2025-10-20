import 'package:flutter/material.dart';

class AppColors {
  // 🔹 Solid Colors
  static const Color primary = Color(0xFF6A1B9A); // Deep Purple
  static const Color accent = Color(0xFF4CAF50); // Green
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color text = Color(0xFF212121); // Dark Text
  static const Color gray = Color(0xFF9E9E9E); // Medium Gray
  static const Color lightGray = Color(0xFFE0E0E0); // Light Gray
  static const Color black = Color(0xFF000000);


  static const orangeColor =  Color(0xFFFF6700);

  static const LinearGradient appGradient =  LinearGradient(
      colors: [
        Color(0xFFFF6700),
        Color(0xFF1A1717),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

  //  Gradients
  static const LinearGradient purpleOrangeGradient = LinearGradient(
    colors: [Color(0xFF6A1B9A), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bluePurpleGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF9C27B0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );


}
