/// Utilities for embedding bidirectional Latin/code segments within Arabic RTL layouts.
class BidiText {
  const BidiText._();

  /// Left-to-Right Isolate Unicode character (`\u2066`).
  static const String lri = '\u2066';

  /// Right-to-Left Isolate Unicode character (`\u2067`).
  static const String rli = '\u2067';

  /// Pop Directional Isolate Unicode character (`\u2069`).
  static const String pdi = '\u2069';

  /// Wraps an LTR code fragment (e.g. `PROD-001`, `v0.1.0`) in directional isolate marks
  /// so it renders without punctuation inversion inside an RTL sentence.
  static String wrapLtr(String text) {
    if (text.isEmpty) return text;
    return '$lri$text$pdi';
  }

  /// Wraps an RTL segment explicitly.
  static String wrapRtl(String text) {
    if (text.isEmpty) return text;
    return '$rli$text$pdi';
  }
}
