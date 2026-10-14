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

class $InvoicesTableTable extends InvoicesTable
    with TableInfo<$InvoicesTableTable, InvoiceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _quotationIdMeta = const VerificationMeta(
    'quotationId',
  );
  @override
  late final GeneratedColumn<int> quotationId = GeneratedColumn<int>(
    'quotation_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotations (id) ON DELETE SET NULL',
    ),
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
    defaultValue: const Constant('unpaid'),
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
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
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
    defaultValue: const Constant(0),
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
    defaultValue: const Constant(0),
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
    defaultValue: const Constant(0),
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
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAmountPiastresMeta =
      const VerificationMeta('paidAmountPiastres');
  @override
  late final GeneratedColumn<int> paidAmountPiastres = GeneratedColumn<int>(
    'paid_amount_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    quotationId,
    customerName,
    customerPhone,
    status,
    issueDate,
    dueDate,
    notes,
    subtotalPiastres,
    discountPiastres,
    taxPiastres,
    grandTotalPiastres,
    paidAmountPiastres,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceEntry> instance, {
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
    if (data.containsKey('quotation_id')) {
      context.handle(
        _quotationIdMeta,
        quotationId.isAcceptableOrUnknown(
          data['quotation_id']!,
          _quotationIdMeta,
        ),
      );
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
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
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
    if (data.containsKey('paid_amount_piastres')) {
      context.handle(
        _paidAmountPiastresMeta,
        paidAmountPiastres.isAcceptableOrUnknown(
          data['paid_amount_piastres']!,
          _paidAmountPiastresMeta,
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
  InvoiceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      referenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_number'],
      )!,
      quotationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quotation_id'],
      ),
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
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
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
      paidAmountPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount_piastres'],
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
  $InvoicesTableTable createAlias(String alias) {
    return $InvoicesTableTable(attachedDatabase, alias);
  }
}

class InvoiceEntry extends DataClass implements Insertable<InvoiceEntry> {
  final int id;
  final String referenceNumber;
  final int? quotationId;
  final String customerName;
  final String? customerPhone;
  final String status;
  final int issueDate;
  final int? dueDate;
  final String? notes;
  final int subtotalPiastres;
  final int discountPiastres;
  final int taxPiastres;
  final int grandTotalPiastres;
  final int paidAmountPiastres;
  final int createdAt;
  final int updatedAt;
  const InvoiceEntry({
    required this.id,
    required this.referenceNumber,
    this.quotationId,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.issueDate,
    this.dueDate,
    this.notes,
    required this.subtotalPiastres,
    required this.discountPiastres,
    required this.taxPiastres,
    required this.grandTotalPiastres,
    required this.paidAmountPiastres,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference_number'] = Variable<String>(referenceNumber);
    if (!nullToAbsent || quotationId != null) {
      map['quotation_id'] = Variable<int>(quotationId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['status'] = Variable<String>(status);
    map['issue_date'] = Variable<int>(issueDate);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['subtotal_piastres'] = Variable<int>(subtotalPiastres);
    map['discount_piastres'] = Variable<int>(discountPiastres);
    map['tax_piastres'] = Variable<int>(taxPiastres);
    map['grand_total_piastres'] = Variable<int>(grandTotalPiastres);
    map['paid_amount_piastres'] = Variable<int>(paidAmountPiastres);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  InvoiceCompanion toCompanion(bool nullToAbsent) {
    return InvoiceCompanion(
      id: Value(id),
      referenceNumber: Value(referenceNumber),
      quotationId: quotationId == null && nullToAbsent
          ? const Value.absent()
          : Value(quotationId),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      status: Value(status),
      issueDate: Value(issueDate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      subtotalPiastres: Value(subtotalPiastres),
      discountPiastres: Value(discountPiastres),
      taxPiastres: Value(taxPiastres),
      grandTotalPiastres: Value(grandTotalPiastres),
      paidAmountPiastres: Value(paidAmountPiastres),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvoiceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceEntry(
      id: serializer.fromJson<int>(json['id']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      quotationId: serializer.fromJson<int?>(json['quotationId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      status: serializer.fromJson<String>(json['status']),
      issueDate: serializer.fromJson<int>(json['issueDate']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      subtotalPiastres: serializer.fromJson<int>(json['subtotalPiastres']),
      discountPiastres: serializer.fromJson<int>(json['discountPiastres']),
      taxPiastres: serializer.fromJson<int>(json['taxPiastres']),
      grandTotalPiastres: serializer.fromJson<int>(json['grandTotalPiastres']),
      paidAmountPiastres: serializer.fromJson<int>(json['paidAmountPiastres']),
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
      'quotationId': serializer.toJson<int?>(quotationId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'status': serializer.toJson<String>(status),
      'issueDate': serializer.toJson<int>(issueDate),
      'dueDate': serializer.toJson<int?>(dueDate),
      'notes': serializer.toJson<String?>(notes),
      'subtotalPiastres': serializer.toJson<int>(subtotalPiastres),
      'discountPiastres': serializer.toJson<int>(discountPiastres),
      'taxPiastres': serializer.toJson<int>(taxPiastres),
      'grandTotalPiastres': serializer.toJson<int>(grandTotalPiastres),
      'paidAmountPiastres': serializer.toJson<int>(paidAmountPiastres),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  InvoiceEntry copyWith({
    int? id,
    String? referenceNumber,
    Value<int?> quotationId = const Value.absent(),
    String? customerName,
    Value<String?> customerPhone = const Value.absent(),
    String? status,
    int? issueDate,
    Value<int?> dueDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? subtotalPiastres,
    int? discountPiastres,
    int? taxPiastres,
    int? grandTotalPiastres,
    int? paidAmountPiastres,
    int? createdAt,
    int? updatedAt,
  }) => InvoiceEntry(
    id: id ?? this.id,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    quotationId: quotationId.present ? quotationId.value : this.quotationId,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    status: status ?? this.status,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    notes: notes.present ? notes.value : this.notes,
    subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
    discountPiastres: discountPiastres ?? this.discountPiastres,
    taxPiastres: taxPiastres ?? this.taxPiastres,
    grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
    paidAmountPiastres: paidAmountPiastres ?? this.paidAmountPiastres,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InvoiceEntry copyWithCompanion(InvoiceCompanion data) {
    return InvoiceEntry(
      id: data.id.present ? data.id.value : this.id,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      quotationId: data.quotationId.present
          ? data.quotationId.value
          : this.quotationId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      status: data.status.present ? data.status.value : this.status,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
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
      paidAmountPiastres: data.paidAmountPiastres.present
          ? data.paidAmountPiastres.value
          : this.paidAmountPiastres,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceEntry(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('quotationId: $quotationId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('subtotalPiastres: $subtotalPiastres, ')
          ..write('discountPiastres: $discountPiastres, ')
          ..write('taxPiastres: $taxPiastres, ')
          ..write('grandTotalPiastres: $grandTotalPiastres, ')
          ..write('paidAmountPiastres: $paidAmountPiastres, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    referenceNumber,
    quotationId,
    customerName,
    customerPhone,
    status,
    issueDate,
    dueDate,
    notes,
    subtotalPiastres,
    discountPiastres,
    taxPiastres,
    grandTotalPiastres,
    paidAmountPiastres,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceEntry &&
          other.id == this.id &&
          other.referenceNumber == this.referenceNumber &&
          other.quotationId == this.quotationId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.status == this.status &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.notes == this.notes &&
          other.subtotalPiastres == this.subtotalPiastres &&
          other.discountPiastres == this.discountPiastres &&
          other.taxPiastres == this.taxPiastres &&
          other.grandTotalPiastres == this.grandTotalPiastres &&
          other.paidAmountPiastres == this.paidAmountPiastres &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoiceCompanion extends UpdateCompanion<InvoiceEntry> {
  final Value<int> id;
  final Value<String> referenceNumber;
  final Value<int?> quotationId;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<String> status;
  final Value<int> issueDate;
  final Value<int?> dueDate;
  final Value<String?> notes;
  final Value<int> subtotalPiastres;
  final Value<int> discountPiastres;
  final Value<int> taxPiastres;
  final Value<int> grandTotalPiastres;
  final Value<int> paidAmountPiastres;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const InvoiceCompanion({
    this.id = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.quotationId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotalPiastres = const Value.absent(),
    this.discountPiastres = const Value.absent(),
    this.taxPiastres = const Value.absent(),
    this.grandTotalPiastres = const Value.absent(),
    this.paidAmountPiastres = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoiceCompanion.insert({
    this.id = const Value.absent(),
    required String referenceNumber,
    this.quotationId = const Value.absent(),
    required String customerName,
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    required int issueDate,
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotalPiastres = const Value.absent(),
    this.discountPiastres = const Value.absent(),
    this.taxPiastres = const Value.absent(),
    this.grandTotalPiastres = const Value.absent(),
    this.paidAmountPiastres = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : referenceNumber = Value(referenceNumber),
       customerName = Value(customerName),
       issueDate = Value(issueDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InvoiceEntry> custom({
    Expression<int>? id,
    Expression<String>? referenceNumber,
    Expression<int>? quotationId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? status,
    Expression<int>? issueDate,
    Expression<int>? dueDate,
    Expression<String>? notes,
    Expression<int>? subtotalPiastres,
    Expression<int>? discountPiastres,
    Expression<int>? taxPiastres,
    Expression<int>? grandTotalPiastres,
    Expression<int>? paidAmountPiastres,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (quotationId != null) 'quotation_id': quotationId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (status != null) 'status': status,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (notes != null) 'notes': notes,
      if (subtotalPiastres != null) 'subtotal_piastres': subtotalPiastres,
      if (discountPiastres != null) 'discount_piastres': discountPiastres,
      if (taxPiastres != null) 'tax_piastres': taxPiastres,
      if (grandTotalPiastres != null)
        'grand_total_piastres': grandTotalPiastres,
      if (paidAmountPiastres != null)
        'paid_amount_piastres': paidAmountPiastres,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoiceCompanion copyWith({
    Value<int>? id,
    Value<String>? referenceNumber,
    Value<int?>? quotationId,
    Value<String>? customerName,
    Value<String?>? customerPhone,
    Value<String>? status,
    Value<int>? issueDate,
    Value<int?>? dueDate,
    Value<String?>? notes,
    Value<int>? subtotalPiastres,
    Value<int>? discountPiastres,
    Value<int>? taxPiastres,
    Value<int>? grandTotalPiastres,
    Value<int>? paidAmountPiastres,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return InvoiceCompanion(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      quotationId: quotationId ?? this.quotationId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      paidAmountPiastres: paidAmountPiastres ?? this.paidAmountPiastres,
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
    if (quotationId.present) {
      map['quotation_id'] = Variable<int>(quotationId.value);
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
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
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
    if (paidAmountPiastres.present) {
      map['paid_amount_piastres'] = Variable<int>(paidAmountPiastres.value);
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
    return (StringBuffer('InvoiceCompanion(')
          ..write('id: $id, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('quotationId: $quotationId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('subtotalPiastres: $subtotalPiastres, ')
          ..write('discountPiastres: $discountPiastres, ')
          ..write('taxPiastres: $taxPiastres, ')
          ..write('grandTotalPiastres: $grandTotalPiastres, ')
          ..write('paidAmountPiastres: $paidAmountPiastres, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTableTable extends InvoiceItemsTable
    with TableInfo<$InvoiceItemsTableTable, InvoiceItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
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
    defaultValue: const Constant(0),
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
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
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
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
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
  InvoiceItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
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
  $InvoiceItemsTableTable createAlias(String alias) {
    return $InvoiceItemsTableTable(attachedDatabase, alias);
  }
}

class InvoiceItemEntry extends DataClass
    implements Insertable<InvoiceItemEntry> {
  final int id;
  final int invoiceId;
  final int? productId;
  final String productCode;
  final String productName;
  final String unit;
  final int unitPricePiastres;
  final int quantity;
  final int lineDiscountPiastres;
  final int lineTotalPiastres;
  const InvoiceItemEntry({
    required this.id,
    required this.invoiceId,
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
    map['invoice_id'] = Variable<int>(invoiceId);
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

  InvoiceItemCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
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

  factory InvoiceItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItemEntry(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
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
      'invoiceId': serializer.toJson<int>(invoiceId),
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

  InvoiceItemEntry copyWith({
    int? id,
    int? invoiceId,
    Value<int?> productId = const Value.absent(),
    String? productCode,
    String? productName,
    String? unit,
    int? unitPricePiastres,
    int? quantity,
    int? lineDiscountPiastres,
    int? lineTotalPiastres,
  }) => InvoiceItemEntry(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    productId: productId.present ? productId.value : this.productId,
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    unit: unit ?? this.unit,
    unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
    quantity: quantity ?? this.quantity,
    lineDiscountPiastres: lineDiscountPiastres ?? this.lineDiscountPiastres,
    lineTotalPiastres: lineTotalPiastres ?? this.lineTotalPiastres,
  );
  InvoiceItemEntry copyWithCompanion(InvoiceItemCompanion data) {
    return InvoiceItemEntry(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
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
    return (StringBuffer('InvoiceItemEntry(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
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
    invoiceId,
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
      (other is InvoiceItemEntry &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.productId == this.productId &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.unit == this.unit &&
          other.unitPricePiastres == this.unitPricePiastres &&
          other.quantity == this.quantity &&
          other.lineDiscountPiastres == this.lineDiscountPiastres &&
          other.lineTotalPiastres == this.lineTotalPiastres);
}

class InvoiceItemCompanion extends UpdateCompanion<InvoiceItemEntry> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int?> productId;
  final Value<String> productCode;
  final Value<String> productName;
  final Value<String> unit;
  final Value<int> unitPricePiastres;
  final Value<int> quantity;
  final Value<int> lineDiscountPiastres;
  final Value<int> lineTotalPiastres;
  const InvoiceItemCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPricePiastres = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lineDiscountPiastres = const Value.absent(),
    this.lineTotalPiastres = const Value.absent(),
  });
  InvoiceItemCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    this.productId = const Value.absent(),
    required String productCode,
    required String productName,
    required String unit,
    required int unitPricePiastres,
    required int quantity,
    this.lineDiscountPiastres = const Value.absent(),
    required int lineTotalPiastres,
  }) : invoiceId = Value(invoiceId),
       productCode = Value(productCode),
       productName = Value(productName),
       unit = Value(unit),
       unitPricePiastres = Value(unitPricePiastres),
       quantity = Value(quantity),
       lineTotalPiastres = Value(lineTotalPiastres);
  static Insertable<InvoiceItemEntry> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
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
      if (invoiceId != null) 'invoice_id': invoiceId,
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

  InvoiceItemCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<int?>? productId,
    Value<String>? productCode,
    Value<String>? productName,
    Value<String>? unit,
    Value<int>? unitPricePiastres,
    Value<int>? quantity,
    Value<int>? lineDiscountPiastres,
    Value<int>? lineTotalPiastres,
  }) {
    return InvoiceItemCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
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
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
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
    return (StringBuffer('InvoiceItemCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
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

class $InvoicePaymentsTableTable extends InvoicePaymentsTable
    with TableInfo<$InvoicePaymentsTableTable, InvoicePaymentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicePaymentsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountPiastresMeta = const VerificationMeta(
    'amountPiastres',
  );
  @override
  late final GeneratedColumn<int> amountPiastres = GeneratedColumn<int>(
    'amount_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<int> paymentDate = GeneratedColumn<int>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    amountPiastres,
    paymentMethod,
    paymentDate,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoicePaymentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('amount_piastres')) {
      context.handle(
        _amountPiastresMeta,
        amountPiastres.isAcceptableOrUnknown(
          data['amount_piastres']!,
          _amountPiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPiastresMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoicePaymentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoicePaymentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      amountPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_piastres'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoicePaymentsTableTable createAlias(String alias) {
    return $InvoicePaymentsTableTable(attachedDatabase, alias);
  }
}

class InvoicePaymentEntry extends DataClass
    implements Insertable<InvoicePaymentEntry> {
  final int id;
  final int invoiceId;
  final int amountPiastres;
  final String paymentMethod;
  final int paymentDate;
  final String? notes;
  final int createdAt;
  const InvoicePaymentEntry({
    required this.id,
    required this.invoiceId,
    required this.amountPiastres,
    required this.paymentMethod,
    required this.paymentDate,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['amount_piastres'] = Variable<int>(amountPiastres);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payment_date'] = Variable<int>(paymentDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  InvoicePaymentCompanion toCompanion(bool nullToAbsent) {
    return InvoicePaymentCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      amountPiastres: Value(amountPiastres),
      paymentMethod: Value(paymentMethod),
      paymentDate: Value(paymentDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory InvoicePaymentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoicePaymentEntry(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      amountPiastres: serializer.fromJson<int>(json['amountPiastres']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentDate: serializer.fromJson<int>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'amountPiastres': serializer.toJson<int>(amountPiastres),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentDate': serializer.toJson<int>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  InvoicePaymentEntry copyWith({
    int? id,
    int? invoiceId,
    int? amountPiastres,
    String? paymentMethod,
    int? paymentDate,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
  }) => InvoicePaymentEntry(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    amountPiastres: amountPiastres ?? this.amountPiastres,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentDate: paymentDate ?? this.paymentDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  InvoicePaymentEntry copyWithCompanion(InvoicePaymentCompanion data) {
    return InvoicePaymentEntry(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      amountPiastres: data.amountPiastres.present
          ? data.amountPiastres.value
          : this.amountPiastres,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoicePaymentEntry(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amountPiastres: $amountPiastres, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    amountPiastres,
    paymentMethod,
    paymentDate,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoicePaymentEntry &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.amountPiastres == this.amountPiastres &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class InvoicePaymentCompanion extends UpdateCompanion<InvoicePaymentEntry> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> amountPiastres;
  final Value<String> paymentMethod;
  final Value<int> paymentDate;
  final Value<String?> notes;
  final Value<int> createdAt;
  const InvoicePaymentCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.amountPiastres = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoicePaymentCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int amountPiastres,
    this.paymentMethod = const Value.absent(),
    required int paymentDate,
    this.notes = const Value.absent(),
    required int createdAt,
  }) : invoiceId = Value(invoiceId),
       amountPiastres = Value(amountPiastres),
       paymentDate = Value(paymentDate),
       createdAt = Value(createdAt);
  static Insertable<InvoicePaymentEntry> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? amountPiastres,
    Expression<String>? paymentMethod,
    Expression<int>? paymentDate,
    Expression<String>? notes,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (amountPiastres != null) 'amount_piastres': amountPiastres,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoicePaymentCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<int>? amountPiastres,
    Value<String>? paymentMethod,
    Value<int>? paymentDate,
    Value<String?>? notes,
    Value<int>? createdAt,
  }) {
    return InvoicePaymentCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      amountPiastres: amountPiastres ?? this.amountPiastres,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (amountPiastres.present) {
      map['amount_piastres'] = Variable<int>(amountPiastres.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<int>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicePaymentCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amountPiastres: $amountPiastres, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfilesTableTable extends BusinessProfilesTable
    with TableInfo<$BusinessProfilesTableTable, BusinessProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfilesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phonePrimaryMeta = const VerificationMeta(
    'phonePrimary',
  );
  @override
  late final GeneratedColumn<String> phonePrimary = GeneratedColumn<String>(
    'phone_primary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneSecondaryMeta = const VerificationMeta(
    'phoneSecondary',
  );
  @override
  late final GeneratedColumn<String> phoneSecondary = GeneratedColumn<String>(
    'phone_secondary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxNumberMeta = const VerificationMeta(
    'taxNumber',
  );
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
    'tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commercialRegisterMeta =
      const VerificationMeta('commercialRegister');
  @override
  late final GeneratedColumn<String> commercialRegister =
      GeneratedColumn<String>(
        'commercial_register',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultQuotationNotesMeta =
      const VerificationMeta('defaultQuotationNotes');
  @override
  late final GeneratedColumn<String> defaultQuotationNotes =
      GeneratedColumn<String>(
        'default_quotation_notes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultInvoiceTermsMeta =
      const VerificationMeta('defaultInvoiceTerms');
  @override
  late final GeneratedColumn<String> defaultInvoiceTerms =
      GeneratedColumn<String>(
        'default_invoice_terms',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    businessName,
    ownerName,
    phonePrimary,
    phoneSecondary,
    address,
    city,
    taxNumber,
    commercialRegister,
    logoPath,
    defaultQuotationNotes,
    defaultInvoiceTerms,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    }
    if (data.containsKey('phone_primary')) {
      context.handle(
        _phonePrimaryMeta,
        phonePrimary.isAcceptableOrUnknown(
          data['phone_primary']!,
          _phonePrimaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phonePrimaryMeta);
    }
    if (data.containsKey('phone_secondary')) {
      context.handle(
        _phoneSecondaryMeta,
        phoneSecondary.isAcceptableOrUnknown(
          data['phone_secondary']!,
          _phoneSecondaryMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('tax_number')) {
      context.handle(
        _taxNumberMeta,
        taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta),
      );
    }
    if (data.containsKey('commercial_register')) {
      context.handle(
        _commercialRegisterMeta,
        commercialRegister.isAcceptableOrUnknown(
          data['commercial_register']!,
          _commercialRegisterMeta,
        ),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('default_quotation_notes')) {
      context.handle(
        _defaultQuotationNotesMeta,
        defaultQuotationNotes.isAcceptableOrUnknown(
          data['default_quotation_notes']!,
          _defaultQuotationNotesMeta,
        ),
      );
    }
    if (data.containsKey('default_invoice_terms')) {
      context.handle(
        _defaultInvoiceTermsMeta,
        defaultInvoiceTerms.isAcceptableOrUnknown(
          data['default_invoice_terms']!,
          _defaultInvoiceTermsMeta,
        ),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      ),
      phonePrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_primary'],
      )!,
      phoneSecondary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_secondary'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      taxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_number'],
      ),
      commercialRegister: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}commercial_register'],
      ),
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      defaultQuotationNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_quotation_notes'],
      ),
      defaultInvoiceTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_invoice_terms'],
      ),
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $BusinessProfilesTableTable createAlias(String alias) {
    return $BusinessProfilesTableTable(attachedDatabase, alias);
  }
}

class BusinessProfileData extends DataClass
    implements Insertable<BusinessProfileData> {
  /// Primary key singleton constraint: id is always 1.
  final int id;

  /// Business / store trade name (e.g. مؤسسة الأمل للأدوات الصحية).
  final String businessName;

  /// Responsible merchant / owner name.
  final String? ownerName;

  /// Primary contact phone number.
  final String phonePrimary;

  /// Secondary phone number or WhatsApp.
  final String? phoneSecondary;

  /// Store physical address / street.
  final String? address;

  /// City / governorate (e.g. المنصورة، الدقهلية).
  final String? city;

  /// Tax card number (البطاقة الضريبية).
  final String? taxNumber;

  /// Commercial register number (السجل التجاري).
  final String? commercialRegister;

  /// Local sandboxed relative file path for store logo.
  final String? logoPath;

  /// Default quotation terms and validity note printed on PDF.
  final String? defaultQuotationNotes;

  /// Default invoice terms, warranty, and return policy printed on PDF.
  final String? defaultInvoiceTerms;

  /// Last updated UTC instant formatted as ISO-8601 string.
  final String updatedAtUtc;
  const BusinessProfileData({
    required this.id,
    required this.businessName,
    this.ownerName,
    required this.phonePrimary,
    this.phoneSecondary,
    this.address,
    this.city,
    this.taxNumber,
    this.commercialRegister,
    this.logoPath,
    this.defaultQuotationNotes,
    this.defaultInvoiceTerms,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || ownerName != null) {
      map['owner_name'] = Variable<String>(ownerName);
    }
    map['phone_primary'] = Variable<String>(phonePrimary);
    if (!nullToAbsent || phoneSecondary != null) {
      map['phone_secondary'] = Variable<String>(phoneSecondary);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || commercialRegister != null) {
      map['commercial_register'] = Variable<String>(commercialRegister);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || defaultQuotationNotes != null) {
      map['default_quotation_notes'] = Variable<String>(defaultQuotationNotes);
    }
    if (!nullToAbsent || defaultInvoiceTerms != null) {
      map['default_invoice_terms'] = Variable<String>(defaultInvoiceTerms);
    }
    map['updated_at_utc'] = Variable<String>(updatedAtUtc);
    return map;
  }

  BusinessProfileCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfileCompanion(
      id: Value(id),
      businessName: Value(businessName),
      ownerName: ownerName == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerName),
      phonePrimary: Value(phonePrimary),
      phoneSecondary: phoneSecondary == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneSecondary),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      commercialRegister: commercialRegister == null && nullToAbsent
          ? const Value.absent()
          : Value(commercialRegister),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      defaultQuotationNotes: defaultQuotationNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultQuotationNotes),
      defaultInvoiceTerms: defaultInvoiceTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultInvoiceTerms),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory BusinessProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileData(
      id: serializer.fromJson<int>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      ownerName: serializer.fromJson<String?>(json['ownerName']),
      phonePrimary: serializer.fromJson<String>(json['phonePrimary']),
      phoneSecondary: serializer.fromJson<String?>(json['phoneSecondary']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      commercialRegister: serializer.fromJson<String?>(
        json['commercialRegister'],
      ),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      defaultQuotationNotes: serializer.fromJson<String?>(
        json['defaultQuotationNotes'],
      ),
      defaultInvoiceTerms: serializer.fromJson<String?>(
        json['defaultInvoiceTerms'],
      ),
      updatedAtUtc: serializer.fromJson<String>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessName': serializer.toJson<String>(businessName),
      'ownerName': serializer.toJson<String?>(ownerName),
      'phonePrimary': serializer.toJson<String>(phonePrimary),
      'phoneSecondary': serializer.toJson<String?>(phoneSecondary),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'commercialRegister': serializer.toJson<String?>(commercialRegister),
      'logoPath': serializer.toJson<String?>(logoPath),
      'defaultQuotationNotes': serializer.toJson<String?>(
        defaultQuotationNotes,
      ),
      'defaultInvoiceTerms': serializer.toJson<String?>(defaultInvoiceTerms),
      'updatedAtUtc': serializer.toJson<String>(updatedAtUtc),
    };
  }

  BusinessProfileData copyWith({
    int? id,
    String? businessName,
    Value<String?> ownerName = const Value.absent(),
    String? phonePrimary,
    Value<String?> phoneSecondary = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> taxNumber = const Value.absent(),
    Value<String?> commercialRegister = const Value.absent(),
    Value<String?> logoPath = const Value.absent(),
    Value<String?> defaultQuotationNotes = const Value.absent(),
    Value<String?> defaultInvoiceTerms = const Value.absent(),
    String? updatedAtUtc,
  }) => BusinessProfileData(
    id: id ?? this.id,
    businessName: businessName ?? this.businessName,
    ownerName: ownerName.present ? ownerName.value : this.ownerName,
    phonePrimary: phonePrimary ?? this.phonePrimary,
    phoneSecondary: phoneSecondary.present
        ? phoneSecondary.value
        : this.phoneSecondary,
    address: address.present ? address.value : this.address,
    city: city.present ? city.value : this.city,
    taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
    commercialRegister: commercialRegister.present
        ? commercialRegister.value
        : this.commercialRegister,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    defaultQuotationNotes: defaultQuotationNotes.present
        ? defaultQuotationNotes.value
        : this.defaultQuotationNotes,
    defaultInvoiceTerms: defaultInvoiceTerms.present
        ? defaultInvoiceTerms.value
        : this.defaultInvoiceTerms,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  BusinessProfileData copyWithCompanion(BusinessProfileCompanion data) {
    return BusinessProfileData(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      phonePrimary: data.phonePrimary.present
          ? data.phonePrimary.value
          : this.phonePrimary,
      phoneSecondary: data.phoneSecondary.present
          ? data.phoneSecondary.value
          : this.phoneSecondary,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      commercialRegister: data.commercialRegister.present
          ? data.commercialRegister.value
          : this.commercialRegister,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      defaultQuotationNotes: data.defaultQuotationNotes.present
          ? data.defaultQuotationNotes.value
          : this.defaultQuotationNotes,
      defaultInvoiceTerms: data.defaultInvoiceTerms.present
          ? data.defaultInvoiceTerms.value
          : this.defaultInvoiceTerms,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileData(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('phonePrimary: $phonePrimary, ')
          ..write('phoneSecondary: $phoneSecondary, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('commercialRegister: $commercialRegister, ')
          ..write('logoPath: $logoPath, ')
          ..write('defaultQuotationNotes: $defaultQuotationNotes, ')
          ..write('defaultInvoiceTerms: $defaultInvoiceTerms, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    ownerName,
    phonePrimary,
    phoneSecondary,
    address,
    city,
    taxNumber,
    commercialRegister,
    logoPath,
    defaultQuotationNotes,
    defaultInvoiceTerms,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileData &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.ownerName == this.ownerName &&
          other.phonePrimary == this.phonePrimary &&
          other.phoneSecondary == this.phoneSecondary &&
          other.address == this.address &&
          other.city == this.city &&
          other.taxNumber == this.taxNumber &&
          other.commercialRegister == this.commercialRegister &&
          other.logoPath == this.logoPath &&
          other.defaultQuotationNotes == this.defaultQuotationNotes &&
          other.defaultInvoiceTerms == this.defaultInvoiceTerms &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class BusinessProfileCompanion extends UpdateCompanion<BusinessProfileData> {
  final Value<int> id;
  final Value<String> businessName;
  final Value<String?> ownerName;
  final Value<String> phonePrimary;
  final Value<String?> phoneSecondary;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> taxNumber;
  final Value<String?> commercialRegister;
  final Value<String?> logoPath;
  final Value<String?> defaultQuotationNotes;
  final Value<String?> defaultInvoiceTerms;
  final Value<String> updatedAtUtc;
  const BusinessProfileCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.phonePrimary = const Value.absent(),
    this.phoneSecondary = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.commercialRegister = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.defaultQuotationNotes = const Value.absent(),
    this.defaultInvoiceTerms = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
  });
  BusinessProfileCompanion.insert({
    this.id = const Value.absent(),
    required String businessName,
    this.ownerName = const Value.absent(),
    required String phonePrimary,
    this.phoneSecondary = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.commercialRegister = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.defaultQuotationNotes = const Value.absent(),
    this.defaultInvoiceTerms = const Value.absent(),
    required String updatedAtUtc,
  }) : businessName = Value(businessName),
       phonePrimary = Value(phonePrimary),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<BusinessProfileData> custom({
    Expression<int>? id,
    Expression<String>? businessName,
    Expression<String>? ownerName,
    Expression<String>? phonePrimary,
    Expression<String>? phoneSecondary,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? taxNumber,
    Expression<String>? commercialRegister,
    Expression<String>? logoPath,
    Expression<String>? defaultQuotationNotes,
    Expression<String>? defaultInvoiceTerms,
    Expression<String>? updatedAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (ownerName != null) 'owner_name': ownerName,
      if (phonePrimary != null) 'phone_primary': phonePrimary,
      if (phoneSecondary != null) 'phone_secondary': phoneSecondary,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (commercialRegister != null) 'commercial_register': commercialRegister,
      if (logoPath != null) 'logo_path': logoPath,
      if (defaultQuotationNotes != null)
        'default_quotation_notes': defaultQuotationNotes,
      if (defaultInvoiceTerms != null)
        'default_invoice_terms': defaultInvoiceTerms,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
    });
  }

  BusinessProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? businessName,
    Value<String?>? ownerName,
    Value<String>? phonePrimary,
    Value<String?>? phoneSecondary,
    Value<String?>? address,
    Value<String?>? city,
    Value<String?>? taxNumber,
    Value<String?>? commercialRegister,
    Value<String?>? logoPath,
    Value<String?>? defaultQuotationNotes,
    Value<String?>? defaultInvoiceTerms,
    Value<String>? updatedAtUtc,
  }) {
    return BusinessProfileCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      phoneSecondary: phoneSecondary ?? this.phoneSecondary,
      address: address ?? this.address,
      city: city ?? this.city,
      taxNumber: taxNumber ?? this.taxNumber,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      logoPath: logoPath ?? this.logoPath,
      defaultQuotationNotes:
          defaultQuotationNotes ?? this.defaultQuotationNotes,
      defaultInvoiceTerms: defaultInvoiceTerms ?? this.defaultInvoiceTerms,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (phonePrimary.present) {
      map['phone_primary'] = Variable<String>(phonePrimary.value);
    }
    if (phoneSecondary.present) {
      map['phone_secondary'] = Variable<String>(phoneSecondary.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (commercialRegister.present) {
      map['commercial_register'] = Variable<String>(commercialRegister.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (defaultQuotationNotes.present) {
      map['default_quotation_notes'] = Variable<String>(
        defaultQuotationNotes.value,
      );
    }
    if (defaultInvoiceTerms.present) {
      map['default_invoice_terms'] = Variable<String>(
        defaultInvoiceTerms.value,
      );
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<String>(updatedAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('phonePrimary: $phonePrimary, ')
          ..write('phoneSecondary: $phoneSecondary, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('commercialRegister: $commercialRegister, ')
          ..write('logoPath: $logoPath, ')
          ..write('defaultQuotationNotes: $defaultQuotationNotes, ')
          ..write('defaultInvoiceTerms: $defaultInvoiceTerms, ')
          ..write('updatedAtUtc: $updatedAtUtc')
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
  late final $InvoicesTableTable invoicesTable = $InvoicesTableTable(this);
  late final $InvoiceItemsTableTable invoiceItemsTable =
      $InvoiceItemsTableTable(this);
  late final $InvoicePaymentsTableTable invoicePaymentsTable =
      $InvoicePaymentsTableTable(this);
  late final $BusinessProfilesTableTable businessProfilesTable =
      $BusinessProfilesTableTable(this);
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
  late final Index idxInvoicesRef = Index(
    'idx_invoices_ref',
    'CREATE UNIQUE INDEX idx_invoices_ref ON invoices (reference_number)',
  );
  late final Index idxInvoicesCustomer = Index(
    'idx_invoices_customer',
    'CREATE INDEX idx_invoices_customer ON invoices (customer_name)',
  );
  late final Index idxInvoicesStatus = Index(
    'idx_invoices_status',
    'CREATE INDEX idx_invoices_status ON invoices (status)',
  );
  late final Index idxInvoiceItemsInvoice = Index(
    'idx_invoice_items_invoice',
    'CREATE INDEX idx_invoice_items_invoice ON invoice_items (invoice_id)',
  );
  late final Index idxInvoicePaymentsInvoice = Index(
    'idx_invoice_payments_invoice',
    'CREATE INDEX idx_invoice_payments_invoice ON invoice_payments (invoice_id)',
  );
  late final Index idxBusinessProfilesId = Index(
    'idx_business_profiles_id',
    'CREATE INDEX idx_business_profiles_id ON business_profiles (id)',
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
    invoicesTable,
    invoiceItemsTable,
    invoicePaymentsTable,
    businessProfilesTable,
    idxAppSettingsId,
    idxProductsCode,
    idxProductsCategory,
    idxProductsSearch,
    idxQuotationsRef,
    idxQuotationsCustomer,
    idxQuotationsStatus,
    idxQuotationItemsQuotationId,
    idxInvoicesRef,
    idxInvoicesCustomer,
    idxInvoicesStatus,
    idxInvoiceItemsInvoice,
    idxInvoicePaymentsInvoice,
    idxBusinessProfilesId,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoices', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_payments', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$InvoiceItemsTableTable, List<InvoiceItemEntry>>
  _invoiceItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.invoiceItemsTable,
        aliasName: 'products__id__invoice_items__product_id',
      );

  $$InvoiceItemsTableTableProcessedTableManager get invoiceItemsTableRefs {
    final manager = $$InvoiceItemsTableTableTableManager(
      $_db,
      $_db.invoiceItemsTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoiceItemsTableRefsTable($_db),
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

  Expression<bool> invoiceItemsTableRefs(
    Expression<bool> Function($$InvoiceItemsTableTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItemsTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItemsTable,
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

  Expression<T> invoiceItemsTableRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.invoiceItemsTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InvoiceItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.invoiceItemsTable,
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
          PrefetchHooks Function({
            bool quotationItemsTableRefs,
            bool invoiceItemsTableRefs,
          })
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
          prefetchHooksCallback:
              ({
                quotationItemsTableRefs = false,
                invoiceItemsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quotationItemsTableRefs) db.quotationItemsTable,
                    if (invoiceItemsTableRefs) db.invoiceItemsTable,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoiceItemsTableRefs)
                        await $_getPrefetchedData<
                          ProductEntry,
                          $ProductsTableTable,
                          InvoiceItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableTableReferences
                              ._invoiceItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
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
      PrefetchHooks Function({
        bool quotationItemsTableRefs,
        bool invoiceItemsTableRefs,
      })
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

  static MultiTypedResultKey<$InvoicesTableTable, List<InvoiceEntry>>
  _invoicesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoicesTable,
    aliasName: 'quotations__id__invoices__quotation_id',
  );

  $$InvoicesTableTableProcessedTableManager get invoicesTableRefs {
    final manager = $$InvoicesTableTableTableManager(
      $_db,
      $_db.invoicesTable,
    ).filter((f) => f.quotationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesTableRefsTable($_db));
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

  Expression<bool> invoicesTableRefs(
    Expression<bool> Function($$InvoicesTableTableFilterComposer f) f,
  ) {
    final $$InvoicesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.quotationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableFilterComposer(
            $db: $db,
            $table: $db.invoicesTable,
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

  Expression<T> invoicesTableRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.quotationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.invoicesTable,
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
          PrefetchHooks Function({
            bool quotationItemsTableRefs,
            bool invoicesTableRefs,
          })
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
          prefetchHooksCallback:
              ({quotationItemsTableRefs = false, invoicesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quotationItemsTableRefs) db.quotationItemsTable,
                    if (invoicesTableRefs) db.invoicesTable,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quotationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesTableRefs)
                        await $_getPrefetchedData<
                          QuotationEntry,
                          $QuotationsTableTable,
                          InvoiceEntry
                        >(
                          currentTable: table,
                          referencedTable: $$QuotationsTableTableReferences
                              ._invoicesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotationsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({
        bool quotationItemsTableRefs,
        bool invoicesTableRefs,
      })
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
typedef $$InvoicesTableTableCreateCompanionBuilder = InvoiceCompanion Function({
  Value<int> id,
  required String referenceNumber,
  Value<int?> quotationId,
  required String customerName,
  Value<String?> customerPhone,
  Value<String> status,
  required int issueDate,
  Value<int?> dueDate,
  Value<String?> notes,
  Value<int> subtotalPiastres,
  Value<int> discountPiastres,
  Value<int> taxPiastres,
  Value<int> grandTotalPiastres,
  Value<int> paidAmountPiastres,
  required int createdAt,
  required int updatedAt,
});
typedef $$InvoicesTableTableUpdateCompanionBuilder = InvoiceCompanion Function({
  Value<int> id,
  Value<String> referenceNumber,
  Value<int?> quotationId,
  Value<String> customerName,
  Value<String?> customerPhone,
  Value<String> status,
  Value<int> issueDate,
  Value<int?> dueDate,
  Value<String?> notes,
  Value<int> subtotalPiastres,
  Value<int> discountPiastres,
  Value<int> taxPiastres,
  Value<int> grandTotalPiastres,
  Value<int> paidAmountPiastres,
  Value<int> createdAt,
  Value<int> updatedAt,
});

final class $$InvoicesTableTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTableTable, InvoiceEntry> {
  $$InvoicesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotationsTableTable _quotationIdTable(_$AppDatabase db) =>
      db.quotationsTable.createAlias('invoices__quotation_id__quotations__id');

  $$QuotationsTableTableProcessedTableManager? get quotationId {
    final $_column = $_itemColumn<int>('quotation_id');
    if ($_column == null) return null;
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

  static MultiTypedResultKey<$InvoiceItemsTableTable, List<InvoiceItemEntry>>
  _invoiceItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.invoiceItemsTable,
        aliasName: 'invoices__id__invoice_items__invoice_id',
      );

  $$InvoiceItemsTableTableProcessedTableManager get invoiceItemsTableRefs {
    final manager = $$InvoiceItemsTableTableTableManager(
      $_db,
      $_db.invoiceItemsTable,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoiceItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InvoicePaymentsTableTable,
    List<InvoicePaymentEntry>
  >
  _invoicePaymentsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.invoicePaymentsTable,
        aliasName: 'invoices__id__invoice_payments__invoice_id',
      );

  $$InvoicePaymentsTableTableProcessedTableManager
  get invoicePaymentsTableRefs {
    final manager = $$InvoicePaymentsTableTableTableManager(
      $_db,
      $_db.invoicePaymentsTable,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoicePaymentsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTableTable> {
  $$InvoicesTableTableFilterComposer({
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

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
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

  ColumnFilters<int> get paidAmountPiastres => $composableBuilder(
    column: $table.paidAmountPiastres,
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

  Expression<bool> invoiceItemsTableRefs(
    Expression<bool> Function($$InvoiceItemsTableTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItemsTable,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicePaymentsTableRefs(
    Expression<bool> Function($$InvoicePaymentsTableTableFilterComposer f) f,
  ) {
    final $$InvoicePaymentsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoicePaymentsTable,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicePaymentsTableTableFilterComposer(
            $db: $db,
            $table: $db.invoicePaymentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTableTable> {
  $$InvoicesTableTableOrderingComposer({
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

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
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

  ColumnOrderings<int> get paidAmountPiastres => $composableBuilder(
    column: $table.paidAmountPiastres,
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
}

class $$InvoicesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTableTable> {
  $$InvoicesTableTableAnnotationComposer({
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

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

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

  GeneratedColumn<int> get paidAmountPiastres => $composableBuilder(
    column: $table.paidAmountPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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

  Expression<T> invoiceItemsTableRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.invoiceItemsTable,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InvoiceItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.invoiceItemsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> invoicePaymentsTableRefs<T extends Object>(
    Expression<T> Function($$InvoicePaymentsTableTableAnnotationComposer a) f,
  ) {
    final $$InvoicePaymentsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.invoicePaymentsTable,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InvoicePaymentsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.invoicePaymentsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InvoicesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTableTable,
          InvoiceEntry,
          $$InvoicesTableTableFilterComposer,
          $$InvoicesTableTableOrderingComposer,
          $$InvoicesTableTableAnnotationComposer,
          $$InvoicesTableTableCreateCompanionBuilder,
          $$InvoicesTableTableUpdateCompanionBuilder,
          (InvoiceEntry, $$InvoicesTableTableReferences),
          InvoiceEntry,
          PrefetchHooks Function({
            bool quotationId,
            bool invoiceItemsTableRefs,
            bool invoicePaymentsTableRefs,
          })
        > {
  $$InvoicesTableTableTableManager(_$AppDatabase db, $InvoicesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> referenceNumber = const Value.absent(),
                Value<int?> quotationId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> issueDate = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> subtotalPiastres = const Value.absent(),
                Value<int> discountPiastres = const Value.absent(),
                Value<int> taxPiastres = const Value.absent(),
                Value<int> grandTotalPiastres = const Value.absent(),
                Value<int> paidAmountPiastres = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => InvoiceCompanion(
                id: id,
                referenceNumber: referenceNumber,
                quotationId: quotationId,
                customerName: customerName,
                customerPhone: customerPhone,
                status: status,
                issueDate: issueDate,
                dueDate: dueDate,
                notes: notes,
                subtotalPiastres: subtotalPiastres,
                discountPiastres: discountPiastres,
                taxPiastres: taxPiastres,
                grandTotalPiastres: grandTotalPiastres,
                paidAmountPiastres: paidAmountPiastres,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String referenceNumber,
                Value<int?> quotationId = const Value.absent(),
                required String customerName,
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int issueDate,
                Value<int?> dueDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> subtotalPiastres = const Value.absent(),
                Value<int> discountPiastres = const Value.absent(),
                Value<int> taxPiastres = const Value.absent(),
                Value<int> grandTotalPiastres = const Value.absent(),
                Value<int> paidAmountPiastres = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => InvoiceCompanion.insert(
                id: id,
                referenceNumber: referenceNumber,
                quotationId: quotationId,
                customerName: customerName,
                customerPhone: customerPhone,
                status: status,
                issueDate: issueDate,
                dueDate: dueDate,
                notes: notes,
                subtotalPiastres: subtotalPiastres,
                discountPiastres: discountPiastres,
                taxPiastres: taxPiastres,
                grandTotalPiastres: grandTotalPiastres,
                paidAmountPiastres: paidAmountPiastres,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicesTableTable, InvoiceEntry>(table),
                  $$InvoicesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quotationId = false,
                invoiceItemsTableRefs = false,
                invoicePaymentsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsTableRefs) db.invoiceItemsTable,
                    if (invoicePaymentsTableRefs) db.invoicePaymentsTable,
                  ],
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
                            referencedTable: $$InvoicesTableTableReferences
                                ._quotationIdTable(db),
                            referencedColumn: $$InvoicesTableTableReferences
                                ._quotationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsTableRefs)
                        await $_getPrefetchedData<
                          InvoiceEntry,
                          $InvoicesTableTable,
                          InvoiceItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableTableReferences
                              ._invoiceItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicePaymentsTableRefs)
                        await $_getPrefetchedData<
                          InvoiceEntry,
                          $InvoicesTableTable,
                          InvoicePaymentEntry
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableTableReferences
                              ._invoicePaymentsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicePaymentsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
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

typedef $$InvoicesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTableTable,
      InvoiceEntry,
      $$InvoicesTableTableFilterComposer,
      $$InvoicesTableTableOrderingComposer,
      $$InvoicesTableTableAnnotationComposer,
      $$InvoicesTableTableCreateCompanionBuilder,
      $$InvoicesTableTableUpdateCompanionBuilder,
      (InvoiceEntry, $$InvoicesTableTableReferences),
      InvoiceEntry,
      PrefetchHooks Function({
        bool quotationId,
        bool invoiceItemsTableRefs,
        bool invoicePaymentsTableRefs,
      })
    >;
typedef $$InvoiceItemsTableTableCreateCompanionBuilder =
    InvoiceItemCompanion Function({
      Value<int> id,
      required int invoiceId,
      Value<int?> productId,
      required String productCode,
      required String productName,
      required String unit,
      required int unitPricePiastres,
      required int quantity,
      Value<int> lineDiscountPiastres,
      required int lineTotalPiastres,
    });
typedef $$InvoiceItemsTableTableUpdateCompanionBuilder =
    InvoiceItemCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<int?> productId,
      Value<String> productCode,
      Value<String> productName,
      Value<String> unit,
      Value<int> unitPricePiastres,
      Value<int> quantity,
      Value<int> lineDiscountPiastres,
      Value<int> lineTotalPiastres,
    });

final class $$InvoiceItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InvoiceItemsTableTable,
          InvoiceItemEntry
        > {
  $$InvoiceItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InvoicesTableTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoicesTable.createAlias('invoice_items__invoice_id__invoices__id');

  $$InvoicesTableTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableTableManager(
      $_db,
      $_db.invoicesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTableTable _productIdTable(_$AppDatabase db) =>
      db.productsTable.createAlias('invoice_items__product_id__products__id');

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

class $$InvoiceItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTableTable> {
  $$InvoiceItemsTableTableFilterComposer({
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

  $$InvoicesTableTableFilterComposer get invoiceId {
    final $$InvoicesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableFilterComposer(
            $db: $db,
            $table: $db.invoicesTable,
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

class $$InvoiceItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTableTable> {
  $$InvoiceItemsTableTableOrderingComposer({
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

  $$InvoicesTableTableOrderingComposer get invoiceId {
    final $$InvoicesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableOrderingComposer(
            $db: $db,
            $table: $db.invoicesTable,
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

class $$InvoiceItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTableTable> {
  $$InvoiceItemsTableTableAnnotationComposer({
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

  $$InvoicesTableTableAnnotationComposer get invoiceId {
    final $$InvoicesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.invoicesTable,
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

class $$InvoiceItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTableTable,
          InvoiceItemEntry,
          $$InvoiceItemsTableTableFilterComposer,
          $$InvoiceItemsTableTableOrderingComposer,
          $$InvoiceItemsTableTableAnnotationComposer,
          $$InvoiceItemsTableTableCreateCompanionBuilder,
          $$InvoiceItemsTableTableUpdateCompanionBuilder,
          (InvoiceItemEntry, $$InvoiceItemsTableTableReferences),
          InvoiceItemEntry,
          PrefetchHooks Function({bool invoiceId, bool productId})
        > {
  $$InvoiceItemsTableTableTableManager(
    _$AppDatabase db,
    $InvoiceItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> unitPricePiastres = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> lineDiscountPiastres = const Value.absent(),
                Value<int> lineTotalPiastres = const Value.absent(),
              }) => InvoiceItemCompanion(
                id: id,
                invoiceId: invoiceId,
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
                required int invoiceId,
                Value<int?> productId = const Value.absent(),
                required String productCode,
                required String productName,
                required String unit,
                required int unitPricePiastres,
                required int quantity,
                Value<int> lineDiscountPiastres = const Value.absent(),
                required int lineTotalPiastres,
              }) => InvoiceItemCompanion.insert(
                id: id,
                invoiceId: invoiceId,
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
                  e.readTable<$InvoiceItemsTableTable, InvoiceItemEntry>(table),
                  $$InvoiceItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, productId = false}) {
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
                    if (invoiceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.invoiceId,
                        referencedTable: $$InvoiceItemsTableTableReferences
                            ._invoiceIdTable(db),
                        referencedColumn: $$InvoiceItemsTableTableReferences
                            ._invoiceIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (productId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productId,
                        referencedTable: $$InvoiceItemsTableTableReferences
                            ._productIdTable(db),
                        referencedColumn: $$InvoiceItemsTableTableReferences
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

typedef $$InvoiceItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTableTable,
      InvoiceItemEntry,
      $$InvoiceItemsTableTableFilterComposer,
      $$InvoiceItemsTableTableOrderingComposer,
      $$InvoiceItemsTableTableAnnotationComposer,
      $$InvoiceItemsTableTableCreateCompanionBuilder,
      $$InvoiceItemsTableTableUpdateCompanionBuilder,
      (InvoiceItemEntry, $$InvoiceItemsTableTableReferences),
      InvoiceItemEntry,
      PrefetchHooks Function({bool invoiceId, bool productId})
    >;
typedef $$InvoicePaymentsTableTableCreateCompanionBuilder =
    InvoicePaymentCompanion Function({
      Value<int> id,
      required int invoiceId,
      required int amountPiastres,
      Value<String> paymentMethod,
      required int paymentDate,
      Value<String?> notes,
      required int createdAt,
    });
typedef $$InvoicePaymentsTableTableUpdateCompanionBuilder =
    InvoicePaymentCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<int> amountPiastres,
      Value<String> paymentMethod,
      Value<int> paymentDate,
      Value<String?> notes,
      Value<int> createdAt,
    });

final class $$InvoicePaymentsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InvoicePaymentsTableTable,
          InvoicePaymentEntry
        > {
  $$InvoicePaymentsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InvoicesTableTable _invoiceIdTable(_$AppDatabase db) => db
      .invoicesTable
      .createAlias('invoice_payments__invoice_id__invoices__id');

  $$InvoicesTableTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableTableManager(
      $_db,
      $_db.invoicesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoicePaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTableTable> {
  $$InvoicePaymentsTableTableFilterComposer({
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

  ColumnFilters<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
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

  $$InvoicesTableTableFilterComposer get invoiceId {
    final $$InvoicesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableFilterComposer(
            $db: $db,
            $table: $db.invoicesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTableTable> {
  $$InvoicePaymentsTableTableOrderingComposer({
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

  ColumnOrderings<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
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

  $$InvoicesTableTableOrderingComposer get invoiceId {
    final $$InvoicesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableOrderingComposer(
            $db: $db,
            $table: $db.invoicesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTableTable> {
  $$InvoicePaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableTableAnnotationComposer get invoiceId {
    final $$InvoicesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoicesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.invoicesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicePaymentsTableTable,
          InvoicePaymentEntry,
          $$InvoicePaymentsTableTableFilterComposer,
          $$InvoicePaymentsTableTableOrderingComposer,
          $$InvoicePaymentsTableTableAnnotationComposer,
          $$InvoicePaymentsTableTableCreateCompanionBuilder,
          $$InvoicePaymentsTableTableUpdateCompanionBuilder,
          (InvoicePaymentEntry, $$InvoicePaymentsTableTableReferences),
          InvoicePaymentEntry,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoicePaymentsTableTableTableManager(
    _$AppDatabase db,
    $InvoicePaymentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicePaymentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicePaymentsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InvoicePaymentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<int> amountPiastres = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int> paymentDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => InvoicePaymentCompanion(
                id: id,
                invoiceId: invoiceId,
                amountPiastres: amountPiastres,
                paymentMethod: paymentMethod,
                paymentDate: paymentDate,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required int amountPiastres,
                Value<String> paymentMethod = const Value.absent(),
                required int paymentDate,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
              }) => InvoicePaymentCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                amountPiastres: amountPiastres,
                paymentMethod: paymentMethod,
                paymentDate: paymentDate,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicePaymentsTableTable, InvoicePaymentEntry>(
                    table,
                  ),
                  $$InvoicePaymentsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
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
                    if (invoiceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.invoiceId,
                        referencedTable: $$InvoicePaymentsTableTableReferences
                            ._invoiceIdTable(db),
                        referencedColumn: $$InvoicePaymentsTableTableReferences
                            ._invoiceIdTable(db)
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

typedef $$InvoicePaymentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicePaymentsTableTable,
      InvoicePaymentEntry,
      $$InvoicePaymentsTableTableFilterComposer,
      $$InvoicePaymentsTableTableOrderingComposer,
      $$InvoicePaymentsTableTableAnnotationComposer,
      $$InvoicePaymentsTableTableCreateCompanionBuilder,
      $$InvoicePaymentsTableTableUpdateCompanionBuilder,
      (InvoicePaymentEntry, $$InvoicePaymentsTableTableReferences),
      InvoicePaymentEntry,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$BusinessProfilesTableTableCreateCompanionBuilder =
    BusinessProfileCompanion Function({
      Value<int> id,
      required String businessName,
      Value<String?> ownerName,
      required String phonePrimary,
      Value<String?> phoneSecondary,
      Value<String?> address,
      Value<String?> city,
      Value<String?> taxNumber,
      Value<String?> commercialRegister,
      Value<String?> logoPath,
      Value<String?> defaultQuotationNotes,
      Value<String?> defaultInvoiceTerms,
      required String updatedAtUtc,
    });
typedef $$BusinessProfilesTableTableUpdateCompanionBuilder =
    BusinessProfileCompanion Function({
      Value<int> id,
      Value<String> businessName,
      Value<String?> ownerName,
      Value<String> phonePrimary,
      Value<String?> phoneSecondary,
      Value<String?> address,
      Value<String?> city,
      Value<String?> taxNumber,
      Value<String?> commercialRegister,
      Value<String?> logoPath,
      Value<String?> defaultQuotationNotes,
      Value<String?> defaultInvoiceTerms,
      Value<String> updatedAtUtc,
    });

class $$BusinessProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTableTable> {
  $$BusinessProfilesTableTableFilterComposer({
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

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phonePrimary => $composableBuilder(
    column: $table.phonePrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneSecondary => $composableBuilder(
    column: $table.phoneSecondary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commercialRegister => $composableBuilder(
    column: $table.commercialRegister,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultQuotationNotes => $composableBuilder(
    column: $table.defaultQuotationNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultInvoiceTerms => $composableBuilder(
    column: $table.defaultInvoiceTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTableTable> {
  $$BusinessProfilesTableTableOrderingComposer({
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

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phonePrimary => $composableBuilder(
    column: $table.phonePrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneSecondary => $composableBuilder(
    column: $table.phoneSecondary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commercialRegister => $composableBuilder(
    column: $table.commercialRegister,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultQuotationNotes => $composableBuilder(
    column: $table.defaultQuotationNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultInvoiceTerms => $composableBuilder(
    column: $table.defaultInvoiceTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTableTable> {
  $$BusinessProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get phonePrimary => $composableBuilder(
    column: $table.phonePrimary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneSecondary => $composableBuilder(
    column: $table.phoneSecondary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get commercialRegister => $composableBuilder(
    column: $table.commercialRegister,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get defaultQuotationNotes => $composableBuilder(
    column: $table.defaultQuotationNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultInvoiceTerms => $composableBuilder(
    column: $table.defaultInvoiceTerms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$BusinessProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessProfilesTableTable,
          BusinessProfileData,
          $$BusinessProfilesTableTableFilterComposer,
          $$BusinessProfilesTableTableOrderingComposer,
          $$BusinessProfilesTableTableAnnotationComposer,
          $$BusinessProfilesTableTableCreateCompanionBuilder,
          $$BusinessProfilesTableTableUpdateCompanionBuilder,
          (
            BusinessProfileData,
            BaseReferences<
              _$AppDatabase,
              $BusinessProfilesTableTable,
              BusinessProfileData
            >,
          ),
          BusinessProfileData,
          PrefetchHooks Function()
        > {
  $$BusinessProfilesTableTableTableManager(
    _$AppDatabase db,
    $BusinessProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfilesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BusinessProfilesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BusinessProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String?> ownerName = const Value.absent(),
                Value<String> phonePrimary = const Value.absent(),
                Value<String?> phoneSecondary = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> commercialRegister = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> defaultQuotationNotes = const Value.absent(),
                Value<String?> defaultInvoiceTerms = const Value.absent(),
                Value<String> updatedAtUtc = const Value.absent(),
              }) => BusinessProfileCompanion(
                id: id,
                businessName: businessName,
                ownerName: ownerName,
                phonePrimary: phonePrimary,
                phoneSecondary: phoneSecondary,
                address: address,
                city: city,
                taxNumber: taxNumber,
                commercialRegister: commercialRegister,
                logoPath: logoPath,
                defaultQuotationNotes: defaultQuotationNotes,
                defaultInvoiceTerms: defaultInvoiceTerms,
                updatedAtUtc: updatedAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String businessName,
                Value<String?> ownerName = const Value.absent(),
                required String phonePrimary,
                Value<String?> phoneSecondary = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> commercialRegister = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> defaultQuotationNotes = const Value.absent(),
                Value<String?> defaultInvoiceTerms = const Value.absent(),
                required String updatedAtUtc,
              }) => BusinessProfileCompanion.insert(
                id: id,
                businessName: businessName,
                ownerName: ownerName,
                phonePrimary: phonePrimary,
                phoneSecondary: phoneSecondary,
                address: address,
                city: city,
                taxNumber: taxNumber,
                commercialRegister: commercialRegister,
                logoPath: logoPath,
                defaultQuotationNotes: defaultQuotationNotes,
                defaultInvoiceTerms: defaultInvoiceTerms,
                updatedAtUtc: updatedAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BusinessProfilesTableTable, BusinessProfileData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BusinessProfilesTableTable,
                    BusinessProfileData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessProfilesTableTable,
      BusinessProfileData,
      $$BusinessProfilesTableTableFilterComposer,
      $$BusinessProfilesTableTableOrderingComposer,
      $$BusinessProfilesTableTableAnnotationComposer,
      $$BusinessProfilesTableTableCreateCompanionBuilder,
      $$BusinessProfilesTableTableUpdateCompanionBuilder,
      (
        BusinessProfileData,
        BaseReferences<
          _$AppDatabase,
          $BusinessProfilesTableTable,
          BusinessProfileData
        >,
      ),
      BusinessProfileData,
      PrefetchHooks Function()
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
  $$InvoicesTableTableTableManager get invoicesTable =>
      $$InvoicesTableTableTableManager(_db, _db.invoicesTable);
  $$InvoiceItemsTableTableTableManager get invoiceItemsTable =>
      $$InvoiceItemsTableTableTableManager(_db, _db.invoiceItemsTable);
  $$InvoicePaymentsTableTableTableManager get invoicePaymentsTable =>
      $$InvoicePaymentsTableTableTableManager(_db, _db.invoicePaymentsTable);
  $$BusinessProfilesTableTableTableManager get businessProfilesTable =>
      $$BusinessProfilesTableTableTableManager(_db, _db.businessProfilesTable);
}
