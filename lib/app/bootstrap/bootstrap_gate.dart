import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/diagnostics/diagnostic_reference_view.dart';
import '../../l10n/app_localizations.dart';
import 'initialization_state.dart';
import 'providers.dart';

/// Gate widget displaying an Arabic loading or non-destructive error recovery screen
/// before releasing the interactive application shell upon readiness.
class BootstrapGate extends ConsumerWidget {
  const BootstrapGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = ref.watch(initializationControllerProvider);
    final l10n = AppLocalizations.of(context);

    if (initState.isReady) {
      return child;
    }

    if (initState is InitializationFailed) {
      final failure = initState.failure;
      final errorMessage = _resolveLocalizedErrorMessage(
        l10n,
        failure.messageKey,
      );

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFB91C1C),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.bootstrapFailureTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF475569)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (failure.diagnosticReference != null) ...[
                      DiagnosticReferenceView(
                        diagnosticReference: failure.diagnosticReference!,
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (failure.retryable) ...[
                      ElevatedButton.icon(
                        key: const Key('bootstrap_retry_button'),
                        onPressed: () {
                          ref
                              .read(initializationControllerProvider.notifier)
                              .retry();
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.bootstrapRetry),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(160, 48),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Initializing state
    final stageText = initState is Initializing
        ? _resolveStageText(l10n, initState.stage)
        : l10n.bootstrapInitializing;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    stageText,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveLocalizedErrorMessage(AppLocalizations l10n, String key) {
    switch (key) {
      case 'errorDatabase':
        return l10n.errorDatabase;
      case 'errorMigration':
        return l10n.errorMigration;
      case 'errorStorageProtection':
        return l10n.errorStorageProtection;
      case 'errorConfig':
        return l10n.errorConfig;
      case 'errorNewerSchema':
        return l10n.errorNewerSchema;
      default:
        return l10n.errorGeneric;
    }
  }

  String _resolveStageText(AppLocalizations l10n, InitializationStage stage) {
    switch (stage) {
      case InitializationStage.configuration:
        return l10n.bootstrapStageConfig;
      case InitializationStage.diagnostics:
        return l10n.bootstrapStageDiagnostics;
      case InitializationStage.storagePath:
        return l10n.bootstrapStageStoragePath;
      case InitializationStage.database:
        return l10n.bootstrapStageDatabase;
      case InitializationStage.migration:
        return l10n.bootstrapStageMigration;
      case InitializationStage.settings:
        return l10n.bootstrapStageSettings;
      case InitializationStage.composition:
        return l10n.bootstrapStageComposition;
    }
  }
}
