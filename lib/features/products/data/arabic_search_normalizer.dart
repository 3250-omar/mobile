/// Resilient Arabic orthographic and numeral normalizer for plumbing catalog search.
class ArabicSearchNormalizer {
  const ArabicSearchNormalizer._();

  // Arabic Tashkeel / diacritics regex: Fat-hah, Dammah, Kasrah, Sukun, Shaddah, Tanwin, Superscript Alef
  static final RegExp _tashkeelRegex = RegExp(r'[\u064B-\u065F\u0670]');

  // Arabic Tatweel (Kashida)
  static final RegExp _tatweelRegex = RegExp(r'\u0640');

  // Consecutive whitespace regex
  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  /// Normalizes Arabic text, letter variations, and numeral systems into a canonical searchable form.
  static String normalize(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    var text = input;

    // 1. Remove Tashkeel and Tatweel
    text = text.replaceAll(_tashkeelRegex, '');
    text = text.replaceAll(_tatweelRegex, '');

    // 2. Normalize Eastern Arabic numerals to Western Arabic digits
    text = text
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');

    // 3. Normalize fractions
    text = text
        .replaceAll('½', '1/2')
        .replaceAll('¼', '1/4')
        .replaceAll('¾', '3/4');

    // 4. Normalize Arabic letter variants
    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');

    // 5. Lowercase Latin characters
    text = text.toLowerCase();

    // 6. Collapse whitespace and trim
    text = text.replaceAll(_whitespaceRegex, ' ').trim();

    return text;
  }

  /// Builds a concatenated, normalized search token string from a product's attributes.
  static String buildSearchText({
    required String name,
    required String code,
    required String category,
    String? barcode,
  }) {
    final parts = [
      name,
      code,
      category,
      if (barcode != null && barcode.isNotEmpty) barcode,
    ];
    return normalize(parts.join(' '));
  }
}
