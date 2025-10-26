import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';

class Typography {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Palette.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Palette.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Palette.textPrimary,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Palette.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Palette.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Palette.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Palette.textSecondary,
  );

  // Special Text Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Palette.textTertiary,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    color: Palette.textTertiary,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Button Text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Palette.textOnPrimary,
  );

  // App Bar Title
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Palette.textPrimary,
  );

  // Card Title
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Palette.textPrimary,
  );

  // Subtitle
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Palette.textSecondary,
  );
}
