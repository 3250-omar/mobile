import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/settings/domain/business_profile.dart';
import 'package:offline_quotes/features/settings/presentation/business_profile_screen.dart';
import 'package:offline_quotes/features/settings/presentation/widgets/business_header_preview_card.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../../support/fake_business_profile_repository.dart';

void main() {
  group('BusinessProfileScreen Widget Tests', () {
    late FakeBusinessProfileRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeBusinessProfileRepository(
        initial: BusinessProfile(
          id: 1,
          businessName: 'مؤسسة السباكة الحديثة',
          ownerName: 'محمد أحمد',
          phonePrimary: '01011112222',
          phoneSecondary: '01233334444',
          city: 'المنصورة',
          address: 'شارع الجيش',
          commercialRegister: '12345',
          taxNumber: '987-654-321',
          defaultQuotationNotes: 'عرض سار لمدة أسبوع',
          defaultInvoiceTerms: 'البضاعة ترد وتستبدل',
          updatedAt: DateTime(2026, 1, 1),
        ),
      );
    });

    Widget buildTestSubject() {
      return ProviderScope(
        overrides: [
          businessProfileRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: BusinessProfileScreen(),
        ),
      );
    }

    void setupViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
    }

    Finder findFieldWithKey(String keyString) {
      return find.descendant(
        of: find.byKey(Key(keyString)),
        matching: find.byType(TextField),
      );
    }

    testWidgets('renders screen title, initial fields, and live preview card', (
      tester,
    ) async {
      setupViewport(tester);

      await tester.pumpWidget(buildTestSubject());
      await tester.pumpAndSettle();

      // Screen title
      expect(find.text('بيانات المنشأة والفواتير'), findsOneWidget);

      // Live Preview Card
      expect(find.byType(BusinessHeaderPreviewCard), findsOneWidget);
      expect(find.text('مؤسسة السباكة الحديثة'), findsWidgets);
      expect(find.textContaining('محمد أحمد'), findsWidgets);

      // Verify form fields populated with initial values
      final nameField = tester.widget<TextField>(
        findFieldWithKey('profile_business_name_input'),
      );
      expect(nameField.controller?.text, equals('مؤسسة السباكة الحديثة'));

      final phoneField = tester.widget<TextField>(
        findFieldWithKey('profile_phone_primary_input'),
      );
      expect(phoneField.controller?.text, equals('01011112222'));

      final cityField = tester.widget<TextField>(
        findFieldWithKey('profile_city_input'),
      );
      expect(cityField.controller?.text, equals('المنصورة'));
    });

    testWidgets(
      'editing store name dynamically updates the live preview card',
      (tester) async {
        setupViewport(tester);

        await tester.pumpWidget(buildTestSubject());
        await tester.pumpAndSettle();

        final businessNameField = findFieldWithKey(
          'profile_business_name_input',
        );
        await tester.enterText(businessNameField, 'شركة الهدى للمقاولات');
        await tester.pump();

        // Live preview card should immediately reflect new name
        expect(find.text('شركة الهدى للمقاولات'), findsWidgets);
      },
    );

    testWidgets('validation fails when required business name is empty', (
      tester,
    ) async {
      setupViewport(tester);

      await tester.pumpWidget(buildTestSubject());
      await tester.pumpAndSettle();

      final businessNameField = findFieldWithKey('profile_business_name_input');
      await tester.enterText(businessNameField, '   ');
      await tester.pump();

      final saveButton = find.byKey(const Key('profile_save_button'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('اسم المنشأة مطلوب'), findsOneWidget);
      expect(fakeRepo.saveCalled, isFalse);
    });

    testWidgets('validation fails when required primary phone is empty', (
      tester,
    ) async {
      setupViewport(tester);

      await tester.pumpWidget(buildTestSubject());
      await tester.pumpAndSettle();

      final phonePrimaryField = findFieldWithKey('profile_phone_primary_input');
      await tester.enterText(phonePrimaryField, '');
      await tester.pump();

      final saveButton = find.byKey(const Key('profile_save_button'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('رقم الهاتف الرئيسي مطلوب'), findsOneWidget);
      expect(fakeRepo.saveCalled, isFalse);
    });

    testWidgets('saves updated profile successfully', (tester) async {
      setupViewport(tester);

      await tester.pumpWidget(buildTestSubject());
      await tester.pumpAndSettle();

      final businessNameField = findFieldWithKey('profile_business_name_input');
      await tester.enterText(businessNameField, 'مؤسسة النور والبركة');

      final cityField = findFieldWithKey('profile_city_input');
      await tester.enterText(cityField, 'طنطا');

      final saveButton = find.byKey(const Key('profile_save_button'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(fakeRepo.saveCalled, isTrue);
      expect(fakeRepo.current.businessName, equals('مؤسسة النور والبركة'));
      expect(fakeRepo.current.city, equals('طنطا'));
      expect(find.text('تم حفظ بيانات المنشأة بنجاح'), findsOneWidget);
    });
  });
}
