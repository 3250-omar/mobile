import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/settings/data/drift_business_profile_repository.dart';
import 'package:offline_quotes/features/settings/domain/business_profile.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late DriftBusinessProfileRepository repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('profile_test_');
    repository = DriftBusinessProfileRepository(
      db,
      storageDirectoryResolver: () async => tempDir.path,
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('DriftBusinessProfileRepository Tests', () {
    test('load() returns deterministic defaults on first launch', () async {
      final profile = await repository.load();

      expect(profile.id, equals(1));
      expect(profile.businessName, equals('تسعيرة للأدوات الصحية والسباكة'));
      expect(profile.hasLogo, isFalse);
    });

    test('save() updates profile details atomically', () async {
      final initial = await repository.load();
      final updated = initial.copyWith(
        businessName: 'مؤسسة السلام لمهمات السباكة',
        phonePrimary: '01012345678',
        address: 'شارع الجمهورية',
        city: 'المنصورة',
        taxNumber: '123-456',
        commercialRegister: '7890',
      );

      final saved = await repository.save(updated);
      expect(saved.businessName, equals('مؤسسة السلام لمهمات السباكة'));

      final loaded = await repository.load();
      expect(loaded.businessName, equals('مؤسسة السلام لمهمات السباكة'));
      expect(loaded.phonePrimary, equals('01012345678'));
      expect(loaded.city, equals('المنصورة'));
      expect(loaded.hasTaxCredentials, isTrue);
    });

    test(
      'save() rejects blank business name with validation failure',
      () async {
        final initial = await repository.load();
        final invalid = initial.copyWith(businessName: '   ');

        expect(
          () => repository.save(invalid),
          throwsA(
            isA<AppFailure>().having(
              (f) => f.code,
              'code',
              equals('VALIDATION_ERROR'),
            ),
          ),
        );
      },
    );

    test('saveLogoFile() and deleteLogoFile() manage sandboxed file', () async {
      final mockBytes = [137, 80, 78, 71, 13, 10, 26, 10]; // PNG header
      final logoPath = await repository.saveLogoFile(mockBytes, 'png');

      final file = File(logoPath);
      expect(await file.exists(), isTrue);

      final loaded = await repository.load();
      expect(loaded.logoPath, equals(logoPath));
      expect(loaded.hasLogo, isTrue);

      await repository.deleteLogoFile();
      expect(await file.exists(), isFalse);

      final reloaded = await repository.load();
      expect(reloaded.hasLogo, isFalse);
      expect(reloaded.logoPath, isNull);
    });

    test('watch() emits updates in real time', () async {
      final current = await repository.load();
      final stream = repository.watch();
      final expectation = expectLater(
        stream,
        emitsInOrder([
          isA<BusinessProfile>(), // initial loaded state
          isA<BusinessProfile>().having(
            (p) => p.businessName,
            'businessName',
            equals('شركة النيل'),
          ),
        ]),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await repository.save(current.copyWith(businessName: 'شركة النيل'));

      await expectation;
    });
  });
}
