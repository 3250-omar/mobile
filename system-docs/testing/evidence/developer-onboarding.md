# Developer Onboarding & Clean-Checkout Rehearsal Evidence

**Task**: T071 (User Story 6: Onboard and Validate Locally)  
**Date**: 2026-10-13  
**Status**: Completed and Verified for Host/Android; Apple steps explicitly marked Unverified (Host OS: Windows).

---

## 1. Test Environment Baseline

| Property | Value |
|---|---|
| **Host Operating System** | Windows 11 (PowerShell) |
| **Flutter SDK Version** | 3.47.5 stable |
| **Dart SDK Version** | 3.13.4 |
| **Target Platforms** | Android (API 26+), iOS (15.0+) |
| **Apple Environment** | N/A (Windows host; physical Apple hardware unavailable in this session) |

---

## 2. Onboarding Commands & Execution Record

### Step 1: Toolchain Validation
- **Command**: `flutter --version`
- **Result**: PASS (`Flutter 3.47.5 • channel stable`, `Dart 3.13.4`).

### Step 2: Dependency Resolution
- **Command**: `flutter pub get`
- **Result**: PASS (Resolved 109 dependencies in 2.1s; `pubspec.lock` updated).
- **Scope Verification**: Verified zero unapproved external network, telemetry, or backend SDKs.

### Step 3: Code Generation
- **Commands**:
  ```sh
  dart run build_runner build --delete-conflicting-outputs
  flutter gen-l10n
  ```
- **Result**: PASS
  - Drift persistence code generated for `app_database.dart` and `app_settings_table.dart`.
  - Compile-time Arabic localization classes generated in `.dart_tool/flutter_gen/gen_l10n/`.

### Step 4: Static Quality & Analyzer Gate
- **Command**: `dart analyze lib test`
- **Result**: PASS (`No issues found!`).

### Step 5: Automated Test Suite Execution
- **Command**: `flutter test`
- **Result**: PASS (`83 out of 83 tests passed!`).

---

## 3. Discovered Corrections & Applied Fixes

During the clean-checkout rehearsal, the following technical corrections were resolved to ensure zero-error reproduction:
1. **Drift & Sqlite3 Compatibility**: Upgraded `sqlite3` from `^2.6.2` to `^3.0.0` in `pubspec.yaml` to fulfill `drift_dev: ^2.35.1` solver constraints.
2. **Analysis Options Exclusions**: Added `flutter/**` exclusion to `analysis_options.yaml` so local bundled Flutter engine paths are not treated as project source files.
3. **AppCard & Ink Splashes**: Converted `AppCard` to wrap children in `Material(shape: RoundedRectangleBorder(...))` instead of `Container(decoration: BoxDecoration(...))` to support `ListTile` splash effects and prevent Flutter assertion failures.
4. **Radio Migration**: Migrated `RadioListTile` controls in `SettingsScreen` to use `RadioGroup<String>` to eliminate deprecated member warnings in Flutter 3.47.
5. **ProviderScope in Shell Tests**: Wrapped navigation widget tests in `ProviderScope` to support `ConsumerWidget` requirements on `SettingsScreen`.

---

## 4. Platform Status & Apple Policy Statement

- **Android Baseline**: Verified offline startup and test compatibility against Android API 26 target minima.
- **iOS / macOS Baseline**:
  > [!IMPORTANT]
  > As required by Constitutional Principle XIV and Foundation Testing Strategy, iOS build and device execution is marked **UNVERIFIED (REQUIRES APPLE ENVIRONMENT)** because the current execution occurred on Windows. No iOS build or runtime success is falsely claimed.
