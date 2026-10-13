# Offline Quotes & Invoices (عروض الأسعار والفواتير)

A 100% offline, privacy-first, Arabic-first Flutter mobile application for quotations and invoices.

## Architectural Principles & Scope Guard

- **100% Offline Core**: Zero runtime network requests, telemetry, remote authentication, remote fonts, or cloud synchronization.
- **Arabic-First RTL**: Built from the ground up for right-to-left layout with bundled local fonts (Noto Sans Arabic).
- **Local Persistence & Data Safety**: Drift over SQLite with forward-only migrations, atomic transactions, OS backup exclusion, and non-destructive failure recovery.
- **Clean Architecture & Riverpod**: Domain logic remains completely independent of Flutter, Drift, and routing. Manual Riverpod composition without hidden service locators.
- **Strict Scope Boundary**: Foundation phase strictly implements `app_settings` and shell navigation. Excludes OCR/camera scanning, catalog parsing, pricing, PDF generation, cloud backups, and external integrations.

---

## Prerequisites

- **Flutter SDK**: 3.47.5 stable (includes Dart 3.13.4).
- **Android Target**: Android Studio with Android SDK (minimum API 26 / Android 8.0).
- **iOS Target**: macOS, Xcode 15+, CocoaPods, iOS 15+ simulator, and Apple developer signing environment.
- **System Doctor**: Ensure `flutter doctor -v` passes with no blocking issues.

> [!IMPORTANT]
> Apple builds and device validation strictly require macOS, Xcode, and physical Apple devices. iOS results can never be simulated or inferred from Windows/Android execution.

---

## Getting Started

### 1. Install Dependencies
```sh
flutter pub get
```

### 2. Code Generation
Generate compile-time Drift SQLite database code and localized message catalogs:
```sh
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 3. Run the Application

The application requires an explicit compile-time `APP_ENV` definition (`development`, `testing`, or `production`):

```sh
# Development mode
flutter run --dart-define=APP_ENV=development

# Testing mode
flutter run --dart-define=APP_ENV=testing

# Production-like profile mode
flutter run --profile --dart-define=APP_ENV=production
```

---

## Static Quality & Verification Gates

### Code Formatting & Static Analysis
```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
```

### Generated Code Freshness Check
```sh
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- lib drift_schemas
```

### Automated Unit, Widget & Architecture Tests
```sh
flutter test
```

### Integration & Device Tests
```sh
# Android device
flutter test integration_test -d <android-device-id> --dart-define=APP_ENV=testing

# iOS device / simulator (on macOS only)
flutter test integration_test -d <ios-device-id> --dart-define=APP_ENV=testing
```

---

## Production Builds

### Android Release APK
```sh
flutter build apk --release --dart-define=APP_ENV=production
```

### iOS Release Build (macOS only)
```sh
# Compile check without codesign
flutter build ios --release --no-codesign --dart-define=APP_ENV=production

# Signed release build for archive / TestFlight
flutter build ipa --release --dart-define=APP_ENV=production
```

---

## Documentation & References

- [Project Constitution](.specify/memory/constitution.md)
- [Agent & Developer Entry Point](AGENTS.md)
- [Foundation Architecture](system-docs/architecture/project-foundation.md)
- [Local Persistence Documentation](system-docs/data/local-persistence.md)
- [Security & Diagnostics Policy](system-docs/security/local-data-and-diagnostics.md)
- [Setup Guide](system-docs/development/setup.md)
- [Testing Strategy & Evidence](system-docs/testing/foundation-strategy.md)
- [Feature 001 Quickstart](specs/001-project-foundation/quickstart.md)
