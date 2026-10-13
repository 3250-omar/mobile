import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture Dependency Direction', () {
    final libDir = Directory('lib');

    test('domain layer must not import Flutter, Drift, GoRouter, or platform plugins', () {
      if (!libDir.existsSync()) return;

      final domainFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.replaceAll('\\', '/').contains('/domain/'))
          .toList();

      final forbiddenImports = <String>[
        'package:flutter/',
        'package:material_ui/',
        'package:drift/',
        'package:go_router/',
        'package:path_provider/',
        'package:sqlite3/',
      ];

      for (final file in domainFiles) {
        final content = file.readAsStringSync();
        for (final forbidden in forbiddenImports) {
          expect(
            content.contains("import '$forbidden") ||
                content.contains('import "$forbidden'),
            isFalse,
            reason:
                'Domain file ${file.path} contains forbidden import $forbidden',
          );
        }
      }
    });

    test('features must not cross-import each other', () {
      if (!libDir.existsSync()) return;

      final featureDirs = Directory('lib/features')
          .listSync()
          .whereType<Directory>()
          .map((d) => d.uri.pathSegments.reversed.skip(1).first)
          .toList();

      for (final feature in featureDirs) {
        final featureDir = Directory('lib/features/$feature');
        final files = featureDir.listSync(recursive: true).whereType<File>();

        for (final file in files) {
          final content = file.readAsStringSync();
          for (final otherFeature in featureDirs) {
            if (otherFeature == feature) continue;

            final forbiddenImport = 'features/$otherFeature/';
            expect(
              content.contains(forbiddenImport),
              isFalse,
              reason:
                  'Feature "$feature" (${file.path}) illegally imports feature "$otherFeature"',
            );
          }
        }
      }
    });
  });
}
