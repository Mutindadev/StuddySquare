import 'package:flutter/material.dart';

class Palette {
  // Primary Colors
  static const Color primary = Color(0xFF6673FF);
  static const Color primaryLight = Color(0xFF9A4FF6);
  static const Color primaryDark = Color(0xFF4A5CCC);

  // Secondary Colors
  static const Color secondary = Color(0xFFFB8C00);
  static const Color secondaryLight = Color(0xFFFFBD4F);
  static const Color secondaryDark = Color(0xFFE67C00);

  // Background Colors
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F3F3);

  // Card and Container Colors
  static const Color cardBackground = Colors.white;
  static const Color containerLight = Color(0xFFEEF2FF);
  static const Color containerBlue = Color(0xFF6673FF);

  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Colors.grey;
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;
  static const Color info = Colors.blue;

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF6673FF), Color(0xFF9A4FF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static final Color shadowLight = Colors.black.withOpacity(0.03);
  static final Color shadowMedium = Colors.black.withOpacity(0.08);
  static final Color shadowDark = Colors.black.withOpacity(0.15);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF9E9E9E);

  // Special Colors for Features
  static const Color progressIndicator = primary;
  static const Color chipBackground = secondary;
  static const LinearGradient avatarBackground = primaryGradient;
}
