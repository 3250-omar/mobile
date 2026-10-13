import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/localization/bidi_text.dart';
import 'package:offline_quotes/app/localization/numeral_policy.dart';

void main() {
  group('NumeralPolicy & BidiText', () {
    test('normalizes Arabic-Indic digits to Western digits', () {
      expect(NumeralPolicy.normalizeInputDigits('١٢٣٤٥'), '12345');
      expect(NumeralPolicy.normalizeInputDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(NumeralPolicy.normalizeInputDigits('123٤٥'), '12345');
    });

    test('leaves non-digit characters intact during normalization', () {
      expect(NumeralPolicy.normalizeInputDigits('صنف رقم ١٢٣'), 'صنف رقم 123');
      expect(NumeralPolicy.normalizeInputDigits('PROD-٤٥A'), 'PROD-45A');
      expect(NumeralPolicy.normalizeInputDigits('EGP ١٥٠.٥٠'), 'EGP 150.50');
    });

    test('validates numeric strings in both numeral representations', () {
      expect(NumeralPolicy.isValidNumericString('123'), isTrue);
      expect(NumeralPolicy.isValidNumericString('١٢٣'), isTrue);
      expect(NumeralPolicy.isValidNumericString('12.5'), isTrue);
      expect(NumeralPolicy.isValidNumericString('١٢.٥'), isTrue);
      expect(NumeralPolicy.isValidNumericString('abc'), isFalse);
      expect(NumeralPolicy.isValidNumericString('12a'), isFalse);
    });

    test('formats generated integers and decimals in Western digits', () {
      expect(NumeralPolicy.formatInteger(150), '150');
      expect(NumeralPolicy.formatDecimal(150.25), '150.25');
      expect(NumeralPolicy.formatDecimal(150.0, fractionDigits: 2), '150.00');
    });

    test('wraps LTR fragment in directional isolate marks', () {
      final wrapped = BidiText.wrapLtr('CODE-99');
      expect(wrapped, '${BidiText.lri}CODE-99${BidiText.pdi}');
    });
  });
}
