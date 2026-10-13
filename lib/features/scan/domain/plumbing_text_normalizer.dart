/// Domain normalizer for Egyptian Arabic plumbing terms, fractions, and numerals.
class PlumbingTextNormalizer {
  const PlumbingTextNormalizer();

  /// Converts Eastern Arabic (`٠-٩`) and Persian digits to ASCII (`0-9`).
  String normalizeNumerals(String input) {
    const easternDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var result = input;

    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(easternDigits[i], '$i');
      result = result.replaceAll(persianDigits[i], '$i');
    }
    return result;
  }

  /// Normalizes vulgar fraction glyphs and colloquial Arabic fractional terms.
  String normalizeFractions(String input) {
    var result = input;

    // Vulgar Unicode fractions
    result = result.replaceAll('1½', '1 1/2');
    result = result.replaceAll('½', '1/2');
    result = result.replaceAll('¼', '1/4');
    result = result.replaceAll('¾', '3/4');
    result = result.replaceAll('⅛', '1/8');
    result = result.replaceAll('⅜', '3/8');
    result = result.replaceAll('⅝', '5/8');
    result = result.replaceAll('⅞', '7/8');

    // Colloquial terms
    result = result.replaceAllMapped(
      RegExp(r'(^|\s+)(تلات\s*اربع|ثلاثة\s*أرباع|تلاتة\s*اربع)(?=\s+|$)'),
      (m) => '${m[1]}3/4',
    );
    result = result.replaceAllMapped(
      RegExp(r'(^|\s+)(نص|نصف)(?=\s+|$)'),
      (m) => '${m[1]}1/2',
    );
    result = result.replaceAllMapped(
      RegExp(r'(^|\s+)(ربع)(?=\s+|$)'),
      (m) => '${m[1]}1/4',
    );

    return result;
  }

  /// Normalizes colloquial Egyptian plumbing plurals and synonyms to canonical tokens.
  String normalizeSynonyms(String input) {
    final tokens = input.split(RegExp(r'\s+'));
    final mapped = tokens.map((token) {
      switch (token.toLowerCase()) {
        case 'اكواع':
        case 'أكواع':
          return 'كوع';
        case 'محابس':
          return 'محبس';
        case 'تيز':
        case 'تيهات':
          return 'تي';
        case 'جلب':
          return 'جلبة';
        case 'نياكل':
        case 'نيبلز':
          return 'نيبل';
        case 'بوشات':
          return 'بوش';
        case 'لاكورا':
          return 'لاكور';
        case 'مواسير':
          return 'ماسورة';
        case 'بروبلين':
        case 'ppr':
          return 'بولي';
        case 'باننجير':
          return 'باننجر';
        default:
          return token;
      }
    });
    return mapped.join(' ');
  }

  /// Complete normalization pipeline.
  String normalize(String rawText) {
    var text = normalizeNumerals(rawText);
    text = normalizeFractions(text);
    text = normalizeSynonyms(text);

    // Normalize multiple spaces
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }
}
