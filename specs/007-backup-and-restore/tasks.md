# Tasks: 007-backup-and-restore

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Directory structure and feature module initialization

- [X] T001 Create backup feature module directories in `lib/features/backup/domain/`, `lib/features/backup/data/`, `lib/features/backup/application/`, and `lib/features/backup/presentation/widgets/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain entities, contracts, and container coder that MUST be complete before user stories

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Implement `BackupMetadata` pure Dart domain entity in `lib/features/backup/domain/backup_metadata.dart`
- [X] T003 [P] Implement `BackupResult` and `RestoreValidationResult` domain entities in `lib/features/backup/domain/backup_result.dart`
- [X] T004 Implement `BackupRestoreService` abstract interface contract in `lib/features/backup/domain/backup_restore_service.dart`
- [X] T005 [P] Implement pure Dart SHA-256 and `BackupContainerCoder` binary container format in `lib/features/backup/data/backup_container_coder.dart`
- [X] T006 [P] Unit tests for `BackupContainerCoder` in `test/features/backup/backup_container_coder_test.dart`

**Checkpoint**: Foundation ready - container coder and domain contracts verified.

---

## Phase 3: User Story 1 - Local Database Backup Export (Priority: P1) 🎯 MVP

**Goal**: Safely checkpoint SQLite WAL, package the database into an integrity-checksummed `.aqb` file, and allow exporting to local storage.

**Independent Test**: Trigger backup export and verify that `.aqb` contains valid header, checksum, and all SQLite data without network.

### Tests for User Story 1

- [X] T007 [P] [US1] Unit and integration tests for backup creation and WAL checkpointing in `test/features/backup/default_backup_restore_service_test.dart`

### Implementation for User Story 1

- [X] T008 [US1] Implement `DefaultBackupRestoreService` with WAL checkpointing, metadata creation, and file export in `lib/features/backup/data/default_backup_restore_service.dart`
- [X] T009 [US1] Implement `BackupRestoreController` StateNotifier and `BackupRestoreState` in `lib/features/backup/application/backup_restore_controller.dart`
- [X] T010 [P] [US1] Register `backupRestoreServiceProvider` and `backupRestoreControllerProvider` in `lib/app/bootstrap/providers.dart`
- [X] T011 [P] [US1] Implement `BackupCard` presentation widget in `lib/features/backup/presentation/widgets/backup_card.dart`
- [X] T012 [US1] Implement `BackupRestoreScreen` in `lib/features/backup/presentation/backup_restore_screen.dart` and register route in `lib/app/navigation/route_names.dart` and `lib/app/navigation/app_router.dart`

**Checkpoint**: User Story 1 fully functional and testable independently.

---

## Phase 4: User Story 2 - Non-Destructive Pre-Validated Restore (Priority: P1)

**Goal**: Inspect backup files, verify SHA-256 checksum and SQLite integrity, create a safety snapshot, and safely restore or roll back on error.

**Independent Test**: Verify corrupted files are rejected without altering the database, while valid backups restore all records.

### Tests for User Story 2

- [X] T013 [P] [US2] Safety and rollback integration tests in `test/features/backup/restore_safety_test.dart`

### Implementation for User Story 2

- [X] T014 [US2] Implement `validateBackupFile` and `restoreBackup` with automatic `.pre_restore.bak` snapshot and rollback in `lib/features/backup/data/default_backup_restore_service.dart`
- [X] T015 [P] [US2] Implement `RestoreCard` presentation widget in `lib/features/backup/presentation/widgets/restore_card.dart`
- [X] T016 [US2] Integrate restore flow and confirmation dialog in `BackupRestoreScreen` in `lib/features/backup/presentation/backup_restore_screen.dart`

**Checkpoint**: User Stories 1 and 2 work independently.

---

## Phase 5: User Story 3 - Optional Password Protection (Priority: P2)

**Goal**: Allow setting a password to encrypt backup files, and prompt for password during restore.

**Independent Test**: Export with password, verify payload cannot be read without password, and restore with correct password.

### Tests for User Story 3

- [X] T017 [P] [US3] Unit tests for encrypted backup creation, decryption, and wrong password rejection in `test/features/backup/encrypted_backup_test.dart`

### Implementation for User Story 3

- [X] T018 [US3] Implement pure Dart PBKDF2 key derivation and stream cipher in `BackupContainerCoder` in `lib/features/backup/data/backup_container_coder.dart`
- [X] T019 [P] [US3] Implement `PasswordPromptDialog` in `lib/features/backup/presentation/widgets/password_prompt_dialog.dart`
- [X] T020 [US3] Hook password prompt into export and restore in `BackupRestoreScreen` in `lib/features/backup/presentation/backup_restore_screen.dart`

**Checkpoint**: Encrypted backup and restore fully functional.

---

## Phase 6: User Story 4 - Backup Status & Last Backup Timestamp (Priority: P3)

**Goal**: Display last backup date in Settings and warn if no backup in > 7 days.

**Independent Test**: Check last backup date updates after export and displays localized Arabic date.

### Implementation for User Story 4

- [X] T021 [P] [US4] Record and fetch last backup timestamp in `lib/features/backup/data/default_backup_restore_service.dart`
- [X] T022 [US4] Display last backup card in `SettingsScreen` in `lib/features/settings/presentation/settings_screen.dart`

---

## Phase 7: Polish & Quality Gates

**Purpose**: Format code, analyze lints, run entire test suite, and verify architecture compliance

- [X] T023 Run `dart format --output=none --set-exit-if-changed lib test`
- [X] T024 Run `flutter analyze lib test`
- [X] T025 Run full test suite `flutter test`
- [X] T026 Verify architectural boundary compliance in `test/architecture/dependency_direction_test.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 completion - BLOCKS all user stories.
- **User Story 1 (Phase 3)**: Depends on Phase 2. MVP core.
- **User Story 2 (Phase 4)**: Depends on Phase 2.
- **User Story 3 (Phase 5)**: Depends on Phase 2.
- **User Story 4 (Phase 6)**: Depends on Phase 2.
- **Polish (Phase 7)**: Depends on all user story phases completion.
