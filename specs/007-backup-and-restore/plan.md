# Implementation Plan: 007-backup-and-restore

**Branch**: `007-backup-and-restore` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/007-backup-and-restore/spec.md`

## Summary

Implement 100% offline local database backup and restore for Arabic quotes and invoices. The system packages SQLite into a tamper-proof binary container (`.aqb`) with SHA-256 integrity verification, optional password encryption, WAL checkpointing, and safe pre-restore rollback protection to ensure zero data loss under any failure condition.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: `crypto`, `flutter_riverpod`, `drift`, `sqlite3`, `path_provider`, `file_picker`  
**Storage**: SQLite local database file (`app_database.sqlite`)  
**Testing**: `flutter test` (Unit, Integration, Tampering & Rollback safety tests)  
**Target Platform**: Android (API 26+) and iOS (15.0+)  
**Project Type**: Mobile Application  
**Performance Goals**: Backup creation < 500ms for 10k records, restore verification < 200ms  
**Constraints**: 100% offline (0 network requests), atomic rollback safety, Arabic RTL UI, pure Dart domain layer  
**Scale/Scope**: 1 backup service implementation, 1 presentation screen under settings, unit/widget tests  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I (100% Offline Operation)**: PASS. All file hashing, encryption, and packing execute locally on-device. Zero cloud or network dependencies.
- **Principle III (Local Data Ownership)**: PASS. Users can export their entire database to local storage / SD card / share sheet.
- **Principle IV (Data Integrity and Historical Immutability)**: PASS. Two-stage restore with automated pre-restore safety copy guarantees active data is never corrupted or lost on failed restore.
- **Principle V (Deterministic Financial Accuracy)**: PASS. Byte-for-byte SQLite database preservation guarantees exact financial precision.
- **Principle VIII (Arabic-First Experience)**: PASS. RTL layout, Cairo / Noto Sans Arabic typography, clear Arabic error and success messages.
- **Principle IX (Modular Architecture)**: PASS. Pure Dart domain entities and repository contract; replaceable service implementation.

## Project Structure

### Documentation (this feature)

```text
specs/007-backup-and-restore/
├── spec.md              # Feature specification
├── plan.md              # Implementation plan
├── research.md          # Technical decisions and research
├── data-model.md        # Domain entities and state models
├── quickstart.md        # Quickstart validation guide
├── contracts/
│   └── backup_restore_service.md # Service contract
├── checklists/
│   └── requirements.md  # Specification checklist
└── tasks.md             # Generated tasks
```

### Source Code

```text
lib/
├── features/
│   └── backup/
│       ├── domain/
│       │   ├── backup_metadata.dart
│       │   ├── backup_result.dart
│       │   ├── restore_validation_result.dart
│       │   └── backup_restore_service.dart
│       ├── data/
│       │   ├── backup_container_coder.dart
│       │   └── default_backup_restore_service.dart
│       ├── application/
│       │   ├── backup_restore_state.dart
│       │   └── backup_restore_controller.dart
│       └── presentation/
│           ├── backup_restore_screen.dart
│           └── widgets/
│               ├── backup_card.dart
│               ├── restore_card.dart
│               └── password_prompt_dialog.dart
test/
└── features/
    └── backup/
        ├── backup_container_coder_test.dart
        ├── default_backup_restore_service_test.dart
        ├── backup_restore_controller_test.dart
        └── backup_restore_screen_test.dart
```

**Structure Decision**: Standard feature slice under `lib/features/backup/` with domain, data, application, and presentation layers adhering to architectural constraints.

## Complexity Tracking

No constitution violations. Pure Dart container packaging and SQLite WAL checkpoints.
