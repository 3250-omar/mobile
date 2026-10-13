import 'dart:async';
import 'dart:io';

import 'diagnostic_event.dart';

/// Rotating local file sink for privacy-safe JSONL diagnostic records.
class LocalLogSink {
  LocalLogSink({
    this.directoryPath,
    this.maxFileSizeBytes = 512 * 1024, // 512 KiB
    this.maxFileCount = 3,
  });

  final String? directoryPath;
  final int maxFileSizeBytes;
  final int maxFileCount;

  int _currentFileIndex = 0;
  IOSink? _currentFileSink;
  File? _currentFile;
  int _currentFileLength = 0;

  final List<DiagnosticEvent> _fallbackMemoryBuffer = <DiagnosticEvent>[];
  static const int maxFallbackBufferSize = 100;
  bool _sinkUnavailable = false;

  bool get isSinkUnavailable => _sinkUnavailable;
  List<DiagnosticEvent> get inMemoryBuffer =>
      List.unmodifiable(_fallbackMemoryBuffer);

  Future<void> initialize() async {
    if (directoryPath == null) {
      _sinkUnavailable = true;
      return;
    }

    try {
      final dir = Directory(directoryPath!);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await _openCurrentSink();
    } catch (_) {
      _sinkUnavailable = true;
    }
  }

  Future<void> _openCurrentSink() async {
    if (directoryPath == null || _sinkUnavailable) return;

    try {
      final filePath = '$directoryPath/diagnostics_$_currentFileIndex.jsonl';
      _currentFile = File(filePath);
      if (await _currentFile!.exists()) {
        _currentFileLength = await _currentFile!.length();
        if (_currentFileLength >= maxFileSizeBytes) {
          _rotateFile();
          return;
        }
      } else {
        _currentFileLength = 0;
      }
      _currentFileSink = _currentFile!.openWrite(mode: FileMode.append);
    } catch (_) {
      _sinkUnavailable = true;
    }
  }

  void _rotateFile() {
    _currentFileSink?.close();
    _currentFileSink = null;
    _currentFileIndex = (_currentFileIndex + 1) % maxFileCount;
    final nextPath = '$directoryPath/diagnostics_$_currentFileIndex.jsonl';
    final nextFile = File(nextPath);
    if (nextFile.existsSync()) {
      try {
        nextFile.deleteSync();
      } catch (_) {}
    }
    _currentFileLength = 0;
    _currentFile = nextFile;
    try {
      _currentFileSink = nextFile.openWrite(mode: FileMode.write);
    } catch (_) {
      _sinkUnavailable = true;
    }
  }

  Future<void> write(DiagnosticEvent event) async {
    // Keep in fallback memory buffer with bounded limit
    if (_fallbackMemoryBuffer.length >= maxFallbackBufferSize) {
      _fallbackMemoryBuffer.removeAt(0);
    }
    _fallbackMemoryBuffer.add(event);

    if (_sinkUnavailable || directoryPath == null) return;

    try {
      if (_currentFileSink == null) {
        await _openCurrentSink();
      }
      if (_sinkUnavailable || _currentFileSink == null) return;

      final line = '${event.toJsonLine()}\n';
      final lineBytes = line.length;

      if (_currentFileLength + lineBytes > maxFileSizeBytes) {
        _rotateFile();
      }

      _currentFileSink?.write(line);
      _currentFileLength += lineBytes;
    } catch (_) {
      _sinkUnavailable = true;
    }
  }

  Future<void> flush() async {
    if (_currentFileSink != null) {
      try {
        await _currentFileSink!.flush();
      } catch (_) {}
    }
  }

  Future<void> dispose() async {
    await flush();
    if (_currentFileSink != null) {
      try {
        await _currentFileSink!.close();
      } catch (_) {}
      _currentFileSink = null;
    }
  }
}
