# Dependency and Security Audit: Foundation Feature

**Feature**: `001-project-foundation`  
**Date**: 2026-10-12  
**Compliance**: Constitution Principle XI (Security & Privacy), Principle XIII (Maintainable Simplicity), NFR-006 (Privacy & Offline)

---

## 1. Runtime Dependencies Disposition

| Package | Version | License | Network / Telemetry Disposition | Backup & Storage Disposition |
|---|---|---|---|---|
| `flutter` | SDK | BSD-3-Clause | Pure UI framework; no telemetry in app runtime. | N/A |
| `flutter_localizations` | SDK | BSD-3-Clause | Local compile-time ARB localization. 100% offline. | N/A |
| `intl` | ^0.20.3 | BSD-3-Clause | Pure string/date/number format logic. No network. | N/A |
| `material_ui` | ^1.6.0 | BSD-3-Clause | Modular Material design system package. No network. | N/A |
| `flutter_riverpod` | ^3.4.3 | MIT | In-memory reactive state and dependency injection. Zero telemetry. | In-memory state only. |
| `go_router` | ^18.0.2 | BSD-3-Clause | Declarative in-app routing and state preservation. No network. | In-memory navigation state. |
| `drift` | ^2.35.2 | MIT | Local SQLite ORM and migrations. Pure SQLite engine. | Resides strictly in private Application Support directory. Excluded from OS backup. |
| `drift_flutter` | ^0.3.1 | MIT | Flutter SQLite connection resolver for Drift. | Targets Application Support. |
| `sqlite3` | ^3.0.0 | MIT | SQLite bindings for low-level PRAGMA verification and testing. | Private sandbox storage only. |
| `path_provider` | ^2.1.6 | BSD-3-Clause | Resolves OS-specific Application Support directory. | Resolves encrypted private sandbox paths. |
| `path` | ^1.9.1 | BSD-3-Clause | Pure path string manipulation. No network. | N/A |
| `logging` | ^1.3.0 | BSD-3-Clause | Standard Dart logging facade. Configured to write strictly to local rotating file sink. | Rotated bounded JSONL files in private Application Support. Excluded from OS backup. |

---

## 2. Development Dependencies Disposition

| Package | Version | License | Role |
|---|---|---|---|
| `flutter_test` | SDK | BSD-3-Clause | Unit and widget test runner. |
| `integration_test` | SDK | BSD-3-Clause | On-device integration test runner. |
| `flutter_lints` | ^6.0.0 | BSD-3-Clause | Static analysis rules. Zero runtime impact. |
| `drift_dev` | ^2.35.1 | MIT | Build-time SQL/Drift code generator. Zero runtime impact. |
| `build_runner` | ^2.16.2 | BSD-3-Clause | Dart development build tool. Zero runtime impact. |

---

## 3. Bundled Asset Fonts

| Asset Family | Weights | License | Disposition |
|---|---|---|---|
| Noto Sans Arabic | 400, 500, 600, 700 | SIL Open Font License 1.1 | Bundled locally in `assets/fonts/`. Loaded offline by Flutter engine without any network requests. |

---

## 4. Platform Backup and Cloud Sync Exclusion Policy

- **Android**:
  - `android:allowBackup="false"` in `AndroidManifest.xml`.
  - Full backup exclusion XML (`backup_rules.xml`) excludes all domains (`root`, `file`, `database`, `sharedpref`, `external`).
  - Android 12+ data extraction rules XML (`data_extraction_rules.xml`) completely disables cloud backup and device-to-device transfer for all domains.
  - Cleartext traffic is disabled (`android:usesCleartextTraffic="false"`).
- **iOS**:
  - All database files, SQLite WAL/SHM sidecars, settings, and diagnostic logs are stored exclusively under the private Application Support directory.
  - Native helper `LocalDataProtectionHandler` applies `URLResourceKey.isExcludedFromBackupKey = true` to all files and directories.
  - Applies `NSFileProtectionType.completeUntilFirstUserAuthentication` to protect data at rest when device is locked before first unlock.
