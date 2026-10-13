# Development Setup & Tooling Guide

**Status**: Verified for Feature `001-project-foundation`.

---

## 1. System Requirements & Baseline

- **Flutter SDK**: 3.47.5 stable (includes Dart 3.13.4).
- **Android Target**:
  - Minimum supported OS: Android 8.0 (API 26).
  - Target/Compile SDK: Android API 34.
  - Requires Android Studio with command-line tools and platform-tools (`adb`).
- **iOS Target**:
  - Minimum supported OS: iOS 15.0.
  - **Prerequisite**: iOS builds, simulators, and physical device runs strictly require **macOS** with **Xcode 15+** and **CocoaPods**.
  - Windows or Linux environments cannot build, sign, or test iOS binaries.

---

## 2. Environment Configuration (`APP_ENV`)

The application enforces a closed compile-time environment flag passed via `--dart-define`:
- `APP_ENV=development`: Default local development mode with verbose diagnostics.
- `APP_ENV=testing`: Test harness mode with deterministic clocks and mock bypass seams.
- `APP_ENV=production`: Production mode with hardened redaction and diagnostic rotation.

> [!WARNING]
> Omitting `APP_ENV` or passing an unrecognized value causes application launch to fail immediately with a typed `CONFIG_INVALID` failure.

---

## 3. Fresh Checkout Setup Steps

From a clean repository checkout, run:

```sh
# 1. Verify Flutter environment
flutter doctor -v

# 2. Resolve approved dependencies
flutter pub get

# 3. Generate SQLite database classes and localization files
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 4. Verify static quality gates
dart format --output=none --set-exit-if-changed .
flutter analyze lib test

# 5. Run test suite
flutter test
```

---

## 4. Platform Execution Commands

### Android Device / Emulator
```sh
# Run in debug mode
flutter run -d <android-device-id> --dart-define=APP_ENV=development

# Build release APK
flutter build apk --release --dart-define=APP_ENV=production
```

### iOS Device / Simulator (macOS Only)
```sh
# Pod installation
cd ios && pod install && cd ..

# Run on iOS simulator
flutter run -d <ios-simulator-id> --dart-define=APP_ENV=development

# Release compilation check without code signing
flutter build ios --release --no-codesign --dart-define=APP_ENV=production

# Release IPA for device/distribution (requires Apple Developer credentials)
flutter build ipa --release --dart-define=APP_ENV=production
```
