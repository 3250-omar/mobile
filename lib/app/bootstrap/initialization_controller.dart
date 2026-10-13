import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../core/errors/failure_mapper.dart';
import '../../features/settings/domain/app_settings.dart';
import 'initialization_state.dart';

typedef BootstrapStageAction = Future<void> Function();
typedef LoadSettingsAction = Future<AppSettings> Function();

/// Single-flight controller managing application initialization and recovery.
class InitializationController
    extends StateNotifier<ApplicationInitializationState> {
  InitializationController({
    this.onConfig,
    this.onDiagnostics,
    this.onStoragePath,
    this.onDatabase,
    this.onMigration,
    this.onLoadSettings,
    this.onComposition,
  }) : super(const ApplicationInitializationState.notStarted());

  final BootstrapStageAction? onConfig;
  final BootstrapStageAction? onDiagnostics;
  final BootstrapStageAction? onStoragePath;
  final BootstrapStageAction? onDatabase;
  final BootstrapStageAction? onMigration;
  final LoadSettingsAction? onLoadSettings;
  final BootstrapStageAction? onComposition;

  Future<void>? _inFlightFuture;
  int _attemptCounter = 0;

  /// Starts or returns the in-flight initialization attempt.
  ///
  /// Guaranteed to be idempotent and single-flight.
  Future<void> initialize() {
    if (_inFlightFuture != null) {
      return _inFlightFuture!;
    }

    if (state.isReady) {
      return Future<void>.value();
    }

    _attemptCounter++;
    final attemptId =
        'ATTEMPT_${DateTime.now().millisecondsSinceEpoch}_$_attemptCounter';

    _inFlightFuture = _runPipeline(attemptId);
    return _inFlightFuture!;
  }

  Future<void> _runPipeline(String attemptId) async {
    final startTime = DateTime.now();

    try {
      // Stage 1: Configuration
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.configuration,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onConfig != null) await onConfig!();

      // Stage 2: Diagnostics
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.diagnostics,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onDiagnostics != null) await onDiagnostics!();

      // Stage 3: Storage Path and Platform Protection
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.storagePath,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onStoragePath != null) await onStoragePath!();

      // Stage 4: Database Open
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.database,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onDatabase != null) await onDatabase!();

      // Stage 5: Database Migration
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.migration,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onMigration != null) await onMigration!();

      // Stage 6: Settings Load
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.settings,
        attemptId: attemptId,
        startTime: startTime,
      );
      final settings = onLoadSettings != null
          ? await onLoadSettings!()
          : AppSettings.defaults();

      // Stage 7: App Composition
      state = ApplicationInitializationState.initializing(
        stage: InitializationStage.composition,
        attemptId: attemptId,
        startTime: startTime,
      );
      if (onComposition != null) await onComposition!();

      // Transition to Ready
      state = ApplicationInitializationState.ready(settings: settings);
    } catch (e, st) {
      final failure = FailureMapper.map(
        e,
        stackTrace: st,
        diagnosticReference: attemptId,
      );
      state = ApplicationInitializationState.failed(
        failure: failure,
        attemptId: attemptId,
      );
    } finally {
      _inFlightFuture = null;
    }
  }

  /// Triggers a non-destructive retry from a failed state.
  Future<void> retry() async {
    if (_inFlightFuture != null) {
      return _inFlightFuture!;
    }
    return initialize();
  }
}
