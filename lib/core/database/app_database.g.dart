// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL CHECK (id = 1)',
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL CHECK (theme_mode IN (\'system\', \'light\', \'dark\'))',
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _localeTagMeta = const VerificationMeta(
    'localeTag',
  );
  @override
  late final GeneratedColumn<String> localeTag = GeneratedColumn<String>(
    'locale_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL CHECK (locale_tag = \'ar\')',
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<String> createdAtUtc = GeneratedColumn<String>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<String> updatedAtUtc = GeneratedColumn<String>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL CHECK (revision >= 0)',
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    localeTag,
    createdAtUtc,
    updatedAtUtc,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('locale_tag')) {
      context.handle(
        _localeTagMeta,
        localeTag.isAcceptableOrUnknown(data['locale_tag']!, _localeTagMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      localeTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_tag'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsData extends DataClass implements Insertable<AppSettingsData> {
  /// Primary key singleton constraint: id is always 1.
  final int id;

  /// Theme mode: `system`, `light`, or `dark`.
  final String themeMode;

  /// Selected locale BCP-47 tag. Restricted to `ar` in this foundational phase.
  final String localeTag;

  /// Immutable UTC creation instant formatted as ISO-8601 string.
  final String createdAtUtc;

  /// Last updated UTC instant formatted as ISO-8601 string.
  final String updatedAtUtc;

  /// Non-negative monotonically increasing revision counter.
  final int revision;
  const AppSettingsData({
    required this.id,
    required this.themeMode,
    required this.localeTag,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['locale_tag'] = Variable<String>(localeTag);
    map['created_at_utc'] = Variable<String>(createdAtUtc);
    map['updated_at_utc'] = Variable<String>(updatedAtUtc);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      localeTag: Value(localeTag),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      revision: Value(revision),
    );
  }

  factory AppSettingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsData(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      localeTag: serializer.fromJson<String>(json['localeTag']),
      createdAtUtc: serializer.fromJson<String>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<String>(json['updatedAtUtc']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'localeTag': serializer.toJson<String>(localeTag),
      'createdAtUtc': serializer.toJson<String>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<String>(updatedAtUtc),
      'revision': serializer.toJson<int>(revision),
    };
  }

  AppSettingsData copyWith({
    int? id,
    String? themeMode,
    String? localeTag,
    String? createdAtUtc,
    String? updatedAtUtc,
    int? revision,
  }) => AppSettingsData(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    localeTag: localeTag ?? this.localeTag,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    revision: revision ?? this.revision,
  );
  AppSettingsData copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingsData(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      localeTag: data.localeTag.present ? data.localeTag.value : this.localeTag,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsData(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeTag: $localeTag, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsData &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.localeTag == this.localeTag &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.revision == this.revision);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingsData> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> localeTag;
  final Value<String> createdAtUtc;
  final Value<String> updatedAtUtc;
  final Value<int> revision;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localeTag = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.revision = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localeTag = const Value.absent(),
    required String createdAtUtc,
    required String updatedAtUtc,
    this.revision = const Value.absent(),
  }) : createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<AppSettingsData> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? localeTag,
    Expression<String>? createdAtUtc,
    Expression<String>? updatedAtUtc,
    Expression<int>? revision,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (localeTag != null) 'locale_tag': localeTag,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (revision != null) 'revision': revision,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? localeTag,
    Value<String>? createdAtUtc,
    Value<String>? updatedAtUtc,
    Value<int>? revision,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      localeTag: localeTag ?? this.localeTag,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      revision: revision ?? this.revision,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (localeTag.present) {
      map['locale_tag'] = Variable<String>(localeTag.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<String>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<String>(updatedAtUtc.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeTag: $localeTag, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePiastresMeta = const VerificationMeta(
    'unitPricePiastres',
  );
  @override
  late final GeneratedColumn<int> unitPricePiastres = GeneratedColumn<int>(
    'unit_price_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (unit_price_piastres >= 0)',
  );
  static const VerificationMeta _normalizedSearchTextMeta =
      const VerificationMeta('normalizedSearchText');
  @override
  late final GeneratedColumn<String> normalizedSearchText =
      GeneratedColumn<String>(
        'normalized_search_text',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    category,
    unit,
    unitPricePiastres,
    normalizedSearchText,
    barcode,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('unit_price_piastres')) {
      context.handle(
        _unitPricePiastresMeta,
        unitPricePiastres.isAcceptableOrUnknown(
          data['unit_price_piastres']!,
          _unitPricePiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePiastresMeta);
    }
    if (data.containsKey('normalized_search_text')) {
      context.handle(
        _normalizedSearchTextMeta,
        normalizedSearchText.isAcceptableOrUnknown(
          data['normalized_search_text']!,
          _normalizedSearchTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedSearchTextMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      unitPricePiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_piastres'],
      )!,
      normalizedSearchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_search_text'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductEntry extends DataClass implements Insertable<ProductEntry> {
  /// Primary key autoincrement integer ID.
  final int id;

  /// Unique shop/supplier product code.
  final String code;

  /// Full Arabic product name and dimensions.
  final String name;

  /// Material/domain category (e.g., مواسير, محابس, لوازم).
  final String category;

  /// Unit of measure (e.g., قطعة, متر, طقم).
  final String unit;

  /// Unit price in integer minor units (piastres / قروش).
  /// Strictly non-negative.
  final int unitPricePiastres;

  /// Pre-normalized search index string for resilient Arabic matching.
  final String normalizedSearchText;

  /// Optional barcode or SKU.
  final String? barcode;

  /// Optional notes.
  final String? notes;

  /// Creation timestamp as milliseconds since epoch.
  final int createdAt;

  /// Modification timestamp as milliseconds since epoch.
  final int updatedAt;
  const ProductEntry({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.unit,
    required this.unitPricePiastres,
    required this.normalizedSearchText,
    this.barcode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['unit'] = Variable<String>(unit);
    map['unit_price_piastres'] = Variable<int>(unitPricePiastres);
    map['normalized_search_text'] = Variable<String>(normalizedSearchText);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ProductCompanion toCompanion(bool nullToAbsent) {
    return ProductCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      category: Value(category),
      unit: Value(unit),
      unitPricePiastres: Value(unitPricePiastres),
      normalizedSearchText: Value(normalizedSearchText),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEntry(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPricePiastres: serializer.fromJson<int>(json['unitPricePiastres']),
      normalizedSearchText: serializer.fromJson<String>(
        json['normalizedSearchText'],
      ),
      barcode: serializer.fromJson<String?>(json['barcode']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'unit': serializer.toJson<String>(unit),
      'unitPricePiastres': serializer.toJson<int>(unitPricePiastres),
      'normalizedSearchText': serializer.toJson<String>(normalizedSearchText),
      'barcode': serializer.toJson<String?>(barcode),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ProductEntry copyWith({
    int? id,
    String? code,
    String? name,
    String? category,
    String? unit,
    int? unitPricePiastres,
    String? normalizedSearchText,
    Value<String?> barcode = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ProductEntry(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    category: category ?? this.category,
    unit: unit ?? this.unit,
    unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
    normalizedSearchText: normalizedSearchText ?? this.normalizedSearchText,
    barcode: barcode.present ? barcode.value : this.barcode,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductEntry copyWithCompanion(ProductCompanion data) {
    return ProductEntry(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPricePiastres: data.unitPricePiastres.present
          ? data.unitPricePiastres.value
          : this.unitPricePiastres,
      normalizedSearchText: data.normalizedSearchText.present
          ? data.normalizedSearchText.value
          : this.normalizedSearchText,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntry(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('unitPricePiastres: $unitPricePiastres, ')
          ..write('normalizedSearchText: $normalizedSearchText, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    category,
    unit,
    unitPricePiastres,
    normalizedSearchText,
    barcode,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEntry &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.unitPricePiastres == this.unitPricePiastres &&
          other.normalizedSearchText == this.normalizedSearchText &&
          other.barcode == this.barcode &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductCompanion extends UpdateCompanion<ProductEntry> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> category;
  final Value<String> unit;
  final Value<int> unitPricePiastres;
  final Value<String> normalizedSearchText;
  final Value<String?> barcode;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const ProductCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPricePiastres = const Value.absent(),
    this.normalizedSearchText = const Value.absent(),
    this.barcode = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    required String normalizedSearchText,
    this.barcode = const Value.absent(),
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : code = Value(code),
       name = Value(name),
       category = Value(category),
       unit = Value(unit),
       unitPricePiastres = Value(unitPricePiastres),
       normalizedSearchText = Value(normalizedSearchText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProductEntry> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<int>? unitPricePiastres,
    Expression<String>? normalizedSearchText,
    Expression<String>? barcode,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (unitPricePiastres != null) 'unit_price_piastres': unitPricePiastres,
      if (normalizedSearchText != null)
        'normalized_search_text': normalizedSearchText,
      if (barcode != null) 'barcode': barcode,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? category,
    Value<String>? unit,
    Value<int>? unitPricePiastres,
    Value<String>? normalizedSearchText,
    Value<String?>? barcode,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return ProductCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
      normalizedSearchText: normalizedSearchText ?? this.normalizedSearchText,
      barcode: barcode ?? this.barcode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPricePiastres.present) {
      map['unit_price_piastres'] = Variable<int>(unitPricePiastres.value);
    }
    if (normalizedSearchText.present) {
      map['normalized_search_text'] = Variable<String>(
        normalizedSearchText.value,
      );
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('unitPricePiastres: $unitPricePiastres, ')
          ..write('normalizedSearchText: $normalizedSearchText, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $QuotationsTableTable extends QuotationsTable
    with TableInfo<$QuotationsTableTable, QuotationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceNumberMeta = const VerificationMeta(
    'referenceNumber',
  );
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
    'reference_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<int> issueDate = GeneratedColumn<int>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<int> validUntil = GeneratedColumn<int>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalPiastresMeta = const VerificationMeta(
    'subtotalPiastres',
  );
  @override
  late final GeneratedColumn<int> subtotalPiastres = GeneratedColumn<int>(
    'subtotal_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (subtotal_piastres >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _discountPiastresMeta = const VerificationMeta(
    'discountPiastres',
  );
  @override
  late final GeneratedColumn<int> discountPiastres = GeneratedColumn<int>(
    'discount_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (discount_piastres >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _taxPiastresMeta = const VerificationMeta(
    'taxPiastres',
  );
  @override
  late final GeneratedColumn<int> taxPiastres = GeneratedColumn<int>(
    'tax_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (tax_piastres >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _grandTotalPiastresMeta =
      const VerificationMeta('grandTotalPiastres');
  @override
  late final GeneratedColumn<int> grandTotalPiastres = GeneratedColumn<int>(
    'grand_total_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (grand_total_piastres >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    referenceNumber,
    customerName,
    customerPhone,
    status,
    issueDate,
    validUntil,
    notes,
    subtotalPiastres,
    discountPiastres,
    taxPiastres,
    grandTotalPiastres,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuotationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
        _referenceNumberMeta,
        referenceNumber.isAcceptableOrUnknown(
          data['reference_number']!,
          _referenceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('subtotal_piastres')) {
      context.handle(
        _subtotalPiastresMeta,
        subtotalPiastres.isAcceptableOrUnknown(
          data['subtotal_piastres']!,
          _subtotalPiastresMeta,
        ),
      );
    }
    if (data.containsKey('discount_piastres')) {
      context.handle(
        _discountPiastresMeta,
        discountPiastres.isAcceptableOrUnknown(
          data['discount_piastres']!,
          _discountPiastresMeta,
        ),
      );
    }
    if (data.containsKey('tax_piastres')) {
      context.handle(
        _taxPiastresMeta,
        taxPiastres.isAcceptableOrUnknown(
          data['tax_piastres']!,
          _taxPiastresMeta,
        ),
      );
    }
    if (data.containsKey('grand_total_piastres')) {
      context.handle(
        _grandTotalPiastresMeta,
        grandTotalPiastres.isAcceptableOrUnknown(
          data['grand_total_piastres']!,
          _grandTotalPiastresMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuotationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuotationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      referenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_number'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}issue_date'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_until'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      subtotalPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_piastres'],
      )!,
      discountPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_piastres'],
      )!,
      taxPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_piastres'],
      )!,
      grandTotalPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grand_total_piastres'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $QuotationsTableTable createAlias(String alias) {
    return $QuotationsTableTable(attachedDatabase, alias);
  }
}

class QuotationEntry extends DataClass implements Insertable<QuotationEntry> {
  /// Primary key autoincrement ID.
  final int id;

  /// Human-readable sequential reference number (e.g. QT-2026-0001).
  final String referenceNumber;

  /// Customer or company name.
  final String customerName;

  /// Optional contact phone number.
  final String? customerPhone;

  /// Quotation lifecycle status: draft, sent, accepted, rejected, convertedToInvoice.
  final String status;

  /// Issue date timestamp in milliseconds since epoch.
  final int issueDate;

  /// Optional validity expiration date timestamp in milliseconds since epoch.
  final int? validUntil;

  /// Optional internal notes or payment terms.
  final String? notes;

  /// Sum of line totals in integer piastres.
  final int subtotalPiastres;

  /// Global order discount in integer piastres.
  final int discountPiastres;

  /// Tax amount in integer piastres.
  final int taxPiastres;

  /// Grand total: subtotal - discount + tax in integer piastres.
  final int grandTotalPiastres;

  /// Creation timestamp as milliseconds since epoch.
  final int createdAt;

  /// Modification timestamp as milliseconds since epoch.
  final int updatedAt;
  const QuotationEntry({
    required this.id,
    required this.referenceNumber,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.issueDate,
    this.validUntil,
    this.notes,
    required this.subtotalPiastres,
    required this.discountPiastres,
    required this.taxPiastres,
    required this.grandTotalPiastres,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['status'] = Variable<String>(status);
    map['issue_date'] = Variable<int>(issueDate);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<int>(validUntil);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['subtotal_piastres'] = Variable<int>(subtotalPiastres);
    map['discount_piastres'] = Variable<int>(discountPiastres);
    map['tax_piastres'] = Variable<int>(taxPiastres);
    map['grand_total_piastres'] = Variable<int>(grandTotalPiastres);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  QuotationCompanion toCompanion(bool nullToAbsent) {
    return QuotationCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      status: Value(status),
      issueDate: Value(issueDate),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      subtotalPiastres: Value(subtotalPiastres),
      discountPiastres: Value(discountPiastres),
      taxPiastres: Value(taxPiastres),
      grandTotalPiastres: Value(grandTotalPiastres),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory QuotationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuotationEntry(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      status: serializer.fromJson<String>(json['status']),
      issueDate: serializer.fromJson<int>(json['issueDate']),
      validUntil: serializer.fromJson<int?>(json['validUntil']),
      notes: serializer.fromJson<String?>(json['notes']),
      subtotalPiastres: serializer.fromJson<int>(json['subtotalPiastres']),
      discountPiastres: serializer.fromJson<int>(json['discountPiastres']),
      taxPiastres: serializer.fromJson<int>(json['taxPiastres']),
      grandTotalPiastres: serializer.fromJson<int>(json['grandTotalPiastres']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'status': serializer.toJson<String>(status),
      'issueDate': serializer.toJson<int>(issueDate),
      'validUntil': serializer.toJson<int?>(validUntil),
      'notes': serializer.toJson<String?>(notes),
      'subtotalPiastres': serializer.toJson<int>(subtotalPiastres),
      'discountPiastres': serializer.toJson<int>(discountPiastres),
      'taxPiastres': serializer.toJson<int>(taxPiastres),
      'grandTotalPiastres': serializer.toJson<int>(grandTotalPiastres),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  QuotationEntry copyWith({
    int? id,
    String? referenceNumber,
    String? customerName,
    Value<String?> customerPhone = const Value.absent(),
    String? status,
    int? issueDate,
    Value<int?> validUntil = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? subtotalPiastres,
    int? discountPiastres,
    int? taxPiastres,
    int? grandTotalPiastres,
    int? createdAt,
    int? updatedAt,
  }) => QuotationEntry(
    id: id ?? this.id,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    status: status ?? this.status,
    issueDate: issueDate ?? this.issueDate,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    notes: notes.present ? notes.value : this.notes,
    subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
    discountPiastres: discountPiastres ?? this.discountPiastres,
    taxPiastres: taxPiastres ?? this.taxPiastres,
    grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  QuotationEntry copyWithCompanion(QuotationCompanion data) {
    return QuotationEntry(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      status: data.status.present ? data.status.value : this.status,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      notes: data.notes.present ? data.notes.value : this.notes,
      subtotalPiastres: data.subtotalPiastres.present
          ? data.subtotalPiastres.value
          : this.subtotalPiastres,
      discountPiastres: data.discountPiastres.present
          ? data.discountPiastres.value
          : this.discountPiastres,
      taxPiastres: data.taxPiastres.present
          ? data.taxPiastres.value
          : this.taxPiastres,
      grandTotalPiastres: data.grandTotalPiastres.present
          ? data.grandTotalPiastres.value
          : this.grandTotalPiastres,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuotationEntry(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('issueDate: $issueDate, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('subtotalPiastres: $subtotalPiastres, ')
          ..write('discountPiastres: $discountPiastres, ')
          ..write('taxPiastres: $taxPiastres, ')
          ..write('grandTotalPiastres: $grandTotalPiastres, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    referenceNumber,
    customerName,
    customerPhone,
    status,
    issueDate,
    validUntil,
    notes,
    subtotalPiastres,
    discountPiastres,
    taxPiastres,
    grandTotalPiastres,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuotationEntry &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.status == this.status &&
          other.issueDate == this.issueDate &&
          other.validUntil == this.validUntil &&
          other.notes == this.notes &&
          other.subtotalPiastres == this.subtotalPiastres &&
          other.discountPiastres == this.discountPiastres &&
          other.taxPiastres == this.taxPiastres &&
          other.grandTotalPiastres == this.grandTotalPiastres &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QuotationCompanion extends UpdateCompanion<QuotationEntry> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<String> status;
  final Value<int> issueDate;
  final Value<int?> validUntil;
  final Value<String?> notes;
  final Value<int> subtotalPiastres;
  final Value<int> discountPiastres;
  final Value<int> taxPiastres;
  final Value<int> grandTotalPiastres;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const QuotationCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotalPiastres = const Value.absent(),
    this.discountPiastres = const Value.absent(),
    this.taxPiastres = const Value.absent(),
    this.grandTotalPiastres = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  QuotationCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    required String customerName,
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    required int issueDate,
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotalPiastres = const Value.absent(),
    this.discountPiastres = const Value.absent(),
    this.taxPiastres = const Value.absent(),
    this.grandTotalPiastres = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : referenceNumber = Value(referenceNumber),
       customerName = Value(customerName),
       issueDate = Value(issueDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<QuotationEntry> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? status,
    Expression<int>? issueDate,
    Expression<int>? validUntil,
    Expression<String>? notes,
    Expression<int>? subtotalPiastres,
    Expression<int>? discountPiastres,
    Expression<int>? taxPiastres,
    Expression<int>? grandTotalPiastres,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (status != null) 'status': status,
      if (issueDate != null) 'issue_date': issueDate,
      if (validUntil != null) 'valid_until': validUntil,
      if (notes != null) 'notes': notes,
      if (subtotalPiastres != null) 'subtotal_piastres': subtotalPiastres,
      if (discountPiastres != null) 'discount_piastres': discountPiastres,
      if (taxPiastres != null) 'tax_piastres': taxPiastres,
      if (grandTotalPiastres != null)
        'grand_total_piastres': grandTotalPiastres,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  QuotationCompanion copyWith({
    Value<int>? id,
    Value<String>? referenceNumber,
    Value<String>? customerName,
    Value<String?>? customerPhone,
    Value<String>? status,
    Value<int>? issueDate,
    Value<int?>? validUntil,
    Value<String?>? notes,
    Value<int>? subtotalPiastres,
    Value<int>? discountPiastres,
    Value<int>? taxPiastres,
    Value<int>? grandTotalPiastres,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return QuotationCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      validUntil: validUntil ?? this.validUntil,
      notes: notes ?? this.notes,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<int>(issueDate.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<int>(validUntil.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (subtotalPiastres.present) {
      map['subtotal_piastres'] = Variable<int>(subtotalPiastres.value);
    }
    if (discountPiastres.present) {
      map['discount_piastres'] = Variable<int>(discountPiastres.value);
    }
    if (taxPiastres.present) {
      map['tax_piastres'] = Variable<int>(taxPiastres.value);
    }
    if (grandTotalPiastres.present) {
      map['grand_total_piastres'] = Variable<int>(grandTotalPiastres.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotationCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('issueDate: $issueDate, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('subtotalPiastres: $subtotalPiastres, ')
          ..write('discountPiastres: $discountPiastres, ')
          ..write('taxPiastres: $taxPiastres, ')
          ..write('grandTotalPiastres: $grandTotalPiastres, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $QuotationItemsTableTable extends QuotationItemsTable
    with TableInfo<$QuotationItemsTableTable, QuotationItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotationItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quotationIdMeta = const VerificationMeta(
    'quotationId',
  );
  @override
  late final GeneratedColumn<int> quotationId = GeneratedColumn<int>(
    'quotation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES quotations(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePiastresMeta = const VerificationMeta(
    'unitPricePiastres',
  );
  @override
  late final GeneratedColumn<int> unitPricePiastres = GeneratedColumn<int>(
    'unit_price_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (unit_price_piastres >= 0)',
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (quantity > 0)',
  );
  static const VerificationMeta _lineDiscountPiastresMeta =
      const VerificationMeta('lineDiscountPiastres');
  @override
  late final GeneratedColumn<int> lineDiscountPiastres = GeneratedColumn<int>(
    'line_discount_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT 0 CHECK (line_discount_piastres >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _lineTotalPiastresMeta = const VerificationMeta(
    'lineTotalPiastres',
  );
  @override
  late final GeneratedColumn<int> lineTotalPiastres = GeneratedColumn<int>(
    'line_total_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (line_total_piastres >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quotationId,
    productId,
    productCode,
    productName,
    unit,
    unitPricePiastres,
    quantity,
    lineDiscountPiastres,
    lineTotalPiastres,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotation_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuotationItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quotation_id')) {
      context.handle(
        _quotationIdMeta,
        quotationId.isAcceptableOrUnknown(
          data['quotation_id']!,
          _quotationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quotationIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCodeMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('unit_price_piastres')) {
      context.handle(
        _unitPricePiastresMeta,
        unitPricePiastres.isAcceptableOrUnknown(
          data['unit_price_piastres']!,
          _unitPricePiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePiastresMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('line_discount_piastres')) {
      context.handle(
        _lineDiscountPiastresMeta,
        lineDiscountPiastres.isAcceptableOrUnknown(
          data['line_discount_piastres']!,
          _lineDiscountPiastresMeta,
        ),
      );
    }
    if (data.containsKey('line_total_piastres')) {
      context.handle(
        _lineTotalPiastresMeta,
        lineTotalPiastres.isAcceptableOrUnknown(
          data['line_total_piastres']!,
          _lineTotalPiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineTotalPiastresMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuotationItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuotationItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quotationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quotation_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      unitPricePiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_piastres'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      lineDiscountPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_discount_piastres'],
      )!,
      lineTotalPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total_piastres'],
      )!,
    );
  }

  @override
  $QuotationItemsTableTable createAlias(String alias) {
    return $QuotationItemsTableTable(attachedDatabase, alias);
  }
}

class QuotationItemEntry extends DataClass
    implements Insertable<QuotationItemEntry> {
  /// Primary key autoincrement ID.
  final int id;

  /// Foreign key referencing the parent quotation.
  final int quotationId;

  /// Optional foreign key to catalog product (null for custom line items).
  final int? productId;

  /// Snapshot of product code at quotation creation time.
  final String productCode;

  /// Snapshot of Arabic product name at quotation creation time.
  final String productName;

  /// Snapshot of unit of measure (e.g. قطعة, متر).
  final String unit;

  /// Snapshot of unit price in integer piastres (1 EGP = 100 piastres).
  final int unitPricePiastres;

  /// Quantity ordered (positive integer).
  final int quantity;

  /// Line-level discount in integer piastres.
  final int lineDiscountPiastres;

  /// Calculated line total: (unitPrice * quantity) - lineDiscount.
  final int lineTotalPiastres;
  const QuotationItemEntry({
    required this.id,
    required this.quotationId,
    this.productId,
    required this.productCode,
    required this.productName,
    required this.unit,
    required this.unitPricePiastres,
    required this.quantity,
    required this.lineDiscountPiastres,
    required this.lineTotalPiastres,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quotation_id'] = Variable<int>(quotationId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['product_code'] = Variable<String>(productCode);
    map['product_name'] = Variable<String>(productName);
    map['unit'] = Variable<String>(unit);
    map['unit_price_piastres'] = Variable<int>(unitPricePiastres);
    map['quantity'] = Variable<int>(quantity);
    map['line_discount_piastres'] = Variable<int>(lineDiscountPiastres);
    map['line_total_piastres'] = Variable<int>(lineTotalPiastres);
    return map;
  }

  QuotationItemCompanion toCompanion(bool nullToAbsent) {
    return QuotationItemCompanion(
      id: Value(id),
      quotationId: Value(quotationId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productCode: Value(productCode),
      productName: Value(productName),
      unit: Value(unit),
      unitPricePiastres: Value(unitPricePiastres),
      quantity: Value(quantity),
      lineDiscountPiastres: Value(lineDiscountPiastres),
      lineTotalPiastres: Value(lineTotalPiastres),
    );
  }

  factory QuotationItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuotationItemEntry(
      id: serializer.fromJson<int>(json['id']),
      quotationId: serializer.fromJson<int>(json['quotationId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productCode: serializer.fromJson<String>(json['productCode']),
      productName: serializer.fromJson<String>(json['productName']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPricePiastres: serializer.fromJson<int>(json['unitPricePiastres']),
      quantity: serializer.fromJson<int>(json['quantity']),
      lineDiscountPiastres: serializer.fromJson<int>(
        json['lineDiscountPiastres'],
      ),
      lineTotalPiastres: serializer.fromJson<int>(json['lineTotalPiastres']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quotationId': serializer.toJson<int>(quotationId),
      'productId': serializer.toJson<int?>(productId),
      'productCode': serializer.toJson<String>(productCode),
      'productName': serializer.toJson<String>(productName),
      'unit': serializer.toJson<String>(unit),
      'unitPricePiastres': serializer.toJson<int>(unitPricePiastres),
      'quantity': serializer.toJson<int>(quantity),
      'lineDiscountPiastres': serializer.toJson<int>(lineDiscountPiastres),
      'lineTotalPiastres': serializer.toJson<int>(lineTotalPiastres),
    };
  }

  QuotationItemEntry copyWith({
    int? id,
    int? quotationId,
    Value<int?> productId = const Value.absent(),
    String? productCode,
    String? productName,
    String? unit,
    int? unitPricePiastres,
    int? quantity,
    int? lineDiscountPiastres,
    int? lineTotalPiastres,
  }) => QuotationItemEntry(
    id: id ?? this.id,
    quotationId: quotationId ?? this.quotationId,
    productId: productId.present ? productId.value : this.productId,
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    unit: unit ?? this.unit,
    unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
    quantity: quantity ?? this.quantity,
    lineDiscountPiastres: lineDiscountPiastres ?? this.lineDiscountPiastres,
    lineTotalPiastres: lineTotalPiastres ?? this.lineTotalPiastres,
  );
  QuotationItemEntry copyWithCompanion(QuotationItemCompanion data) {
    return QuotationItemEntry(
      id: data.id.present ? data.id.value : this.id,
      quotationId: data.quotationId.present
          ? data.quotationId.value
          : this.quotationId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPricePiastres: data.unitPricePiastres.present
          ? data.unitPricePiastres.value
          : this.unitPricePiastres,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      lineDiscountPiastres: data.lineDiscountPiastres.present
          ? data.lineDiscountPiastres.value
          : this.lineDiscountPiastres,
      lineTotalPiastres: data.lineTotalPiastres.present
          ? data.lineTotalPiastres.value
          : this.lineTotalPiastres,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuotationItemEntry(')
          ..write('id: $id, ')
          ..write('quotationId: $quotationId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPricePiastres: $unitPricePiastres, ')
          ..write('quantity: $quantity, ')
          ..write('lineDiscountPiastres: $lineDiscountPiastres, ')
          ..write('lineTotalPiastres: $lineTotalPiastres')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quotationId,
    productId,
    productCode,
    productName,
    unit,
    unitPricePiastres,
    quantity,
    lineDiscountPiastres,
    lineTotalPiastres,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuotationItemEntry &&
          other.id == this.id &&
          other.quotationId == this.quotationId &&
          other.productId == this.productId &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.unit == this.unit &&
          other.unitPricePiastres == this.unitPricePiastres &&
          other.quantity == this.quantity &&
          other.lineDiscountPiastres == this.lineDiscountPiastres &&
          other.lineTotalPiastres == this.lineTotalPiastres);
}

class QuotationItemCompanion extends UpdateCompanion<QuotationItemEntry> {
  final Value<int> id;
  final Value<int> quotationId;
  final Value<int?> productId;
  final Value<String> productCode;
  final Value<String> productName;
  final Value<String> unit;
  final Value<int> unitPricePiastres;
  final Value<int> quantity;
  final Value<int> lineDiscountPiastres;
  final Value<int> lineTotalPiastres;
  const QuotationItemCompanion({
    this.id = const Value.absent(),
    this.quotationId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPricePiastres = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lineDiscountPiastres = const Value.absent(),
    this.lineTotalPiastres = const Value.absent(),
  });
  QuotationItemCompanion.insert({
    this.id = const Value.absent(),
    required int quotationId,
    this.productId = const Value.absent(),
    required String productCode,
    required String productName,
    required String unit,
    required int unitPricePiastres,
    required int quantity,
    this.lineDiscountPiastres = const Value.absent(),
    required int lineTotalPiastres,
  }) : quotationId = Value(quotationId),
       productCode = Value(productCode),
       productName = Value(productName),
       unit = Value(unit),
       unitPricePiastres = Value(unitPricePiastres),
       quantity = Value(quantity),
       lineTotalPiastres = Value(lineTotalPiastres);
  static Insertable<QuotationItemEntry> custom({
    Expression<int>? id,
    Expression<int>? quotationId,
    Expression<int>? productId,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<String>? unit,
    Expression<int>? unitPricePiastres,
    Expression<int>? quantity,
    Expression<int>? lineDiscountPiastres,
    Expression<int>? lineTotalPiastres,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quotationId != null) 'quotation_id': quotationId,
      if (productId != null) 'product_id': productId,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (unit != null) 'unit': unit,
      if (unitPricePiastres != null) 'unit_price_piastres': unitPricePiastres,
      if (quantity != null) 'quantity': quantity,
      if (lineDiscountPiastres != null)
        'line_discount_piastres': lineDiscountPiastres,
      if (lineTotalPiastres != null) 'line_total_piastres': lineTotalPiastres,
    });
  }

  QuotationItemCompanion copyWith({
    Value<int>? id,
    Value<int>? quotationId,
    Value<int?>? productId,
    Value<String>? productCode,
    Value<String>? productName,
    Value<String>? unit,
    Value<int>? unitPricePiastres,
    Value<int>? quantity,
    Value<int>? lineDiscountPiastres,
    Value<int>? lineTotalPiastres,
  }) {
    return QuotationItemCompanion(
      id: id ?? this.id,
      quotationId: quotationId ?? this.quotationId,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
      quantity: quantity ?? this.quantity,
      lineDiscountPiastres: lineDiscountPiastres ?? this.lineDiscountPiastres,
      lineTotalPiastres: lineTotalPiastres ?? this.lineTotalPiastres,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quotationId.present) {
      map['quotation_id'] = Variable<int>(quotationId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPricePiastres.present) {
      map['unit_price_piastres'] = Variable<int>(unitPricePiastres.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (lineDiscountPiastres.present) {
      map['line_discount_piastres'] = Variable<int>(lineDiscountPiastres.value);
    }
    if (lineTotalPiastres.present) {
      map['line_total_piastres'] = Variable<int>(lineTotalPiastres.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotationItemCompanion(')
          ..write('id: $id, ')
          ..write('quotationId: $quotationId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPricePiastres: $unitPricePiastres, ')
          ..write('quantity: $quantity, ')
          ..write('lineDiscountPiastres: $lineDiscountPiastres, ')
          ..write('lineTotalPiastres: $lineTotalPiastres')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $QuotationsTableTable quotationsTable = $QuotationsTableTable(
    this,
  );
  late final $QuotationItemsTableTable quotationItemsTable =
      $QuotationItemsTableTable(this);
  late final Index idxAppSettingsId = Index(
    'idx_app_settings_id',
    'CREATE INDEX idx_app_settings_id ON app_settings (id)',
  );
  late final Index idxProductsCode = Index(
    'idx_products_code',
    'CREATE UNIQUE INDEX idx_products_code ON products (code)',
  );
  late final Index idxProductsCategory = Index(
    'idx_products_category',
    'CREATE INDEX idx_products_category ON products (category)',
  );
  late final Index idxProductsSearch = Index(
    'idx_products_search',
    'CREATE INDEX idx_products_search ON products (normalized_search_text)',
  );
  late final Index idxQuotationsRef = Index(
    'idx_quotations_ref',
    'CREATE UNIQUE INDEX idx_quotations_ref ON quotations (reference_number)',
  );
  late final Index idxQuotationsCustomer = Index(
    'idx_quotations_customer',
    'CREATE INDEX idx_quotations_customer ON quotations (customer_name)',
  );
  late final Index idxQuotationsStatus = Index(
    'idx_quotations_status',
    'CREATE INDEX idx_quotations_status ON quotations (status)',
  );
  late final Index idxQuotationItemsQuotationId = Index(
    'idx_quotation_items_quotation_id',
    'CREATE INDEX idx_quotation_items_quotation_id ON quotation_items (quotation_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettingsTable,
    productsTable,
    quotationsTable,
    quotationItemsTable,
    idxAppSettingsId,
    idxProductsCode,
    idxProductsCategory,
    idxProductsSearch,
    idxQuotationsRef,
    idxQuotationsCustomer,
    idxQuotationsStatus,
    idxQuotationItemsQuotationId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quotation_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quotation_items', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> localeTag,
      required String createdAtUtc,
      required String updatedAtUtc,
      Value<int> revision,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> localeTag,
      Value<String> createdAtUtc,
      Value<String> updatedAtUtc,
      Value<int> revision,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeTag => $composableBuilder(
    column: $table.localeTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeTag => $composableBuilder(
    column: $table.localeTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get localeTag =>
      $composableBuilder(column: $table.localeTag, builder: (column) => column);

  GeneratedColumn<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsData
            >,
          ),
          AppSettingsData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> localeTag = const Value.absent(),
                Value<String> createdAtUtc = const Value.absent(),
                Value<String> updatedAtUtc = const Value.absent(),
                Value<int> revision = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                themeMode: themeMode,
                localeTag: localeTag,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                revision: revision,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> localeTag = const Value.absent(),
                required String createdAtUtc,
                required String updatedAtUtc,
                Value<int> revision = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                localeTag: localeTag,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                revision: revision,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingsData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingsData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsData,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingsData>,
      ),
      AppSettingsData,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableTableCreateCompanionBuilder = ProductCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  required String category,
  required String unit,
  required int unitPricePiastres,
  required String normalizedSearchText,
  Value<String?> barcode,
  Value<String?> notes,
  required int createdAt,
  required int updatedAt,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String> category,
  Value<String> unit,
  Value<int> unitPricePiastres,
  Value<String> normalizedSearchText,
  Value<String?> barcode,
  Value<String?> notes,
  Value<int> createdAt,
  Value<int> updatedAt,
});

final class $$ProductsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTableTable, ProductEntry> {
  $$ProductsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $QuotationItemsTableTable,
    List<QuotationItemEntry>
  >
  _quotationItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quotationItemsTable,
        aliasName: 'products__id__quotation_items__product_id',
      );

  $$QuotationItemsTableTableProcessedTableManager get quotationItemsTableRefs {
    final manager = $$QuotationItemsTableTableTableManager(
      $_db,
      $_db.quotationItemsTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quotationItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedSearchText => $composableBuilder(
    column: $table.normalizedSearchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quotationItemsTableRefs(
    Expression<bool> Function($$QuotationItemsTableTableFilterComposer f) f,
  ) {
    final $$QuotationItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotationItemsTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.quotationItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedSearchText => $composableBuilder(
    column: $table.normalizedSearchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedSearchText => $composableBuilder(
    column: $table.normalizedSearchText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> quotationItemsTableRefs<T extends Object>(
    Expression<T> Function($$QuotationItemsTableTableAnnotationComposer a) f,
  ) {
    final $$QuotationItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quotationItemsTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuotationItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.quotationItemsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTableTable,
          ProductEntry,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (ProductEntry, $$ProductsTableTableReferences),
          ProductEntry,
          PrefetchHooks Function({bool quotationItemsTableRefs})
        > {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> unitPricePiastres = const Value.absent(),
                Value<String> normalizedSearchText = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => ProductCompanion(
                id: id,
                code: code,
                name: name,
                category: category,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                normalizedSearchText: normalizedSearchText,
                barcode: barcode,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                required String category,
                required String unit,
                required int unitPricePiastres,
                required String normalizedSearchText,
                Value<String?> barcode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => ProductCompanion.insert(
                id: id,
                code: code,
                name: name,
                category: category,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                normalizedSearchText: normalizedSearchText,
                barcode: barcode,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTableTable, ProductEntry>(table),
                  $$ProductsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quotationItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (quotationItemsTableRefs) db.quotationItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quotationItemsTableRefs)
                    await $_getPrefetchedData<
                      ProductEntry,
                      $ProductsTableTable,
                      QuotationItemEntry
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableTableReferences
                          ._quotationItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).quotationItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTableTable,
      ProductEntry,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (ProductEntry, $$ProductsTableTableReferences),
      ProductEntry,
      PrefetchHooks Function({bool quotationItemsTableRefs})
    >;
typedef $$QuotationsTableTableCreateCompanionBuilder =
    QuotationCompanion Function({
      Value<int> id,
      required String referenceNumber,
      required String customerName,
      Value<String?> customerPhone,
      Value<String> status,
      required int issueDate,
      Value<int?> validUntil,
      Value<String?> notes,
      Value<int> subtotalPiastres,
      Value<int> discountPiastres,
      Value<int> taxPiastres,
      Value<int> grandTotalPiastres,
      required int createdAt,
      required int updatedAt,
    });
typedef $$QuotationsTableTableUpdateCompanionBuilder =
    QuotationCompanion Function({
      Value<int> id,
      Value<String> referenceNumber,
      Value<String> customerName,
      Value<String?> customerPhone,
      Value<String> status,
      Value<int> issueDate,
      Value<int?> validUntil,
      Value<String?> notes,
      Value<int> subtotalPiastres,
      Value<int> discountPiastres,
      Value<int> taxPiastres,
      Value<int> grandTotalPiastres,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$QuotationsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuotationsTableTable, QuotationEntry> {
  $$QuotationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $QuotationItemsTableTable,
    List<QuotationItemEntry>
  >
  _quotationItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quotationItemsTable,
        aliasName: 'quotations__id__quotation_items__quotation_id',
      );

  $$QuotationItemsTableTableProcessedTableManager get quotationItemsTableRefs {
    final manager = $$QuotationItemsTableTableTableManager(
      $_db,
      $_db.quotationItemsTable,
    ).filter((f) => f.quotationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quotationItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuotationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuotationsTableTable> {
  $$QuotationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalPiastres => $composableBuilder(
    column: $table.subtotalPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPiastres => $composableBuilder(
    column: $table.discountPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxPiastres => $composableBuilder(
    column: $table.taxPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grandTotalPiastres => $composableBuilder(
    column: $table.grandTotalPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quotationItemsTableRefs(
    Expression<bool> Function($$QuotationItemsTableTableFilterComposer f) f,
  ) {
    final $$QuotationItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotationItemsTable,
      getReferencedColumn: (t) => t.quotationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.quotationItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuotationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotationsTableTable> {
  $$QuotationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalPiastres => $composableBuilder(
    column: $table.subtotalPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPiastres => $composableBuilder(
    column: $table.discountPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxPiastres => $composableBuilder(
    column: $table.taxPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grandTotalPiastres => $composableBuilder(
    column: $table.grandTotalPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuotationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotationsTableTable> {
  $$QuotationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<int> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get subtotalPiastres => $composableBuilder(
    column: $table.subtotalPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountPiastres => $composableBuilder(
    column: $table.discountPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxPiastres => $composableBuilder(
    column: $table.taxPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grandTotalPiastres => $composableBuilder(
    column: $table.grandTotalPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> quotationItemsTableRefs<T extends Object>(
    Expression<T> Function($$QuotationItemsTableTableAnnotationComposer a) f,
  ) {
    final $$QuotationItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quotationItemsTable,
          getReferencedColumn: (t) => t.quotationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuotationItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.quotationItemsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuotationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotationsTableTable,
          QuotationEntry,
          $$QuotationsTableTableFilterComposer,
          $$QuotationsTableTableOrderingComposer,
          $$QuotationsTableTableAnnotationComposer,
          $$QuotationsTableTableCreateCompanionBuilder,
          $$QuotationsTableTableUpdateCompanionBuilder,
          (QuotationEntry, $$QuotationsTableTableReferences),
          QuotationEntry,
          PrefetchHooks Function({bool quotationItemsTableRefs})
        > {
  $$QuotationsTableTableTableManager(
    _$AppDatabase db,
    $QuotationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> referenceNumber = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> issueDate = const Value.absent(),
                Value<int?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> subtotalPiastres = const Value.absent(),
                Value<int> discountPiastres = const Value.absent(),
                Value<int> taxPiastres = const Value.absent(),
                Value<int> grandTotalPiastres = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => QuotationCompanion(
                id: id,
                referenceNumber: referenceNumber,
                customerName: customerName,
                customerPhone: customerPhone,
                status: status,
                issueDate: issueDate,
                validUntil: validUntil,
                notes: notes,
                subtotalPiastres: subtotalPiastres,
                discountPiastres: discountPiastres,
                taxPiastres: taxPiastres,
                grandTotalPiastres: grandTotalPiastres,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String referenceNumber,
                required String customerName,
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int issueDate,
                Value<int?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> subtotalPiastres = const Value.absent(),
                Value<int> discountPiastres = const Value.absent(),
                Value<int> taxPiastres = const Value.absent(),
                Value<int> grandTotalPiastres = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => QuotationCompanion.insert(
                id: id,
                referenceNumber: referenceNumber,
                customerName: customerName,
                customerPhone: customerPhone,
                status: status,
                issueDate: issueDate,
                validUntil: validUntil,
                notes: notes,
                subtotalPiastres: subtotalPiastres,
                discountPiastres: discountPiastres,
                taxPiastres: taxPiastres,
                grandTotalPiastres: grandTotalPiastres,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuotationsTableTable, QuotationEntry>(table),
                  $$QuotationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quotationItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (quotationItemsTableRefs) db.quotationItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quotationItemsTableRefs)
                    await $_getPrefetchedData<
                      QuotationEntry,
                      $QuotationsTableTable,
                      QuotationItemEntry
                    >(
                      currentTable: table,
                      referencedTable: $$QuotationsTableTableReferences
                          ._quotationItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuotationsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).quotationItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.quotationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuotationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotationsTableTable,
      QuotationEntry,
      $$QuotationsTableTableFilterComposer,
      $$QuotationsTableTableOrderingComposer,
      $$QuotationsTableTableAnnotationComposer,
      $$QuotationsTableTableCreateCompanionBuilder,
      $$QuotationsTableTableUpdateCompanionBuilder,
      (QuotationEntry, $$QuotationsTableTableReferences),
      QuotationEntry,
      PrefetchHooks Function({bool quotationItemsTableRefs})
    >;
typedef $$QuotationItemsTableTableCreateCompanionBuilder =
    QuotationItemCompanion Function({
      Value<int> id,
      required int quotationId,
      Value<int?> productId,
      required String productCode,
      required String productName,
      required String unit,
      required int unitPricePiastres,
      required int quantity,
      Value<int> lineDiscountPiastres,
      required int lineTotalPiastres,
    });
typedef $$QuotationItemsTableTableUpdateCompanionBuilder =
    QuotationItemCompanion Function({
      Value<int> id,
      Value<int> quotationId,
      Value<int?> productId,
      Value<String> productCode,
      Value<String> productName,
      Value<String> unit,
      Value<int> unitPricePiastres,
      Value<int> quantity,
      Value<int> lineDiscountPiastres,
      Value<int> lineTotalPiastres,
    });

final class $$QuotationItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuotationItemsTableTable,
          QuotationItemEntry
        > {
  $$QuotationItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotationsTableTable _quotationIdTable(_$AppDatabase db) => db
      .quotationsTable
      .createAlias('quotation_items__quotation_id__quotations__id');

  $$QuotationsTableTableProcessedTableManager get quotationId {
    final $_column = $_itemColumn<int>('quotation_id')!;

    final manager = $$QuotationsTableTableTableManager(
      $_db,
      $_db.quotationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quotationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTableTable _productIdTable(_$AppDatabase db) =>
      db.productsTable.createAlias('quotation_items__product_id__products__id');

  $$ProductsTableTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuotationItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuotationItemsTableTable> {
  $$QuotationItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineDiscountPiastres => $composableBuilder(
    column: $table.lineDiscountPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotalPiastres => $composableBuilder(
    column: $table.lineTotalPiastres,
    builder: (column) => ColumnFilters(column),
  );

  $$QuotationsTableTableFilterComposer get quotationId {
    final $$QuotationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quotationId,
      referencedTable: $db.quotationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableTableFilterComposer(
            $db: $db,
            $table: $db.quotationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableFilterComposer get productId {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotationItemsTableTable> {
  $$QuotationItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineDiscountPiastres => $composableBuilder(
    column: $table.lineDiscountPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotalPiastres => $composableBuilder(
    column: $table.lineTotalPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuotationsTableTableOrderingComposer get quotationId {
    final $$QuotationsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quotationId,
      referencedTable: $db.quotationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableTableOrderingComposer(
            $db: $db,
            $table: $db.quotationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableOrderingComposer get productId {
    final $$ProductsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableOrderingComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotationItemsTableTable> {
  $$QuotationItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPricePiastres => $composableBuilder(
    column: $table.unitPricePiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get lineDiscountPiastres => $composableBuilder(
    column: $table.lineDiscountPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineTotalPiastres => $composableBuilder(
    column: $table.lineTotalPiastres,
    builder: (column) => column,
  );

  $$QuotationsTableTableAnnotationComposer get quotationId {
    final $$QuotationsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quotationId,
      referencedTable: $db.quotationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.quotationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableAnnotationComposer get productId {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotationItemsTableTable,
          QuotationItemEntry,
          $$QuotationItemsTableTableFilterComposer,
          $$QuotationItemsTableTableOrderingComposer,
          $$QuotationItemsTableTableAnnotationComposer,
          $$QuotationItemsTableTableCreateCompanionBuilder,
          $$QuotationItemsTableTableUpdateCompanionBuilder,
          (QuotationItemEntry, $$QuotationItemsTableTableReferences),
          QuotationItemEntry,
          PrefetchHooks Function({bool quotationId, bool productId})
        > {
  $$QuotationItemsTableTableTableManager(
    _$AppDatabase db,
    $QuotationItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotationItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotationItemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuotationItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> quotationId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> unitPricePiastres = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> lineDiscountPiastres = const Value.absent(),
                Value<int> lineTotalPiastres = const Value.absent(),
              }) => QuotationItemCompanion(
                id: id,
                quotationId: quotationId,
                productId: productId,
                productCode: productCode,
                productName: productName,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                quantity: quantity,
                lineDiscountPiastres: lineDiscountPiastres,
                lineTotalPiastres: lineTotalPiastres,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int quotationId,
                Value<int?> productId = const Value.absent(),
                required String productCode,
                required String productName,
                required String unit,
                required int unitPricePiastres,
                required int quantity,
                Value<int> lineDiscountPiastres = const Value.absent(),
                required int lineTotalPiastres,
              }) => QuotationItemCompanion.insert(
                id: id,
                quotationId: quotationId,
                productId: productId,
                productCode: productCode,
                productName: productName,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                quantity: quantity,
                lineDiscountPiastres: lineDiscountPiastres,
                lineTotalPiastres: lineTotalPiastres,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuotationItemsTableTable, QuotationItemEntry>(
                    table,
                  ),
                  $$QuotationItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quotationId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quotationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.quotationId,
                        referencedTable: $$QuotationItemsTableTableReferences
                            ._quotationIdTable(db),
                        referencedColumn: $$QuotationItemsTableTableReferences
                            ._quotationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (productId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productId,
                        referencedTable: $$QuotationItemsTableTableReferences
                            ._productIdTable(db),
                        referencedColumn: $$QuotationItemsTableTableReferences
                            ._productIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuotationItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotationItemsTableTable,
      QuotationItemEntry,
      $$QuotationItemsTableTableFilterComposer,
      $$QuotationItemsTableTableOrderingComposer,
      $$QuotationItemsTableTableAnnotationComposer,
      $$QuotationItemsTableTableCreateCompanionBuilder,
      $$QuotationItemsTableTableUpdateCompanionBuilder,
      (QuotationItemEntry, $$QuotationItemsTableTableReferences),
      QuotationItemEntry,
      PrefetchHooks Function({bool quotationId, bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$QuotationsTableTableTableManager get quotationsTable =>
      $$QuotationsTableTableTableManager(_db, _db.quotationsTable);
  $$QuotationItemsTableTableTableManager get quotationItemsTable =>
      $$QuotationItemsTableTableTableManager(_db, _db.quotationItemsTable);
}
