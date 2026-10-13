import 'package:flutter/material.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_shapes.dart';
import 'tokens/app_spacing.dart';
import 'tokens/app_typography.dart';

/// Application theme definitions for light and dark modes.
abstract class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = AppTypography.createTextTheme(AppColors.lightText);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightSurface,
        secondary: AppColors.lightAction,
        onSecondary: AppColors.lightOnAction,
        error: AppColors.lightError,
        onError: AppColors.lightSurface,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.roundedMd,
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightAction, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightError),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: AppColors.lightAction,
          foregroundColor: AppColors.lightOnAction,
          shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = AppTypography.createTextTheme(AppColors.darkText);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkAction,
        onSecondary: AppColors.darkOnAction,
        error: AppColors.darkError,
        onError: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.roundedMd,
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkAction, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: AppColors.darkAction,
          foregroundColor: AppColors.darkOnAction,
          shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
