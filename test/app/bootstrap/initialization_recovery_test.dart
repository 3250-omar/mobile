import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/initialization_controller.dart';
import 'package:offline_quotes/app/bootstrap/initialization_state.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';

void main() {
  group('Initialization Recovery Tests', () {
    test('handles failure at any stage and allows successful retry', () async {
      var failCount = 0;
      final controller = InitializationController(
        onDatabase: () async {
          if (failCount == 0) {
            failCount++;
            throw const AppFailure(
              code: 'DB_OPEN_FAILED',
              messageKey: 'errorDatabase',
              category: AppFailureCategory.storage,
              retryable: true,
            );
          }
        },
      );

      // Attempt 1: Fails
      await controller.initialize();
      expect(controller.state, isA<InitializationFailed>());
      final failedState = controller.state as InitializationFailed;
      expect(failedState.failure.code, equals('DB_OPEN_FAILED'));
      expect(failedState.failure.retryable, isTrue);

      // Attempt 2: Retry succeeds
      await controller.retry();
      expect(controller.state, isA<InitializationReady>());
    });

    test('concurrent retries share single-flight execution', () async {
      var callCount = 0;
      final controller = InitializationController(
        onDatabase: () async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
      );

      final futures = [
        controller.initialize(),
        controller.retry(),
        controller.initialize(),
      ];

      await Future.wait(futures);
      expect(callCount, equals(1));
      expect(controller.state, isA<InitializationReady>());
    });
  });
}
