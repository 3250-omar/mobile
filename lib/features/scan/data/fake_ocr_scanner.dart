import '../domain/ocr_scanner.dart';

/// Predictable, deterministic in-memory OCR scanner for unit, widget, and acceptance tests.
class FakeOcrScanner implements OcrScanner {
  final List<String>? defaultLines;
  final Map<String, List<String>> presetSlipByPath;
  bool shouldThrow;

  FakeOcrScanner({
    this.defaultLines,
    Map<String, List<String>>? presetSlipByPath,
    this.shouldThrow = false,
  }) : presetSlipByPath = presetSlipByPath ?? {};

  /// Standard realistic Egyptian plumbing requisition slip lines for testing.
  static const List<String> defaultPlumbingSlip = [
    '١٠ كوع ٢٠ مم بولي',
    '٥ تي ٢٠ مم بولي',
    'محبس دفن ٣/٤ عدد ٢',
    'جلبة سن داخلي 1/2 عدد 4',
    'ماسورة 20 بولي 2.5 م',
    'شريط تفلون عدد 3',
  ];

  @override
  Future<List<String>> extractLines(String imagePath) async {
    if (shouldThrow) {
      throw const OcrException('فشل التعرف على النص في الصورة');
    }

    if (presetSlipByPath.containsKey(imagePath)) {
      return presetSlipByPath[imagePath]!;
    }

    return defaultLines ?? defaultPlumbingSlip;
  }
}
