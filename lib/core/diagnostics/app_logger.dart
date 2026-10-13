import 'dart:async';

import 'diagnostic_event.dart';
import 'local_log_sink.dart';

/// Central application diagnostic logger.
///
/// Features early in-memory buffering prior to file sink availability,
/// strict redaction, local-only rotation, and zero network transmission.
class AppLogger {
  AppLogger({this.sink});

  LocalLogSink? sink;
  final List<DiagnosticEvent> _earlyBuffer = <DiagnosticEvent>[];
  static const int maxEarlyBufferSize = 200;

  bool get isSinkAttached => sink != null;

  /// Attaches and flushes early events to the persistent file sink.
  Future<void> attachSink(LocalLogSink newSink) async {
    sink = newSink;
    await newSink.initialize();

    // Flush buffered early events
    final pending = List<DiagnosticEvent>.from(_earlyBuffer);
    _earlyBuffer.clear();
    for (final event in pending) {
      await newSink.write(event);
    }
  }

  Future<void> log(
    String eventCode, {
    String level = 'info',
    String? attemptId,
    Map<String, Object>? attributes,
  }) async {
    final event = DiagnosticEvent(
      eventCode: eventCode,
      level: level,
      attemptId: attemptId,
      attributes: attributes,
    );

    final activeSink = sink;
    if (activeSink != null) {
      await activeSink.write(event);
    } else {
      if (_earlyBuffer.length >= maxEarlyBufferSize) {
        _earlyBuffer.removeAt(0);
      }
      _earlyBuffer.add(event);
    }
  }

  Future<void> info(
    String eventCode, {
    String? attemptId,
    Map<String, Object>? attributes,
  }) => log(
    eventCode,
    level: 'info',
    attemptId: attemptId,
    attributes: attributes,
  );

  Future<void> warning(
    String eventCode, {
    String? attemptId,
    Map<String, Object>? attributes,
  }) => log(
    eventCode,
    level: 'warning',
    attemptId: attemptId,
    attributes: attributes,
  );

  Future<void> error(
    String eventCode, {
    String? attemptId,
    Map<String, Object>? attributes,
  }) => log(
    eventCode,
    level: 'error',
    attemptId: attemptId,
    attributes: attributes,
  );

  Future<void> debug(
    String eventCode, {
    String? attemptId,
    Map<String, Object>? attributes,
  }) => log(
    eventCode,
    level: 'debug',
    attemptId: attemptId,
    attributes: attributes,
  );

  List<DiagnosticEvent> get bufferedEvents {
    final activeSink = sink;
    return activeSink != null
        ? activeSink.inMemoryBuffer
        : List.unmodifiable(_earlyBuffer);
  }

  Future<void> flush() async {
    await sink?.flush();
  }

  Future<void> dispose() async {
    await sink?.dispose();
    _earlyBuffer.clear();
  }
}
