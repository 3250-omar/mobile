import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/products/data/arabic_search_normalizer.dart';

void main() {
  group('ArabicSearchNormalizer', () {
    test('normalizes Eastern Arabic numerals to Western Arabic digits', () {
      expect(
        ArabicSearchNormalizer.normalize('كوع ١/٢ بوصة'),
        equals('كوع 1/2 بوصه'),
      );
      expect(
        ArabicSearchNormalizer.normalize('ماسورة ٣/٤'),
        equals('ماسوره 3/4'),
      );
      expect(
        ArabicSearchNormalizer.normalize('٠١٢٣٤٥٦٧٨٩'),
        equals('0123456789'),
      );
    });

    test('strips Tashkeel diacritics and Tatweel', () {
      expect(
        ArabicSearchNormalizer.normalize('مَحْبَسْ كُرَة'),
        equals('محبس كره'),
      );
      expect(
        ArabicSearchNormalizer.normalize('مـــواســـير'),
        equals('مواسير'),
      );
    });

    test('normalizes Alef, Taa Marbouta, and Yaa forms', () {
      expect(
        ArabicSearchNormalizer.normalize('أكواع إيطالي'),
        equals('اكواع ايطالي'),
      );
      expect(
        ArabicSearchNormalizer.normalize('جلبة سن نحاس'),
        equals('جلبه سن نحاس'),
      );
      expect(
        ArabicSearchNormalizer.normalize('مصفى بيبة'),
        equals('مصفي بيبه'),
      );
    });

    test('handles fractions and mixed Latin/Arabic text', () {
      expect(
        ArabicSearchNormalizer.normalize('كوع ½ بوصة PPR'),
        equals('كوع 1/2 بوصه ppr'),
      );
    });

    test('builds concatenated normalized search text for indexing', () {
      final searchIndex = ArabicSearchNormalizer.buildSearchText(
        name: 'كوع زاوية ٩٠ درجة ١/٢ بوصة',
        code: 'PPR-ELB-050',
        category: 'لوازم بولي بروبلين',
        barcode: '6221234567890',
      );

      expect(searchIndex, contains('كوع زاويه 90 درجه 1/2 بوصه'));
      expect(searchIndex, contains('ppr-elb-050'));
      expect(searchIndex, contains('لوازم بولي بروبلين'));
      expect(searchIndex, contains('6221234567890'));
    });
  });
}
