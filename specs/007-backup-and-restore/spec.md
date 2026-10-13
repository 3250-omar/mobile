# Feature Specification: 007-backup-and-restore

**Feature Branch**: `007-backup-and-restore`  
**Created**: 2026-10-14  
**Status**: Draft  
**Input**: User description: "ميزة النسخ الاحتياطي والاستعادة محلياً (007-backup-and-restore): تصدير واستيراد قاعدة البيانات محلياً مع التحقق من سلامة البيانات والتخزين الآمن دون أي سحابة"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Local Database Backup Export (Priority: P1)

A plumbing merchant wants to safeguard their catalog, customer quotations, and sales invoices. The merchant goes to Settings, opens the "النسخ الاحتياطي والاستعادة" (Backup & Restore) screen, and taps "إنشاء نسخة احتياطية" (Create Backup).

The app safely flushes all pending SQLite WAL transactions to disk, generates an integrity-sealed backup file containing a SHA-256 checksum, creation timestamp, and database snapshot, and opens the native device file picker/share sheet so the merchant can save the backup file to their phone storage, SD card, or USB drive.

**Why this priority**: Without offline export, if the merchant loses or changes their device, all customer debts, quotations, and product catalog are permanently lost.

**Independent Test**: Can be tested by invoking backup export on a populated database and verifying that the exported file is written, has a valid SHA-256 integrity header, and contains all tables and records.

**Acceptance Scenarios**:
1. **Given** an existing populated SQLite database, **When** the merchant taps "إنشاء نسخة احتياطية", **Then** an atomic backup package (`.aqb` / `offline_quotes_backup_YYYYMMDD_HHMMSS.aqb`) is generated with zero network access.
2. **Given** backup export completes, **When** inspected, **Then** the file contains a tamper-proof integrity manifest (version, timestamp, record counts, SHA-256 hash).
3. **Given** the export process is running, **When** active transactions occur, **Then** the backup executes atomically after a clean WAL checkpoint without corrupting active operations.

---

### User Story 2 - Non-Destructive Pre-Validated Restore (Priority: P1)

The merchant obtains a new phone or needs to restore their data after an accidental device reset. On the Restore screen, the merchant taps "استعادة نسخة احتياطية" (Restore Backup) and selects an existing backup file.

Before overwriting the active database, the system validates the file structure, checks the SHA-256 checksum, and verifies SQLite schema compatibility. Crucially, the app takes an automatic safety snapshot of the active database before replacing it. If the backup file is corrupt, truncated, or tampered with, the system aborts with a clear Arabic error message and leaves the active data untouched.

**Why this priority**: Guarantees compliance with Constitution Principle IV (Data Integrity and Historical Immutability): never destroy, wipe, or corrupt existing data upon a failed restore.

**Independent Test**: Provide both a valid backup file and a corrupted/tampered file; verify valid restores completely and corrupted files are rejected without damaging existing data.

**Acceptance Scenarios**:
1. **Given** a valid backup file, **When** the merchant selects it and confirms restore, **Then** the active database is updated, all tables reflect the restored data, and the app prompts to refresh or reload seamlessly.
2. **Given** a corrupted or truncated backup file, **When** restore is attempted, **Then** the system detects checksum failure, rejects the file, surfaces a safe localized error, and leaves the active database unchanged.
3. **Given** a backup file from an incompatible future schema, **When** inspected, **Then** the app rejects the restore with a message requesting an app update first.

---

### User Story 3 - Optional Backup Password Protection (Priority: P2)

When creating a backup, the merchant can optionally set a password to encrypt their business records (prices, customer lists, unpaid invoices). When restoring a password-protected backup, the app prompts for the password before decrypting and restoring.

**Why this priority**: Plumbing merchants often share backup files over WhatsApp or email to themselves; encryption ensures competitors or unauthorized parties cannot inspect wholesale prices and margins.

**Independent Test**: Export with password, verify file is encrypted and cannot be parsed without password, then restore with correct password successfully.

**Acceptance Scenarios**:
1. **Given** a merchant chooses to protect their backup with a password, **When** exported, **Then** the payload is encrypted using strong authenticated encryption (AES-256-GCM / PBKDF2).
2. **Given** an encrypted backup file, **When** the merchant enters the correct password during restore, **Then** the data is decrypted and verified.
3. **Given** an incorrect password, **When** restore is attempted, **Then** decryption fails gracefully with "كلمة المرور غير صحيحة" without crashing or modifying current data.

---

### User Story 4 - Backup Status & Last Backup Timestamp (Priority: P3)

The settings screen displays the timestamp of the last successful backup (e.g., "آخر نسخة احتياطية: اليوم 02:15 م" or "لم يتم أخذ نسخة احتياطية بعد"). If no backup has been created in more than 7 days, a subtle warning reminder recommends creating a backup.

**Why this priority**: Encourages good merchant backup habits to avoid data loss.

**Independent Test**: Verify last backup date updates after a successful backup and persists in `app_settings`.

**Acceptance Scenarios**:
1. **Given** a successful backup export, **When** completed, **Then** `lastBackupAtUtc` is updated in `app_settings`.
2. **Given** the merchant visits Settings, **When** viewing the backup card, **Then** the formatted Arabic date of the last backup is displayed.

---

### Edge Cases

- **Insufficient Storage**: If the target storage lacks disk space, the system catches the error cleanly without leaving partial files.
- **Corrupt File Header**: Rejection occurs before closing or modifying the active database connection.
- **App Crash during Restore**: The atomic rollback mechanism ensures that either the restore completes 100% or the pre-restore backup is retained intact.
- **Device Offline**: 100% of the workflow executes without internet connection, analytics, or external APIs.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST create an atomic database backup package from the active Drift SQLite database.
- **FR-002**: Backup package MUST include SHA-256 integrity checksum, schema version, creation timestamp, and database content.
- **FR-003**: System MUST execute a `wal_checkpoint(TRUNCATE)` before reading SQLite database files to guarantee consistent snapshots.
- **FR-004**: System MUST validate file checksum and SQLite header integrity BEFORE initiating database replacement during restore.
- **FR-005**: System MUST create an automatic pre-restore backup of the active database before restoring, ensuring zero data loss if restore is interrupted.
- **FR-006**: System MUST support optional password-based encryption and decryption of backup archives.
- **FR-007**: System MUST record the timestamp of the last successful backup in local persistent settings.
- **FR-008**: System MUST provide a dedicated Arabic "النسخ الاحتياطي والاستعادة" screen in Settings with clear progress and status indicators.
- **FR-009**: The entire backup and restore pipeline MUST function 100% offline with zero external network traffic.
- **FR-010**: All error messages MUST be safe, localized in Arabic, and free from raw system stack traces or sensitive file paths.

### Key Entities

- **BackupMetadata**:
  - `version`: int
  - `createdAt`: DateTime
  - `checksumSha256`: String
  - `isEncrypted`: bool
  - `totalProductsCount`: int
  - `totalQuotationsCount`: int
  - `totalInvoicesCount`: int
- **BackupResult**:
  - `filePath`: String
  - `sizeBytes`: int
  - `createdAt`: DateTime
- **RestoreValidationResult**:
  - `isValid`: bool
  - `metadata`: BackupMetadata?
  - `errorCode`: String?
  - `errorMessage`: String?

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Backup package generation completes in under 500 milliseconds for databases with up to 10,000 records.
- **SC-002**: 100% of corrupted, truncated, or tampered backup files are detected and rejected prior to active database replacement.
- **SC-003**: Zero bytes of network traffic transmitted during backup, verification, or restore.
- **SC-004**: In the event of a simulated restore failure, 100% of existing merchant data is preserved without corruption or data loss.

---

## Assumptions

- SQLite WAL mode is active (`PRAGMA journal_mode=WAL`).
- Device file picking and saving is handled via cross-platform file picker or document exporter.
- Encryption uses standard Dart cryptographic primitives (`crypto` / AES-GCM) without external cloud key vaults.
