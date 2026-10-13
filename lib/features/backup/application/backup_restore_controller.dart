import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/backup_result.dart';
import '../domain/backup_restore_service.dart';

/// State of the backup and restore operations.
class BackupRestoreState {
  const BackupRestoreState({
    this.isBusy = false,
    this.currentStage,
    this.lastBackupAt,
    this.lastBackupResult,
    this.validationResult,
    this.failure,
    this.successMessage,
  });

  final bool isBusy;
  final String? currentStage;
  final DateTime? lastBackupAt;
  final BackupResult? lastBackupResult;
  final RestoreValidationResult? validationResult;
  final AppFailure? failure;
  final String? successMessage;

  BackupRestoreState copyWith({
    bool? isBusy,
    String? currentStage,
    DateTime? lastBackupAt,
    BackupResult? lastBackupResult,
    RestoreValidationResult? validationResult,
    AppFailure? failure,
    String? successMessage,
    bool clearFailure = false,
    bool clearSuccess = false,
  }) {
    return BackupRestoreState(
      isBusy: isBusy ?? this.isBusy,
      currentStage: currentStage ?? this.currentStage,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      lastBackupResult: lastBackupResult ?? this.lastBackupResult,
      validationResult: validationResult ?? this.validationResult,
      failure: clearFailure ? null : (failure ?? this.failure),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

/// StateNotifier controller orchestrating backup creation and validated restore.
class BackupRestoreController extends StateNotifier<BackupRestoreState> {
  BackupRestoreController(this._service) : super(const BackupRestoreState()) {
    loadLastBackupTimestamp();
  }

  final BackupRestoreService _service;

  Future<void> loadLastBackupTimestamp() async {
    final timestamp = await _service.getLastBackupTimestamp();
    state = state.copyWith(lastBackupAt: timestamp);
  }

  Future<BackupResult?> createBackup({String? password}) async {
    state = state.copyWith(
      isBusy: true,
      currentStage: 'جاري إنشاء النسخة الاحتياطية وتأمين البيانات...',
      clearFailure: true,
      clearSuccess: true,
    );

    try {
      final result = await _service.createBackup(password: password);
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        lastBackupResult: result,
        lastBackupAt: result.metadata.createdAt,
        successMessage: 'تم إنشاء النسخة الاحتياطية بنجاح وحفظها محلياً',
      );
      return result;
    } catch (e) {
      final failure = e is AppFailure
          ? e
          : AppFailure(
              code: 'BACKUP_CREATE_ERROR',
              messageKey: 'errorGeneric',
              category: AppFailureCategory.storage,
              retryable: true,
              causeForLogs: e.toString(),
            );
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        failure: failure,
      );
      return null;
    }
  }

  Future<RestoreValidationResult> validateBackupFile(
    String filePath, {
    String? password,
  }) async {
    state = state.copyWith(
      isBusy: true,
      currentStage: 'جاري فحص سلامة ملف النسخة الاحتياطية...',
      clearFailure: true,
    );

    try {
      final result = await _service.validateBackupFile(
        filePath,
        password: password,
      );
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        validationResult: result,
      );
      return result;
    } catch (e) {
      final failure = e is AppFailure
          ? e
          : AppFailure(
              code: 'BACKUP_VALIDATE_ERROR',
              messageKey: 'errorGeneric',
              category: AppFailureCategory.validation,
              retryable: false,
              causeForLogs: e.toString(),
            );
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        failure: failure,
      );
      return RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.invalidContainerHeader,
        diagnosticMessage: e.toString(),
      );
    }
  }

  Future<bool> restoreBackup(String filePath, {String? password}) async {
    state = state.copyWith(
      isBusy: true,
      currentStage: 'جاري استعادة البيانات والتحقق من سلامة الجداول...',
      clearFailure: true,
      clearSuccess: true,
    );

    try {
      await _service.restoreBackup(filePath, password: password);
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        successMessage: 'تمت استعادة البيانات بنجاح',
      );
      return true;
    } catch (e) {
      final failure = e is AppFailure
          ? e
          : AppFailure(
              code: 'BACKUP_RESTORE_ERROR',
              messageKey: 'errorGeneric',
              category: AppFailureCategory.storage,
              retryable: false,
              causeForLogs: e.toString(),
            );
      state = state.copyWith(
        isBusy: false,
        currentStage: null,
        failure: failure,
      );
      return false;
    }
  }
}
