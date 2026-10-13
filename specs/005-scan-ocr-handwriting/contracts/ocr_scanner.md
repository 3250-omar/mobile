# Contract: OCR Scanner

**Feature**: `005-scan-ocr-handwriting`  
**Layer**: Domain / Infrastructure Contract  

---

## Interface Definition

```dart
abstract interface class OcrScanner {
  /// Extracts raw text lines from a local image file.
  ///
  /// Throws [OcrException] if image decoding fails or processing encounters
  /// an unrecoverable local engine error.
  /// Strictly 100% offline; zero network calls.
  Future<List<String>> extractLines(String imagePath);
}

class OcrException implements Exception {
  final String message;
  final Object? cause;

  const OcrException(this.message, [this.cause]);

  @override
  String toString() => 'OcrException: $message';
}
```

## Guarantees
1. **Offline Guarantee**: Processing executes entirely within on-device memory.
2. **Determinism**: Given identical image inputs, implementations return consistent line breakdowns.
3. **Empty Text Handling**: If an image contains no recognizable text, returns an empty `List<String>`, never throws null.
