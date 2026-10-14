import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/business_profile.dart';
import '../domain/business_profile_repository.dart';

/// Drift and filesystem implementation of [BusinessProfileRepository].
class DriftBusinessProfileRepository implements BusinessProfileRepository {
  DriftBusinessProfileRepository(
    this._db, {
    Future<String> Function()? storageDirectoryResolver,
  }) : _storageDirectoryResolver =
           storageDirectoryResolver ?? _defaultStorageResolver;

  final AppDatabase _db;
  final Future<String> Function() _storageDirectoryResolver;

  static Future<String> _defaultStorageResolver() async {
    final supportDir = await getApplicationSupportDirectory();
    final profileDir = Directory(p.join(supportDir.path, 'profile'));
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }
    return profileDir.path;
  }

  BusinessProfile _mapDataToDomain(BusinessProfileData data) {
    return BusinessProfile(
      id: data.id,
      businessName: data.businessName,
      ownerName: data.ownerName,
      phonePrimary: data.phonePrimary,
      phoneSecondary: data.phoneSecondary,
      address: data.address,
      city: data.city,
      taxNumber: data.taxNumber,
      commercialRegister: data.commercialRegister,
      logoPath: data.logoPath,
      defaultQuotationNotes: data.defaultQuotationNotes,
      defaultInvoiceTerms: data.defaultInvoiceTerms,
      updatedAt: DateTime.parse(data.updatedAtUtc),
    );
  }

  BusinessProfileCompanion _mapDomainToCompanion(BusinessProfile profile) {
    return BusinessProfileCompanion(
      id: const Value(1),
      businessName: Value(profile.businessName),
      ownerName: Value(profile.ownerName),
      phonePrimary: Value(profile.phonePrimary),
      phoneSecondary: Value(profile.phoneSecondary),
      address: Value(profile.address),
      city: Value(profile.city),
      taxNumber: Value(profile.taxNumber),
      commercialRegister: Value(profile.commercialRegister),
      logoPath: Value(profile.logoPath),
      defaultQuotationNotes: Value(profile.defaultQuotationNotes),
      defaultInvoiceTerms: Value(profile.defaultInvoiceTerms),
      updatedAtUtc: Value(profile.updatedAt.toUtc().toIso8601String()),
    );
  }

  @override
  Future<BusinessProfile> load() async {
    try {
      final query = _db.select(_db.businessProfilesTable)
        ..where((tbl) => tbl.id.equals(1));
      final row = await query.getSingleOrNull();

      if (row != null) {
        return _mapDataToDomain(row);
      }

      // Initialize default singleton profile
      final defaults = BusinessProfile.defaults();
      await _db
          .into(_db.businessProfilesTable)
          .insert(
            _mapDomainToCompanion(defaults),
            mode: InsertMode.insertOrReplace,
          );
      return defaults;
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Stream<BusinessProfile> watch() {
    final query = _db.select(_db.businessProfilesTable)
      ..where((tbl) => tbl.id.equals(1));
    return query.watchSingleOrNull().map((row) {
      if (row != null) {
        return _mapDataToDomain(row);
      }
      return BusinessProfile.defaults();
    });
  }

  @override
  Future<BusinessProfile> save(BusinessProfile profile) async {
    if (profile.businessName.trim().isEmpty) {
      throw const AppFailure(
        code: 'VALIDATION_ERROR',
        messageKey: 'errorEmptyBusinessName',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    try {
      final updated = profile.copyWith(updatedAt: DateTime.now());
      await _db
          .into(_db.businessProfilesTable)
          .insert(
            _mapDomainToCompanion(updated),
            mode: InsertMode.insertOrReplace,
          );
      return updated;
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Future<String> saveLogoFile(List<int> bytes, String extension) async {
    try {
      final dirPath = await _storageDirectoryResolver();
      final sanitizedExt = extension.replaceAll('.', '').toLowerCase();
      final targetFile = File(p.join(dirPath, 'store_logo.$sanitizedExt'));
      await targetFile.writeAsBytes(bytes, flush: true);

      final current = await load();
      final updated = current.copyWith(
        logoPath: targetFile.path,
        updatedAt: DateTime.now(),
      );
      await save(updated);

      return targetFile.path;
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Future<void> deleteLogoFile() async {
    try {
      final current = await load();
      if (current.logoPath != null) {
        final file = File(current.logoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      final updated = current.copyWith(
        clearLogo: true,
        updatedAt: DateTime.now(),
      );
      await save(updated);
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }
}
