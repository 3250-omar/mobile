import 'package:flutter/widgets.dart';

/// Application locale policy enforcing Arabic-first RTL baseline.
class LocalePolicy {
  const LocalePolicy._();

  /// Default and primary application locale.
  static const Locale defaultLocale = Locale('ar');

  /// Supported application locales for this foundation feature.
  static const List<Locale> supportedLocales = <Locale>[defaultLocale];

  /// The standard text direction for Arabic UI.
  static const TextDirection defaultTextDirection = TextDirection.rtl;

  /// Returns whether [locale] is supported by the application.
  static bool isSupported(Locale locale) {
    return locale.languageCode == defaultLocale.languageCode;
  }
}
