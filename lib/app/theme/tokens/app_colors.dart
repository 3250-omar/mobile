import 'package:flutter/material.dart';

/// Semantic color tokens for light and dark themes adhering to WCAG 4.5:1 text
/// and 3.0:1 control contrast requirements.
abstract class AppColors {
  // Light Tokens
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF020617);
  static const Color lightPrimary = Color(0xFF0F172A);
  static const Color lightAction = Color(0xFF0369A1);
  static const Color lightOnAction = Color(0xFFFFFFFF);
  static const Color lightMutedText = Color(0xFF475569);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightError = Color(0xFFB91C1C);

  // Dark Tokens
  static const Color darkBackground = Color(0xFF020617);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkPrimary = Color(0xFFE2E8F0);
  static const Color darkAction = Color(0xFF38BDF8);
  static const Color darkOnAction = Color(0xFF082F49);
  static const Color darkMutedText = Color(0xFFCBD5E1);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkError = Color(0xFFFCA5A5);
}
