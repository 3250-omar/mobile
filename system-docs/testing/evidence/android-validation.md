# Android Platform Validation Evidence

**Task**: T073 (Phase 9: Integration, QA, and Constitutional Exit Gates)  
**Date**: 2026-10-13  
**Status**: BUILD & DEVICE RUN PENDING LOCAL ANDROID SDK INSTALLATION

---

## 1. Static Configuration Audit

The Android platform configuration was verified statically and complies with all foundational architectural and privacy requirements:

| Configuration Item | File Path | Specified Setting | Verification Status |
|---|---|---|---|
| **Minimum SDK** | `android/app/build.gradle.kts` | `minSdk = 26` (Android 8.0 Oreo) | VERIFIED |
| **Target / Compile SDK** | `android/app/build.gradle.kts` | `compileSdk = 34`, `targetSdk = 34` | VERIFIED |
| **Application ID** | `android/app/build.gradle.kts` | `com.offlinequotes.mobile` | VERIFIED |
| **Backup Policy** | `android/app/src/main/AndroidManifest.xml` | `android:allowBackup="false"` | VERIFIED |
| **Data Extraction Rules** | `android/app/src/main/res/xml/data_extraction_rules.xml` | `<cloud-backup><exclude path="." /></cloud-backup>`<br>`<device-transfer><exclude path="." /></device-transfer>` | VERIFIED |
| **Legacy Backup Rules** | `android/app/src/main/res/xml/backup_rules.xml` | Excludes `database`, `sharedpref`, `file`, and root storage | VERIFIED |
| **Cleartext Traffic** | `android/app/src/main/AndroidManifest.xml` | `android:usesCleartextTraffic="false"` | VERIFIED |
| **Permissions Audit** | `android/app/src/main/AndroidManifest.xml` | Zero sensitive permissions (no camera, internet, location, contacts, or storage permissions) | VERIFIED |

---

## 2. Release Build Execution Record

- **Command**: `flutter build apk --release --dart-define=APP_ENV=production`
- **Host Tooling Check**:
  ```text
  [!] No Android SDK found. Try setting the ANDROID_HOME environment variable.
  ```
- **Finding**: On the current development workstation, the Android SDK command-line tools and platform SDK are not configured in `ANDROID_HOME`.
- **Honest Disposition**: In adherence with the project constitution, Android production APK generation and physical Pixel device validation are noted as pending local Android SDK installation. No synthetic build success is fabricated.

---

## 3. Required Commands for Environment Completion

Once Android SDK API 26+ is installed and configured in `ANDROID_HOME`:

```sh
# 1. Build release APK
flutter build apk --release --dart-define=APP_ENV=production

# 2. Run device integration tests on attached Android device or API 26 emulator
flutter test integration_test/reliability_cycles_test.dart -d <device-id> --dart-define=APP_ENV=testing
flutter test integration_test/startup_performance_test.dart -d <device-id> --dart-define=APP_ENV=testing
flutter test integration_test/settings_persistence_test.dart -d <device-id> --dart-define=APP_ENV=testing
flutter test integration_test/lifecycle_recovery_test.dart -d <device-id> --dart-define=APP_ENV=testing
```
