# Offline Privacy & Protection Validation Evidence

**Task**: T075 (Phase 9: Integration, QA, and Constitutional Exit Gates)  
**Date**: 2026-10-13  
**Status**: PASSED (100% Offline Integrity & Backup Exclusion Verified)

---

## 1. Network Boundary & Telemetry Audit

An exhaustive source audit of `pubspec.yaml`, `pubspec.lock`, and `lib/` confirms:
- **Zero HTTP Clients**: Neither `package:http` nor `package:dio` is included.
- **Zero Telemetry SDKs**: No analytics, crash reporting, or telemetry tracking libraries exist (no Firebase, Sentry, Datadog, or Mixpanel).
- **Zero Cloud/Authentication SDKs**: No Cognito, Firebase Auth, OAuth, or remote licensing services.
- **Zero Remote Assets**: All fonts (Noto Sans Arabic 400/500/600/700 and Latin fallback) are bundled under `assets/fonts/`.
- **Zero Network Permissions**: The Android manifest declares no internet permissions (`android.permission.INTERNET` is omitted).

---

## 2. Airplane Mode & Offline Journey Verification

Automated test suites verify offline operation with all networking absent:

| Test Journey | Suite | Verification Result |
|---|---|---|
| **Clean Offline Startup** | `test/app/bootstrap/offline_startup_test.dart` | PASS — Boots from zero files, creates private SQLite database, inserts default `app_settings`, and displays Arabic Home. |
| **Subsequent Offline Startup** | `test/features/settings/data/settings_repository_test.dart` | PASS — Reads existing singleton settings row without network probes or token refreshes. |
| **Navigation Across Shell** | `test/app/navigation/app_router_test.dart` | PASS — Navigates between Home, Products, Quotations, Invoices, Scan, and Settings without invoking remote endpoints. |
| **Theme Selection & Persistence** | `test/features/settings/presentation/settings_screen_test.dart` | PASS — Switches theme mode locally and persists atomically. |
| **Failure Gate & Recovery** | `test/app/bootstrap/offline_startup_test.dart` | PASS — Injected database/storage errors display localized recovery guidance without external error reporting. |

---

## 3. OS Backup Exclusion & At-Rest Protection

### Android Protection
- **`AndroidManifest.xml`**:
  ```xml
  android:allowBackup="false"
  android:usesCleartextTraffic="false"
  android:dataExtractionRules="@xml/data_extraction_rules"
  android:fullBackupContent="@xml/backup_rules"
  ```
- **`data_extraction_rules.xml`**:
  - Excludes root path (`.`) from `<cloud-backup>` (Google Drive).
  - Excludes root path (`.`) from `<device-transfer>` (cable and Wi-Fi transfer).
- **`backup_rules.xml`**:
  - Excludes `database`, `sharedpref`, `file`, and root storage for devices running Android 11 and lower.

### iOS Protection
- **`ios/Runner/LocalDataProtection.swift`**:
  - Sets `URLResourceValues.isExcludedFromBackupKey = true` on `app_database.sqlite`, `-wal`, `-shm`, and `.jsonl` diagnostic files.
  - Sets `NSFileProtectionType.completeUntilFirstUserAuthentication` file protection attribute.
- **`lib/core/storage/platform_data_protection.dart`**:
  - Asserts that database files reside strictly within the private application sandbox and rejects any public storage paths (`/sdcard/`, `Downloads`). Verified by `test/core/storage/platform_data_protection_test.dart`.
