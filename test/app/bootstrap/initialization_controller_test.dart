import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/initialization_controller.dart';
import 'package:offline_quotes/app/bootstrap/initialization_state.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';

void main() {
  group('InitializationController', () {
    test('initial state is notStarted', () {
      final controller = InitializationController();
      expect(controller.state, isA<InitializationNotStarted>());
    });

    test(
      'transitions sequentially through stages to ready on success',
      () async {
        final recordedStages = <InitializationStage>[];
        final controller = InitializationController(
          onConfig: () async =>
              recordedStages.add(InitializationStage.configuration),
          onDiagnostics: () async =>
              recordedStages.add(InitializationStage.diagnostics),
          onStoragePath: () async =>
              recordedStages.add(InitializationStage.storagePath),
          onDatabase: () async =>
              recordedStages.add(InitializationStage.database),
          onMigration: () async =>
              recordedStages.add(InitializationStage.migration),
          onLoadSettings: () async {
            recordedStages.add(InitializationStage.settings);
            return AppSettings.defaults();
          },
          onComposition: () async =>
              recordedStages.add(InitializationStage.composition),
        );

        await controller.initialize();

        expect(recordedStages, <InitializationStage>[
          InitializationStage.configuration,
          InitializationStage.diagnostics,
          InitializationStage.storagePath,
          InitializationStage.database,
          InitializationStage.migration,
          InitializationStage.settings,
          InitializationStage.composition,
        ]);
        expect(controller.state, isA<InitializationReady>());
        final ready = controller.state as InitializationReady;
        expect(ready.settings.localeTag, 'ar');
        expect(ready.settings.themeMode, 'system');
      },
    );

    test(
      'transitions to failed with safe AppFailure on stage exception',
      () async {
        final controller = InitializationController(
          onDatabase: () async => throw Exception('database is locked'),
        );

        await controller.initialize();

        expect(controller.state, isA<InitializationFailed>());
        final failed = controller.state as InitializationFailed;
        expect(failed.failure.code, 'DB_OPEN_FAILED');
        expect(failed.failure.retryable, isTrue);
        expect(failed.attemptId, isNotEmpty);
        expect(failed.failure.diagnosticReference, failed.attemptId);
      },
    );

    test('concurrent initialize calls share single-flight execution', () async {
      var configRuns = 0;
      final controller = InitializationController(
        onConfig: () async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          configRuns++;
        },
      );

      final future1 = controller.initialize();
      final future2 = controller.initialize();
      await Future.wait([future1, future2]);

      expect(configRuns, 1);
      expect(controller.state, isA<InitializationReady>());
    });

    test('retry creates a new attempt ID and re-executes', () async {
      var failOnce = true;
      String? firstAttemptId;

      final controller = InitializationController(
        onDatabase: () async {
          if (failOnce) {
            failOnce = false;
            throw Exception('temporary failure');
          }
        },
      );

      await controller.initialize();
      expect(controller.state, isA<InitializationFailed>());
      firstAttemptId = (controller.state as InitializationFailed).attemptId;
      expect(firstAttemptId, isNotEmpty);

      await controller.retry();
      expect(controller.state, isA<InitializationReady>());
    });
  });
}
