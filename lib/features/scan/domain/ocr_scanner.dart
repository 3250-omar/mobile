/// Exception thrown during on-device optical character recognition.
class OcrException implements Exception {
  final String message;
  final Object? cause;

  const OcrException(this.message, [this.cause]);

  @override
  String toString() => 'OcrException: $message';
}

/// Abstract contract for 100% on-device Optical Character Recognition.
abstract interface class OcrScanner {
  /// Extracts raw text lines from a local image file.
  ///
  /// Guarantees:
  /// - 100% offline; zero external network or telemetry calls.
  /// - Returns an empty list if no text is detected (never null).
  /// - Throws [OcrException] if local file decoding fails or engine errors occur.
  Future<List<String>> extractLines(String imagePath);
}
