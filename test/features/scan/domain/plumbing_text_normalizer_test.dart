import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_text_normalizer.dart';

void main() {
  group('PlumbingTextNormalizer', () {
    const normalizer = PlumbingTextNormalizer();

    test('normalizes Eastern Arabic numerals to ASCII digits', () {
      expect(normalizer.normalizeNumerals('٠١٢٣٤٥٦٧٨٩'), equals('0123456789'));
      expect(
        normalizer.normalizeNumerals('كوع ٢٠ مم عدد ٥'),
        equals('كوع 20 مم عدد 5'),
      );
    });

    test('normalizes vulgar fractions and Arabic fractional terms', () {
      expect(
        normalizer.normalizeFractions('محبس ½ بوصة'),
        equals('محبس 1/2 بوصة'),
      );
      expect(normalizer.normalizeFractions('جلبة ¾'), equals('جلبة 3/4'));
      expect(normalizer.normalizeFractions('نيبل ¼'), equals('نيبل 1/4'));
      expect(
        normalizer.normalizeFractions('ماسورة 1½'),
        equals('ماسورة 1 1/2'),
      );
      expect(
        normalizer.normalizeFractions('محبس نص بوصة'),
        equals('محبس 1/2 بوصة'),
      );
      expect(normalizer.normalizeFractions('كوع تلات اربع'), equals('كوع 3/4'));
    });

    test('normalizes colloquial Egyptian plumbing synonyms and plurals', () {
      expect(normalizer.normalizeSynonyms('اكواع بولي'), equals('كوع بولي'));
      expect(normalizer.normalizeSynonyms('محابس دفن'), equals('محبس دفن'));
      expect(normalizer.normalizeSynonyms('تيز 20'), equals('تي 20'));
      expect(normalizer.normalizeSynonyms('جلب بسن'), equals('جلبة بسن'));
      expect(normalizer.normalizeSynonyms('نياكل 1/2'), equals('نيبل 1/2'));
      expect(normalizer.normalizeSynonyms('بوشات حديد'), equals('بوش حديد'));
      expect(normalizer.normalizeSynonyms('لاكورا بولي'), equals('لاكور بولي'));
      expect(
        normalizer.normalizeSynonyms('مواسير بروبلين'),
        equals('ماسورة بولي'),
      );
    });

    test('combines full normalization pipeline', () {
      final result = normalizer.normalize('٥ اكواع ٢٠ مم بروبلين');
      expect(result, equals('5 كوع 20 مم بولي'));
    });
  });
}
