import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/theme/app_theme.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../support/foundation_component_showcase.dart';

void main() {
  group('Foundation Component Showcase Accessibility & Responsive Tests', () {
    testWidgets('renders showcase in RTL and Light Theme without overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: FoundationComponentShowcase(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('معرض المكونات الأساسية'), findsOneWidget);
      expect(find.text('زر أساسي'), findsOneWidget);
      expect(find.text('زر ثانوي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders showcase in RTL and Dark Theme without overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: FoundationComponentShowcase(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('معرض المكونات الأساسية'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('supports 200% text scale without clipping essential content', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: FoundationComponentShowcase(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('معرض المكونات الأساسية'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
