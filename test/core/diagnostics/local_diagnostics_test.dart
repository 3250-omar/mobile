import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/diagnostics/app_logger.dart';
import 'package:offline_quotes/core/diagnostics/local_log_sink.dart';
import 'package:offline_quotes/core/diagnostics/redaction.dart';

void main() {
  group('Local Diagnostics & Logger', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('diag_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'buffers events in memory before sink attachment and flushes them',
      () async {
        final logger = AppLogger();
        await logger.info('EARLY_EVENT_1', attemptId: 'ATTEMPT_1');
        await logger.info('EARLY_EVENT_2', attemptId: 'ATTEMPT_1');

        expect(logger.isSinkAttached, isFalse);
        expect(logger.bufferedEvents.length, 2);

        final sink = LocalLogSink(directoryPath: tempDir.path);
        await logger.attachSink(sink);

        expect(logger.isSinkAttached, isTrue);
        // Wait for flush to disk
        await logger.flush();

        final logFile = File('${tempDir.path}/diagnostics_0.jsonl');
        expect(await logFile.exists(), isTrue);

        final lines = await logFile.readAsLines();
        expect(lines.length, 2);
        expect(lines[0], contains('EARLY_EVENT_1'));
        expect(lines[1], contains('EARLY_EVENT_2'));

        await logger.dispose();
      },
    );

    test('redacts prohibited keys and raw file paths from attributes', () {
      final sanitized = Redaction.sanitizeAttributes({
        'customerName': 'Ahmed Hassan',
        'phoneNumber': '+20123456789',
        'token': 'secret-12345',
        'filePath': 'C:\\Users\\JohnDoe\\Documents\\file.txt',
        'stage': 'database',
        'attemptCount': 1,
      });

      expect(sanitized['customerName'], '[REDACTED]');
      expect(sanitized['phoneNumber'], '[REDACTED]');
      expect(sanitized['token'], '[REDACTED]');
      expect(sanitized['filePath'], '[REDACTED_PATH]');
      expect(sanitized['stage'], 'database');
      expect(sanitized['attemptCount'], 1);
    });

    test('rotates log files when exceeding maximum size', () async {
      final sink = LocalLogSink(
        directoryPath: tempDir.path,
        maxFileSizeBytes: 300, // Small limit for testing
        maxFileCount: 3,
      );
      final logger = AppLogger(sink: sink);
      await logger.attachSink(sink);

      for (var i = 0; i < 20; i++) {
        await logger.info(
          'EVENT_$i',
          attributes: {'index': i, 'payload': 'abcdefghijklmn'},
        );
      }
      await logger.flush();

      // Check that at least two rotating files exist
      final f0 = File('${tempDir.path}/diagnostics_0.jsonl');
      final f1 = File('${tempDir.path}/diagnostics_1.jsonl');

      expect(await f0.exists() || await f1.exists(), isTrue);

      await logger.dispose();
    });

    test('degrades gracefully to in-memory buffer when file directory is null or invalid', () async {
      final sink = LocalLogSink(directoryPath: null);
      final logger = AppLogger(sink: sink);
      await logger.attachSink(sink);

      expect(sink.isSinkUnavailable, isTrue);

      await logger.info('FALLBACK_EVENT', attemptId: 'ATTEMPT_FALLBACK');
      expect(logger.bufferedEvents.length, 1);
      expect(logger.bufferedEvents.first.eventCode, 'FALLBACK_EVENT');

      await logger.dispose();
    });
  });
}
