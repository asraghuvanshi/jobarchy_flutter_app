import 'package:flutter/material.dart';

class AppColors {
  // 🔹 Solid Colors
  static const Color primary = Color(0xFF6A1B9A); // Deep Purple
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color accent = Color(0xFF4CAF50); // Green
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color text = Color(0xFF212121); // Dark Text
  static const Color gray = Color(0xFF9E9E9E); // Medium Gray
  static const Color lightGray = Color(0xFFE0E0E0); // Light Gray
  static const Color black = Color(0xFF000000);


  static const Color skyBlue = Color(0xFF5EFCE8);
  static const Color skyBlueDark = Color(0xFF736EFE);
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

  static const LinearGradient appGradient = LinearGradient(
    colors: [Color.fromARGB(255, 0, 0, 0),  Color.fromRGBO(255, 87, 34, 1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
