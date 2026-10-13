# Quickstart: Backup & Restore

This guide describes how to validate the Backup & Restore feature end-to-end.

## Prerequisites

- Local SQLite database initialized with products, quotations, or invoices.

## Verification Scenarios

### 1. Verification of Backup Generation & File Integrity
- Run: `flutter test test/features/backup/backup_restore_service_test.dart`
- Expected:
  - Generates a valid `.aqb` file containing magic header `AQB1`.
  - JSON metadata contains correct record counts and SHA-256 hash.
  - Verification succeeds with status `isValid: true`.

### 2. Verification of Corruption Rejection & Rollback Safety
- Run: `flutter test test/features/backup/backup_restore_safety_test.dart`
- Expected:
  - Tampered payload bytes are rejected with `checksumMismatch`.
  - Attempting to restore a corrupted file leaves the existing database 100% intact with zero record loss.

### 3. Verification of Password-Protected Encrypted Backup
- Run: `flutter test test/features/backup/encrypted_backup_test.dart`
- Expected:
  - Export with password creates encrypted payload.
  - Restore with wrong password is rejected without modifying database.
  - Restore with correct password decrypts and restores all records.

### 4. UI Screen & Dialog Tests
- Run: `flutter test test/features/backup/backup_restore_screen_test.dart`
- Expected:
  - Settings backup section renders last backup date.
  - Creating backup triggers progress dialog and completion snackbar.
