import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A237E),
      Color(0xFF7B1FA2),
    ],
  );

  static const LinearGradient appGradient =  LinearGradient(
      colors: [
        Color(0xFFFD1D1D),
        Color(0xFF1A1717),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
}