import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/localization/locale_policy.dart';

void main() {
  group('LocalePolicy', () {
    test('default locale is Arabic (ar)', () {
      expect(LocalePolicy.defaultLocale.languageCode, 'ar');
    });

    test('default text direction is RTL', () {
      expect(LocalePolicy.defaultTextDirection, TextDirection.rtl);
    });

    test('Arabic is supported', () {
      expect(LocalePolicy.isSupported(const Locale('ar')), isTrue);
      expect(LocalePolicy.isSupported(const Locale('en')), isFalse);
    });
  });
}
