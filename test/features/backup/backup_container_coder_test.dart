import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/backup/data/backup_container_coder.dart';
import 'package:offline_quotes/features/backup/domain/backup_result.dart';

void main() {
  group('PureSha256 & BackupContainerCoder Tests', () {
    const coder = BackupContainerCoder();

    test('PureSha256 computes standard hash vector correctly', () {
      // standard vector: hash of "" is e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
      expect(
        PureSha256.hashHex([]),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );

      // standard vector: hash of "abc" is ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
      expect(
        PureSha256.hashHex(utf8.encode('abc')),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('encodes and decodes unencrypted backup container roundtrip', () {
      final sampleSqlite = Uint8List.fromList(
        utf8.encode('SQLite format 3\x00SAMPLE_DATABASE_CONTENT'),
      );

      final container = coder.encode(
        sqliteBytes: sampleSqlite,
        schemaVersion: 4,
        totalProducts: 42,
        totalQuotations: 12,
        totalInvoices: 8,
      );

      final inspection = coder.inspect(container);
      expect(inspection.isValid, true);
      expect(inspection.metadata?.schemaVersion, 4);
      expect(inspection.metadata?.totalProductsCount, 42);
      expect(inspection.metadata?.isEncrypted, false);

      final decoded = coder.decode(container);
      expect(decoded, sampleSqlite);
    });

    test(
      'detects tampered payload bytes and rejects with checksum mismatch',
      () {
        final sampleSqlite = Uint8List.fromList(
          utf8.encode('SQLite format 3\x00SAFE_PAYLOAD'),
        );
        final container = coder.encode(
          sqliteBytes: sampleSqlite,
          schemaVersion: 4,
        );

        // Tamper with the last byte
        container[container.length - 1] ^= 0xFF;

        expect(() => coder.decode(container), throwsA(isA<FormatException>()));
      },
    );

    test('encodes and decodes password-protected backup container', () {
      final sampleSqlite = Uint8List.fromList(
        utf8.encode('SQLite format 3\x00SECRET_SALES_RECORD'),
      );
      const password = 'SuperSecretMerchantPassword123';

      final container = coder.encode(
        sqliteBytes: sampleSqlite,
        schemaVersion: 4,
        password: password,
      );

      final inspection = coder.inspect(container);
      expect(inspection.isValid, true);
      expect(inspection.metadata?.isEncrypted, true);

      // Decrypt with correct password
      final restored = coder.decode(container, password: password);
      expect(restored, sampleSqlite);

      // Decrypt with wrong password fails
      expect(
        () => coder.decode(container, password: 'WrongPassword'),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects corrupted container header', () {
      final badHeader = Uint8List.fromList([0x00, 0x01, 0x02, 0x03, 0x04]);
      final result = coder.inspect(badHeader);

      expect(result.isValid, false);
      expect(result.error, RestoreValidationError.invalidContainerHeader);
    });
  });
}
