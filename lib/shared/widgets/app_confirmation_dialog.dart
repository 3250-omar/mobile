import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_shapes.dart';
import '../../app/theme/tokens/app_spacing.dart';
import 'app_button.dart';

/// Reusable application confirmation dialog with distinct confirm and cancel
/// actions and non-destructive back handling.
class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedLg),
      title: Text(title),
      content: Text(message),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      actions: [
        AppButton(
          label: cancelLabel,
          isSecondary: true,
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
        const SizedBox(width: AppSpacing.xs),
        AppButton(
          label: confirmLabel,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
        ),
      ],
    );
  }
}
