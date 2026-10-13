import 'package:flutter/material.dart';

import '../../app/localization/bidi_text.dart';
import '../../app/theme/tokens/app_spacing.dart';

/// Reusable application text field supporting label, hints, validation,
/// bidi isolation, and touch target accessibility.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.onChanged,
    this.isBidiIsolated = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isBidiIsolated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            isBidiIsolated ? BidiText.wrapLtr(label!) : label!,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
