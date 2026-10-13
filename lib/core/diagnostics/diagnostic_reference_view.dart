import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/tokens/app_shapes.dart';
import '../../app/theme/tokens/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Accessible view allowing the user to inspect and copy a stable diagnostic reference code
/// without exposing raw SQL, paths, stack traces, or customer data.
class DiagnosticReferenceView extends StatelessWidget {
  const DiagnosticReferenceView({super.key, required this.diagnosticReference});

  final String diagnosticReference;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.brightness == Brightness.light
            ? const Color(0xFFF1F5F9)
            : const Color(0xFF1E293B),
        borderRadius: AppShapes.roundedMd,
        border: Border.all(
          color: theme.colorScheme.brightness == Brightness.light
              ? const Color(0xFFCBD5E1)
              : const Color(0xFF475569),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.codeDiagnosticRef(diagnosticReference),
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            tooltip: l10n.bootstrapCopyDiagnostics,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: diagnosticReference));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.bootstrapDiagnosticsCopied)),
              );
            },
          ),
        ],
      ),
    );
  }
}
