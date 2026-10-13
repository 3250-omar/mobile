# iOS Platform Validation Evidence

**Task**: T074 (User Story 6 / Constitutional Exit Gate)  
**Date**: 2026-10-13  
**Status**: UNVERIFIED — PENDING APPLE HARDWARE ENVIRONMENT

---

## 1. Constitutional Gate Policy (Principle XIV)

> Never claim iOS build/device success unless executed in a compatible Apple environment. iOS results are never inferred from Windows or Android execution.

Current execution environment:
- **Host**: Windows 11 (PowerShell)
- **Apple Tooling**: Not available on Windows host (Xcode, macOS kernel, CocoaPods iOS toolchain require Apple hardware).

---

## 2. Requirements for Complete Verification

When transitioning to a compatible macOS build runner, the following procedures must be executed:

### Step 1: Clean Pod Install
```sh
cd ios
pod install --repo-update
cd ..
```

### Step 2: Unsigned Release Compilation Gate
```sh
flutter build ios --release --no-codesign --dart-define=APP_ENV=production
```
- **Target OS**: iOS 15.0 minimum deployment target.
- **Verification**: Zero compilation errors in Runner Xcode project and Swift platform code (`LocalDataProtection.swift`).

### Step 3: Simulator Verification (iPhone 8 / iOS 15)
```sh
flutter test integration_test -d <iphone-8-ios15-simulator-id> --dart-define=APP_ENV=testing
```

### Step 4: Physical Device & Code-Signing Validation (iPhone SE 2nd Gen)
```sh
flutter build ipa --release --dart-define=APP_ENV=production
flutter install -d <iphone-se-device-id>
```
- **Verification Criteria**:
  - Valid Apple Developer provisioning profile and code signing.
  - Airplane mode launch on physical device: 100% offline, zero network prompt.
  - Inspection of `isExcludedFromBackupKey` and `NSFileProtectionCompleteUntilFirstUserAuthentication` attributes on `app_database.sqlite` and `.jsonl` diagnostic files.
  - Cold launch latency ≤ 3.0 s, warm launch latency ≤ 2.0 s.

---

## 3. Current Disposition

- Code level: Swift plugin implementation exists at `ios/Runner/LocalDataProtection.swift` and is registered in `ios/Runner/AppDelegate.swift`. iOS deployment target is configured to 15.0 in `ios/Podfile` and `ios/Runner.xcodeproj/project.pbxproj`.
- Runtime execution: **UNVERIFIED**. Left unchecked until run on a compatible Apple device.
