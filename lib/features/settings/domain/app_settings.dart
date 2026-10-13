/// Foundational application settings singleton aggregate.
///
/// Guaranteed to be 100% offline with no network or cloud dependencies.
class AppSettings {
  const AppSettings({
    this.id = 1,
    this.themeMode = 'system',
    this.localeTag = 'ar',
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.revision = 0,
  }) : assert(id == 1, 'AppSettings id must be 1'),
       assert(
         themeMode == 'system' || themeMode == 'light' || themeMode == 'dark',
         'themeMode must be system, light, or dark',
       ),
       assert(
         localeTag == 'ar',
         'Only "ar" locale is selectable in this feature foundation',
       ),
       assert(revision >= 0, 'revision must be non-negative');

  /// Singleton primary key. Always 1.
  final int id;

  /// Selected theme mode: `system`, `light`, or `dark`.
  final String themeMode;

  /// BCP-47 language tag. Always `ar` in this foundation feature.
  final String localeTag;

  /// Immutable UTC creation instant.
  final DateTime createdAtUtc;

  /// Last updated UTC instant.
  final DateTime updatedAtUtc;

  /// Monotonically increasing revision counter per committed logical update.
  final int revision;

  /// Creates deterministic default settings for clean-install initialization.
  factory AppSettings.defaults({DateTime? now}) {
    final instant = (now ?? DateTime.now()).toUtc();
    return AppSettings(
      id: 1,
      themeMode: 'system',
      localeTag: 'ar',
      createdAtUtc: instant,
      updatedAtUtc: instant,
      revision: 0,
    );
  }

  AppSettings copyWith({
    String? themeMode,
    String? localeTag,
    DateTime? updatedAtUtc,
    int? revision,
  }) {
    return AppSettings(
      id: id,
      themeMode: themeMode ?? this.themeMode,
      localeTag: localeTag ?? this.localeTag,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      revision: revision ?? this.revision,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          themeMode == other.themeMode &&
          localeTag == other.localeTag &&
          createdAtUtc == other.createdAtUtc &&
          updatedAtUtc == other.updatedAtUtc &&
          revision == other.revision;

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    localeTag,
    createdAtUtc,
    updatedAtUtc,
    revision,
  );

  @override
  String toString() =>
      'AppSettings(theme: $themeMode, locale: $localeTag, rev: $revision, updated: $updatedAtUtc)';
}
