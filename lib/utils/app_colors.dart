import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5B5FEF);
  static const Color background = Color(0xFFF7F7FC);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF20213A);
  static const Color secondaryText = Color(0xFF77788C);
  static const Color success = Color(0xFF27AE60);
  static const Color danger = Color(0xFFE74C3C);

  static Color priorityColor(String priority) {
    switch (priority) {
      case 'Haute':
        return danger;
      case 'Basse':
        return success;
      default:
        return primary;
    }
  }
}
