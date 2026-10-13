import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_shapes.dart';
import '../../app/theme/tokens/app_spacing.dart';

/// Reusable application card widget with consistent border, elevation,
/// and padding.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin = const EdgeInsets.all(AppSpacing.sm),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderColor = theme.colorScheme.brightness == Brightness.light
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF334155);

    return Padding(
      padding: margin,
      child: Material(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.roundedMd,
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
