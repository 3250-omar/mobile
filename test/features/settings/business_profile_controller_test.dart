import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/settings/application/business_profile_controller.dart';
import 'package:offline_quotes/features/settings/domain/business_profile.dart';

import '../../support/fake_business_profile_repository.dart';

void main() {
  late FakeBusinessProfileRepository fakeRepository;
  late BusinessProfileController controller;

  setUp(() {
    fakeRepository = FakeBusinessProfileRepository(
      initial: BusinessProfile.defaults().copyWith(
        businessName: 'مؤسسة الاختبار',
        phonePrimary: '01000000000',
      ),
    );
    controller = BusinessProfileController(fakeRepository);
  });

  group('BusinessProfileController Tests', () {
    test('initializes with loaded profile from repository', () async {
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.profile.businessName, equals('مؤسسة الاختبار'));
      expect(controller.state.profile.phonePrimary, equals('01000000000'));
      expect(controller.state.isLoading, isFalse);
    });

    test('saveProfile() validates required store name and phone', () async {
      await Future<void>.delayed(Duration.zero);

      final emptyNameResult = await controller.saveProfile(
        businessName: '   ',
        phonePrimary: '01011111111',
      );
      expect(emptyNameResult, isFalse);
      expect(controller.state.errorMessage, contains('اسم المنشأة'));

      final emptyPhoneResult = await controller.saveProfile(
        businessName: 'مؤسسة النور',
        phonePrimary: '   ',
      );
      expect(emptyPhoneResult, isFalse);
      expect(controller.state.errorMessage, contains('رقم الهاتف'));
    });

    test('saveProfile() saves valid profile and sets successMessage', () async {
      await Future<void>.delayed(Duration.zero);

      final success = await controller.saveProfile(
        businessName: 'مؤسسة الفجر للأدوات الصحية',
        ownerName: 'محمد أحمد',
        phonePrimary: '01022223333',
        address: 'شارع البحر',
        city: 'طنطا',
        taxNumber: '111-222-333',
        commercialRegister: '55443',
        defaultQuotationNotes: 'الأسعار سارية لمدة أسبوع',
        defaultInvoiceTerms: 'البضاعة المباعة ترد خلال 14 يوم',
      );

      expect(success, isTrue);
      expect(controller.state.successMessage, isNotNull);
      expect(
        controller.state.profile.businessName,
        equals('مؤسسة الفجر للأدوات الصحية'),
      );
      expect(controller.state.profile.ownerName, equals('محمد أحمد'));
      expect(controller.state.profile.city, equals('طنطا'));
      expect(fakeRepository.saveCalled, isTrue);
    });

    test('setLogoBytes() and removeLogo() manage logo state', () async {
      await Future<void>.delayed(Duration.zero);

      final logoBytes = [1, 2, 3, 4];
      final logoSaved = await controller.setLogoBytes(logoBytes, 'png');

      expect(logoSaved, isTrue);
      expect(controller.state.profile.hasLogo, isTrue);
      expect(fakeRepository.saveLogoCalled, isTrue);

      final removed = await controller.removeLogo();
      expect(removed, isTrue);
      expect(controller.state.profile.hasLogo, isFalse);
      expect(fakeRepository.deleteLogoCalled, isTrue);
    });
  });
}
