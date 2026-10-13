import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/features/settings/data/drift_settings_repository.dart';

void main() {
  group('Startup & Navigation Performance Benchmarks', () {
    test(
      'measures 20 cold and 20 warm initialization latencies on host',
      () async {
        final coldLatenciesMs = <int>[];
        final warmLatenciesMs = <int>[];

        // 20 Cold launches (instantiating database, opening connection, reading singleton)
        for (var i = 0; i < 20; i++) {
          final stopwatch = Stopwatch()..start();
          final db = AppDatabase(NativeDatabase.memory());
          final repo = DriftSettingsRepository(db);
          final settings = await repo.load();
          stopwatch.stop();

          expect(settings.id, equals(1));
          coldLatenciesMs.add(stopwatch.elapsedMilliseconds);
          await db.close();
        }

        // 20 Warm launches (reading from an already warm connection)
        final warmDb = AppDatabase(NativeDatabase.memory());
        final warmRepo = DriftSettingsRepository(warmDb);
        await warmRepo.load(); // Warm-up run

        for (var i = 0; i < 20; i++) {
          final stopwatch = Stopwatch()..start();
          final settings = await warmRepo.load();
          stopwatch.stop();

          expect(settings.id, equals(1));
          warmLatenciesMs.add(stopwatch.elapsedMilliseconds);
        }
        await warmDb.close();

        // Assert latency boundaries
        for (final latency in coldLatenciesMs) {
          expect(
            latency,
            lessThan(3000),
            reason: 'Cold launch must be under 3000ms',
          );
        }
        for (final latency in warmLatenciesMs) {
          expect(
            latency,
            lessThan(2000),
            reason: 'Warm launch must be under 2000ms',
          );
        }
      },
    );
  });
}
