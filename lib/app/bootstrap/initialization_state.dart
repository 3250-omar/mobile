import '../../core/errors/app_failure.dart';
import '../../features/settings/domain/app_settings.dart';

/// Sequential stages of the application bootstrap pipeline.
enum InitializationStage {
  configuration,
  diagnostics,
  storagePath,
  database,
  migration,
  settings,
  composition,
}

/// Immutable in-memory state of the application startup lifecycle.
sealed class ApplicationInitializationState {
  const ApplicationInitializationState();

  const factory ApplicationInitializationState.notStarted() =
      InitializationNotStarted;

  const factory ApplicationInitializationState.initializing({
    required InitializationStage stage,
    required String attemptId,
    required DateTime startTime,
  }) = Initializing;

  const factory ApplicationInitializationState.ready({
    required AppSettings settings,
  }) = InitializationReady;

  const factory ApplicationInitializationState.failed({
    required AppFailure failure,
    required String attemptId,
  }) = InitializationFailed;

  bool get isReady => this is InitializationReady;
  bool get isFailed => this is InitializationFailed;
  bool get isInitializing => this is Initializing;
}

class InitializationNotStarted extends ApplicationInitializationState {
  const InitializationNotStarted();
}

class Initializing extends ApplicationInitializationState {
  const Initializing({
    required this.stage,
    required this.attemptId,
    required this.startTime,
  });

  final InitializationStage stage;
  final String attemptId;
  final DateTime startTime;

  @override
  String toString() => 'Initializing(stage: $stage, attemptId: $attemptId)';
}

class InitializationReady extends ApplicationInitializationState {
  const InitializationReady({required this.settings});

  final AppSettings settings;

  @override
  String toString() => 'InitializationReady(settings: $settings)';
}

class InitializationFailed extends ApplicationInitializationState {
  const InitializationFailed({required this.failure, required this.attemptId});

  final AppFailure failure;
  final String attemptId;

  @override
  String toString() =>
      'InitializationFailed(failure: $failure, attemptId: $attemptId)';
}
