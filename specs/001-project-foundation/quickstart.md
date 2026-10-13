# Quickstart and Validation Guide

**Status**: Implemented and verified for feature `001-project-foundation`.

## Prerequisites

- Flutter 3.47.5 stable (includes Dart 3.13.4).
- Android Studio/SDK with an Android API 26 emulator and a current supported SDK/device.
- For iOS: macOS, compatible Xcode, CocoaPods if required by resolved plugins, an iOS 15 simulator, and an appropriate Apple development/signing environment for device/release validation.
- Git and platform command-line tooling reported healthy by `flutter doctor -v`.

## First local setup (after implementation exists)

```sh
flutter --version
flutter doctor -v
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

Do not introduce runtime downloads, endpoint configuration, or secrets. Commit `pubspec.lock` and generated Drift/localization outputs according to repository policy.

## Run

Development:

```sh
flutter run --dart-define=APP_ENV=development
```

Testing configuration:

```sh
flutter run --dart-define=APP_ENV=testing
```

Production-like profile validation:

```sh
flutter run --profile --dart-define=APP_ENV=production
```

Arabic must open by default. System theme must be the first-launch default. No online sign-in, remote font, remote configuration, or server availability may affect startup.

## Static quality gates

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- lib drift_schemas
```

The generated-code check may be adjusted to the committed generated paths once the project is scaffolded.

## Automated tests

```sh
flutter test
flutter test test/core/database
flutter test test/app
```

Run device integration tests separately:

```sh
flutter test integration_test -d <android-device-id> --dart-define=APP_ENV=testing
flutter test integration_test -d <ios-device-id> --dart-define=APP_ENV=testing
```

The iOS command must execute on macOS. A simulator is acceptable for minimum-version behavior, but performance/offline exit evidence includes a physical iPhone.

## Builds

Android release artifact:

```sh
flutter build apk --release --dart-define=APP_ENV=production
```

iOS compile check on macOS without signing:

```sh
flutter build ios --release --no-codesign --dart-define=APP_ENV=production
```

Final iOS device/archive validation additionally requires valid Apple signing. Do not report iOS validation from Windows or from Android test results.

## Manual offline acceptance

1. Install a clean production-like build.
2. Enable airplane mode and disable Wi-Fi before launching the process.
3. Cold-launch; confirm an Arabic RTL gate/shell and interactive readiness within the specified threshold.
4. Visit Home, Products, Quotations, Invoices, Scan unavailable state, and Settings.
5. Select Light or Dark, force-close, relaunch still offline, and verify persistence.
6. Return to System theme and verify OS appearance changes are honored.
7. Exercise Android system back or iOS navigation gestures and verify preserved branch state.
8. Inject or simulate database/storage initialization failure; verify the shell is blocked, files are preserved, and retry/diagnostic behavior is visible.
9. Observe device network activity and inspect manifest/entitlements; record that no foundational path attempted transmission.
10. Inspect the merged Android release manifest and data-extraction XML for disabled/excluded backup and
    cleartext traffic. On iOS, read the effective excluded-from-backup and
    `NSFileProtectionCompleteUntilFirstUserAuthentication` attributes for the database, WAL/SHM sidecars,
    settings, and diagnostic files. Any backup-eligible or unprotected required file fails acceptance.

Record OS, device/model, build commit/mode, clean-versus-existing database, five cold/warm timings, and pass/fail evidence. Follow `system-docs/testing/foundation-strategy.md`.

## Quality Evidence Records

All phase validation evidence is documented under `system-docs/testing/evidence/`:
- [Static & Automated Test Evidence](../../system-docs/testing/evidence/static-and-automated.md)
- [Developer Onboarding & Clean Checkout Evidence](../../system-docs/testing/evidence/developer-onboarding.md)
- [Android Platform Validation Evidence](../../system-docs/testing/evidence/android-validation.md)
- [iOS Platform Validation Evidence](../../system-docs/testing/evidence/ios-validation.md)
- [Offline Privacy & Protection Evidence](../../system-docs/testing/evidence/offline-privacy-validation.md)
- [Reliability & Lifecycle Cycles Evidence](../../system-docs/testing/evidence/reliability-validation.md)
- [Performance Benchmarking Evidence](../../system-docs/testing/evidence/performance-validation.md)
- [Arabic-First & Accessibility Evidence](../../system-docs/testing/evidence/arabic-accessibility-validation.md)
- [Constitutional & Scope Audit Evidence](../../system-docs/testing/evidence/constitution-and-scope-audit.md)
