import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/scan/data/fake_ocr_scanner.dart';
import 'package:offline_quotes/features/scan/domain/ocr_scanner.dart';

void main() {
  group('FakeOcrScanner', () {
    test('extracts default realistic Arabic plumbing slip', () async {
      final scanner = FakeOcrScanner();
      final lines = await scanner.extractLines('/dummy/path/slip.jpg');

      expect(lines.isNotEmpty, isTrue);
      expect(lines, contains('١٠ كوع ٢٠ مم بولي'));
      expect(lines, contains('محبس دفن ٣/٤ عدد ٢'));
    });

    test('extracts custom slip configured by path', () async {
      final scanner = FakeOcrScanner(
        presetSlipByPath: {
          '/test/image.jpg': ['بند ١', 'بند ٢'],
        },
      );

      final lines = await scanner.extractLines('/test/image.jpg');
      expect(lines, equals(['بند ١', 'بند ٢']));
    });

    test('throws OcrException when shouldThrow is enabled', () async {
      final scanner = FakeOcrScanner(shouldThrow: true);

      expect(
        () => scanner.extractLines('/test/fail.jpg'),
        throwsA(isA<OcrException>()),
      );
    });
  });
}
