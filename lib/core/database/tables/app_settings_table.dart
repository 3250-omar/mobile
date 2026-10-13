import 'package:drift/drift.dart';

/// Drift table definition for the foundational [AppSettings] singleton aggregate.
///
/// Contains strictly one row with id = 1.
@TableIndex(name: 'idx_app_settings_id', columns: {#id})
@DataClassName('AppSettingsData', companion: 'AppSettingsCompanion')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  /// Primary key singleton constraint: id is always 1.
  IntColumn get id => integer()
      .withDefault(const Constant(1))
      .customConstraint('NOT NULL CHECK (id = 1)')();

  /// Theme mode: `system`, `light`, or `dark`.
  TextColumn get themeMode => text()
      .withDefault(const Constant('system'))
      .customConstraint(
        "NOT NULL CHECK (theme_mode IN ('system', 'light', 'dark'))",
      )();

  /// Selected locale BCP-47 tag. Restricted to `ar` in this foundational phase.
  TextColumn get localeTag => text()
      .withDefault(const Constant('ar'))
      .customConstraint("NOT NULL CHECK (locale_tag = 'ar')")();

  /// Immutable UTC creation instant formatted as ISO-8601 string.
  TextColumn get createdAtUtc => text()();

  /// Last updated UTC instant formatted as ISO-8601 string.
  TextColumn get updatedAtUtc => text()();

  /// Non-negative monotonically increasing revision counter.
  IntColumn get revision => integer()
      .withDefault(const Constant(0))
      .customConstraint('NOT NULL CHECK (revision >= 0)')();

  @override
  Set<Column> get primaryKey => {id};
}
