import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_line_parser.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_text_normalizer.dart';

void main() {
  group('DefaultPlumbingLineParser', () {
    const normalizer = PlumbingTextNormalizer();
    const parser = DefaultPlumbingLineParser(normalizer: normalizer);

    test('parses prefix quantity: "١٠ كوع ٢٠ مم بولي"', () {
      final parsed = parser.parseLine('١٠ كوع ٢٠ مم بولي');

      expect(parsed.quantity, equals(10.0));
      expect(parsed.unit, equals('قطعة'));
      expect(parsed.normalizedSearchTerm, equals('كوع 20 مم بولي'));
    });

    test('parses suffix quantity with "عدد": "محبس دفن 3/4 عدد 5"', () {
      final parsed = parser.parseLine('محبس دفن 3/4 عدد 5');

      expect(parsed.quantity, equals(5.0));
      expect(parsed.unit, equals('قطعة'));
      expect(parsed.normalizedSearchTerm, equals('محبس دفن 3/4'));
    });

    test('parses meter unit and decimal: "2.5 م ماسورة بولي 20"', () {
      final parsed = parser.parseLine('2.5 م ماسورة بولي 20');

      expect(parsed.quantity, equals(2.5));
      expect(parsed.unit, equals('متر'));
      expect(parsed.normalizedSearchTerm, equals('ماسورة بولي 20'));
    });

    test('defaults missing quantity to 1.0 piece: "شريط تفلون"', () {
      final parsed = parser.parseLine('شريط تفلون');

      expect(parsed.quantity, equals(1.0));
      expect(parsed.unit, equals('قطعة'));
      expect(parsed.normalizedSearchTerm, equals('شريط تفلون'));
    });

    test('filters empty or noisy lines in parseAll', () {
      final lines = [
        '   ',
        '---',
        '١٠ كوع ٢٠ مم بولي',
        '',
        'محبس بلية 1/2 عدد 2',
      ];

      final parsedList = parser.parseAll(lines);
      expect(parsedList.length, equals(2));
      expect(parsedList.first.quantity, equals(10.0));
      expect(parsedList.last.quantity, equals(2.0));
    });
  });
}
