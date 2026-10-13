import 'dart:async';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

/// Drift/SQLite implementation of [SettingsRepository].
///
/// Executes all reads and mutations within explicit transactions,
/// ensuring transactional persistence, immutable snapshots, and zero network access.
class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<AppSettings> load() async {
    try {
      return await _database.transaction<AppSettings>(() async {
        final query = _database.select(_database.appSettingsTable)
          ..where((t) => t.id.equals(1));
        final row = await query.getSingleOrNull();

        if (row == null) {
          final defaults = AppSettings.defaults();
          await _database
              .into(_database.appSettingsTable)
              .insert(
                AppSettingsCompanion.insert(
                  id: const Value(1),
                  themeMode: Value(defaults.themeMode),
                  localeTag: Value(defaults.localeTag),
                  createdAtUtc: defaults.createdAtUtc.toIso8601String(),
                  updatedAtUtc: defaults.updatedAtUtc.toIso8601String(),
                  revision: const Value(0),
                ),
              );
          return defaults;
        }

        return _mapRowToDomain(row);
      });
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Stream<AppSettings> watch() {
    final query = _database.select(_database.appSettingsTable)
      ..where((t) => t.id.equals(1));
    return query.watchSingleOrNull().transform(
      StreamTransformer<AppSettingsData?, AppSettings>.fromHandlers(
        handleData: (row, sink) {
          if (row != null) {
            sink.add(_mapRowToDomain(row));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(FailureMapper.map(error, stackTrace: stackTrace));
        },
      ),
    );
  }

  @override
  Future<AppSettings> setThemeMode(String mode) async {
    if (mode != 'system' && mode != 'light' && mode != 'dark') {
      throw const AppFailure(
        code: 'VALIDATION_INVALID_THEME',
        messageKey: 'errorGeneric',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    try {
      return await _database.transaction<AppSettings>(() async {
        final query = _database.select(_database.appSettingsTable)
          ..where((t) => t.id.equals(1));
        final current = await query.getSingleOrNull();

        final nowUtc = DateTime.now().toUtc().toIso8601String();
        final nextRevision = (current?.revision ?? 0) + 1;

        if (current == null) {
          final defaults = AppSettings.defaults().copyWith(
            themeMode: mode,
            revision: 0,
          );
          await _database
              .into(_database.appSettingsTable)
              .insert(
                AppSettingsCompanion.insert(
                  id: const Value(1),
                  themeMode: Value(mode),
                  localeTag: Value(defaults.localeTag),
                  createdAtUtc: defaults.createdAtUtc.toIso8601String(),
                  updatedAtUtc: nowUtc,
                  revision: const Value(0),
                ),
              );
          return defaults;
        }

        await (_database.update(
          _database.appSettingsTable,
        )..where((t) => t.id.equals(1))).write(
          AppSettingsCompanion(
            themeMode: Value(mode),
            updatedAtUtc: Value(nowUtc),
            revision: Value(nextRevision),
          ),
        );

        final updated = await query.getSingle();
        return _mapRowToDomain(updated);
      });
    } catch (e, st) {
      if (e is AppFailure) rethrow;
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  AppSettings _mapRowToDomain(AppSettingsData row) {
    return AppSettings(
      id: row.id,
      themeMode: row.themeMode,
      localeTag: row.localeTag,
      createdAtUtc: DateTime.parse(row.createdAtUtc),
      updatedAtUtc: DateTime.parse(row.updatedAtUtc),
      revision: row.revision,
    );
  }
}
