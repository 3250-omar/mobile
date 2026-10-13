import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/scan/domain/scanned_line_item.dart';
import 'package:offline_quotes/features/scan/presentation/widgets/candidate_selector_dialog.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({
    required ScannedLineItem item,
    required ValueChanged<CatalogCandidateMatch> onSelectCandidate,
    required void Function(String, int) onSelectCustom,
  }) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      home: Scaffold(
        body: CandidateSelectorDialog(
          item: item,
          onSelectCandidate: onSelectCandidate,
          onSelectCustom: onSelectCustom,
        ),
      ),
    );
  }

  testWidgets('renders candidates list and selects a candidate', (
    tester,
  ) async {
    CatalogCandidateMatch? selectedCandidate;

    const item = ScannedLineItem(
      id: 'item-1',
      lineNumber: 1,
      rawText: 'محبس 1/2',
      normalizedText: 'محبس 1/2',
      candidates: [
        CatalogCandidateMatch(
          productId: 101,
          productCode: 'VLV-12-BUR',
          productName: 'محبس دفن 1/2 إيطالي',
          unitPricePiastres: 12000,
          matchScore: 0.90,
          matchReason: 'تطابق عالي',
        ),
        CatalogCandidateMatch(
          productId: 102,
          productCode: 'VLV-12-BAL',
          productName: 'محبس بلية 1/2 فراشة',
          unitPricePiastres: 9500,
          matchScore: 0.88,
          matchReason: 'تطابق عالي',
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestWidget(
        item: item,
        onSelectCandidate: (candidate) => selectedCandidate = candidate,
        onSelectCustom: (_, _) {},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تحديد الصنف المطابق'), findsOneWidget);
    expect(find.text('محبس دفن 1/2 إيطالي'), findsOneWidget);
    expect(find.text('محبس بلية 1/2 فراشة'), findsOneWidget);

    await tester.tap(find.text('محبس دفن 1/2 إيطالي'));
    await tester.pumpAndSettle();

    expect(selectedCandidate, isNotNull);
    expect(selectedCandidate!.productId, equals(101));
  });

  testWidgets('allows entering custom product name and price', (tester) async {
    String? customName;
    int? customPrice;

    const item = ScannedLineItem(
      id: 'item-2',
      lineNumber: 2,
      rawText: 'صنف غير معروف',
      normalizedText: 'صنف غير معروف',
      candidates: [],
    );

    await tester.pumpWidget(
      buildTestWidget(
        item: item,
        onSelectCandidate: (_) {},
        onSelectCustom: (name, price) {
          customName = name;
          customPrice = price;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('تعيين كصنف مخصص / غير مسجل بالكتالوج'));
    await tester.pumpAndSettle();

    expect(find.text('بيانات الصنف المخصص:'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'سعر الوحدة (ج.م)'),
      '45.50',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('تأكيد الصنف المخصص'));
    await tester.pumpAndSettle();

    expect(customName, equals('صنف غير معروف'));
    expect(customPrice, equals(4550));
  });
}
