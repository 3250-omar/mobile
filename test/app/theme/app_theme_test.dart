import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/theme/app_theme.dart';
import 'package:offline_quotes/app/theme/tokens/app_colors.dart';
import 'package:offline_quotes/app/theme/tokens/app_spacing.dart';

void main() {
  double contrastRatio(Color c1, Color c2) {
    final l1 = c1.computeLuminance();
    final l2 = c2.computeLuminance();
    final brighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    return (brighter + 0.05) / (darker + 0.05);
  }

  group('AppTheme & Tokens', () {
    test('light colors meet minimum contrast requirements', () {
      // 4.5:1 for normal text against background/surface
      final textOnBg = contrastRatio(
        AppColors.lightText,
        AppColors.lightBackground,
      );
      final textOnSurface = contrastRatio(
        AppColors.lightText,
        AppColors.lightSurface,
      );
      final actionOnSurface = contrastRatio(
        AppColors.lightAction,
        AppColors.lightSurface,
      );
      final onAction = contrastRatio(
        AppColors.lightOnAction,
        AppColors.lightAction,
      );

      expect(textOnBg, greaterThanOrEqualTo(4.5));
      expect(textOnSurface, greaterThanOrEqualTo(4.5));
      expect(actionOnSurface, greaterThanOrEqualTo(3.0));
      expect(onAction, greaterThanOrEqualTo(4.5));
    });

    test('dark colors meet minimum contrast requirements', () {
      final textOnBg = contrastRatio(
        AppColors.darkText,
        AppColors.darkBackground,
      );
      final textOnSurface = contrastRatio(
        AppColors.darkText,
        AppColors.darkSurface,
      );
      final actionOnSurface = contrastRatio(
        AppColors.darkAction,
        AppColors.darkSurface,
      );
      final onAction = contrastRatio(
        AppColors.darkOnAction,
        AppColors.darkAction,
      );

      expect(textOnBg, greaterThanOrEqualTo(4.5));
      expect(textOnSurface, greaterThanOrEqualTo(4.5));
      expect(actionOnSurface, greaterThanOrEqualTo(3.0));
      expect(onAction, greaterThanOrEqualTo(4.5));
    });

    test('spacing adheres to 4/8-point rhythm', () {
      expect(AppSpacing.xs % 4, equals(0));
      expect(AppSpacing.sm % 8, equals(0));
      expect(AppSpacing.md % 8, equals(0));
      expect(AppSpacing.lg % 8, equals(0));
      expect(AppSpacing.xl % 8, equals(0));
    });

    test(
      'builds light and dark ThemeData with Noto Sans Arabic typography',
      () {
        final lightTheme = AppTheme.lightTheme;
        final darkTheme = AppTheme.darkTheme;

        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(
          lightTheme.textTheme.bodyMedium?.fontFamily,
          contains('Noto Sans Arabic'),
        );
        expect(
          darkTheme.textTheme.bodyMedium?.fontFamily,
          contains('Noto Sans Arabic'),
        );
      },
    );
  });
}
