import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/storage/platform_data_protection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformDataProtection', () {
    test('DefaultPlatformDataProtection completes without error on standard platform', () async {
      final protection = DefaultPlatformDataProtection();
      await protection.apply([
        '/data/user/0/com.offlinequotes.mobile/app_database.sqlite',
      ]);
      final verified = await protection.verify([
        '/data/user/0/com.offlinequotes.mobile/app_database.sqlite',
      ]);
      expect(verified, isTrue);
    });

    test(
      'DefaultPlatformDataProtection rejects public storage paths',
      () async {
        final protection = DefaultPlatformDataProtection();
        final verified = await protection.verify([
          '/sdcard/Download/app_database.sqlite',
        ]);
        expect(verified, isFalse);
      },
    );
  });
}
