# Technical Research: Flutter Application Foundation

**Feature**: `001-project-foundation`  
**Researched**: 2026-10-12  
**Rule**: Versions are a planning baseline, not installed dependencies. Resolve and commit `pubspec.lock` during implementation and revalidate platform compatibility before an upgrade.

## 1. SDK and platform baseline

**Decision**: Flutter 3.47.5 stable with Dart 3.13.4; Android minSdk 26 and iOS deployment target 15.0.

**Rationale**: 3.47.5 is the current stable patch at planning time. Flutter's supported-platform matrix covers Android API 24-37 and iOS 15-27, so the clarified minima are within the tested support range. Selecting an exact stable patch improves reproducibility and retains iOS 15.

**Alternatives**:

- Flutter beta/main: rejected because production foundations should not depend on prerelease channels.
- An older stable release: rejected because it adds immediate upgrade work and does not improve the clarified platform floor.

**Verification**: [Flutter SDK archive](https://docs.flutter.dev/install/archive), [supported deployment platforms](https://docs.flutter.dev/reference/supported-platforms), [Flutter 3.47 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.47.0).

## 2. UI framework packaging

**Decision**: Use `material_ui` 1.6.0 on Flutter 3.47 rather than opting back into the legacy framework Material library. Add `cupertino_ui` directly only when application code imports Cupertino widgets.

**Rationale**: Flutter 3.47 stabilizes standalone design-system packages. The standalone package provides the Material UI and localization surface while keeping the application aligned with the current migration direction. Package imports stay in presentation/theme code, limiting churn.

**Alternative**: Legacy `package:flutter/material.dart` opt-in is mature but deprecated/migration-bound on this SDK baseline; rejected for a new application.

**Verification**: [Flutter design-system package migration](https://docs.flutter.dev/release/breaking-changes/design-system-packages), [`material_ui` package](https://pub.dev/packages/material_ui), [`cupertino_ui` package](https://pub.dev/packages/cupertino_ui).

## 3. State management and dependency injection

**Decision**: `flutter_riverpod` 3.4.3 with manual providers/notifiers. Riverpod is also the dependency-composition mechanism.

**Rationale**: It supports immutable state, lifecycle-aware providers, overrides for tests, and replaceable infrastructure without a global mutable locator. Using it for both state and DI avoids duplicate frameworks. Manual providers keep this small foundation readable and avoid generator coupling.

**Alternatives**:

- BLoC: mature and testable but adds event/state boilerplate for a small foundation.
- Provider: simpler, but dependency overrides and async composition are less expressive for bootstrap/migration states.
- GetIt plus another state library: rejected because it duplicates composition mechanisms and can obscure dependency ownership.

**Verification**: [`flutter_riverpod` package](https://pub.dev/packages/flutter_riverpod), [Riverpod documentation](https://riverpod.dev/).

## 4. Navigation

**Decision**: `go_router` 18.0.2 using `StatefulShellRoute.indexedStack`.

**Rationale**: It supports declarative named routes, nested navigators, redirects, restoration, platform back integration, and preserved branch state. The indexed shell maps directly to the clarified four-item navigation, while Scan and Settings remain root routes.

**Alternatives**:

- Navigator API used directly: capable but requires more custom route parsing, nested-stack, restoration, and test plumbing.
- AutoRoute: feature-rich but introduces another generator and annotations without a present need.

**Verification**: [`go_router` package](https://pub.dev/packages/go_router), [`StatefulShellRoute` API](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html).

## 5. SQLite access and migrations

**Decision**: `drift` 2.35.2, `drift_flutter` 0.3.1, `drift_dev` 2.35.1, and `build_runner` 2.16.2. Store the database under the private application-support directory.

**Rationale**: Drift provides typed queries, explicit transactions, schema versions, generated schema snapshots, migration verification, reactive reads, and background-native opening. These directly reduce the constitutional risks of inconsistent migrations and silent partial writes. Its adapter remains behind repository contracts. Connections use foreign keys, WAL, a 5-second busy timeout, and `synchronous=FULL`; platform file-backed tests verify these settings. This favors durable commits and future read concurrency over the simpler rollback journal.

**Alternatives**:

- `sqflite`: mature and simpler initially, but relies more heavily on raw SQL/string mapping and custom migration-test discipline.
- Isar/ObjectBox: not selected because the constitution explicitly requires SQLite and future relational financial records benefit from SQL constraints/transactions.

**Verification**: [`drift`](https://pub.dev/packages/drift), [`drift_flutter`](https://pub.dev/packages/drift_flutter), [`drift_dev`](https://pub.dev/packages/drift_dev), [`build_runner`](https://pub.dev/packages/build_runner), [Drift migration tests](https://drift.simonbinder.eu/migrations/tests/).

## 6. Settings persistence

**Decision**: Persist foundational settings in the Drift database as one versioned singleton aggregate. Do not add `shared_preferences`.

**Rationale**: Theme/locale settings participate in tested migrations, deterministic initialization, transactional commits, and failure reporting. One storage mechanism prevents split-brain initialization and supports the requirement that persistence failures are visible.

**Alternative**: `shared_preferences` is convenient for noncritical primitive preferences, but it cannot provide the same relational migration/transaction guarantees and would add a second persistence lifecycle.

## 7. Localization, numerals, and fonts

**Decision**: Flutter `gen_l10n` with ARB resources, Arabic `ar` as template/default/current locale, and `intl` 0.20.3 for explicit locale-aware formatting and bidi helpers. Bundle static Noto Sans Arabic weights 400/500/600/700 plus Noto Sans Latin fallback.

**Rationale**: SDK generation is compile-time, offline, typed, and readily extensible with another ARB. Bundled static fonts remove runtime network/cache behavior and offer predictable Android/iOS shaping. Explicit formatters implement the clarified Western-output/dual-input numeral policy without changing literal codes.

**Alternatives**:

- Runtime JSON translation: less type-safe and defers missing-key failures.
- A network font package: violates deterministic offline startup.
- Device default fonts only: rejected because Arabic metrics and cross-platform visual consistency vary.

**Verification**: [Flutter internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization), [`intl` 0.20.3](https://pub.dev/packages/intl), [Noto Arabic documentation](https://notofonts.github.io/arabic/), [Noto fonts repository/license](https://github.com/notofonts/arabic).

## 8. Diagnostics

**Decision**: `logging` 1.3.0 with an application-owned adapter and bounded rotating JSONL file sink in application support. Keep the sink independent of SQLite.

**Rationale**: The Dart package supplies structured levels and hierarchy without network behavior. The local adapter enforces redaction, bounded retention, stable event codes, and test substitution; file independence preserves diagnostics when database opening fails.

**Alternatives**:

- Cloud crash reporting: constitutionally prohibited and unusable offline.
- Console-only logging: unavailable to normal users and insufficient for startup diagnosis.
- Store logs in SQLite: cannot diagnose a database-open failure.

**Verification**: [`logging` 1.3.0](https://pub.dev/packages/logging), [`path_provider` 2.1.6](https://pub.dev/packages/path_provider), [`path` 1.9.1](https://pub.dev/packages/path).

## 9. Code generation

**Decision**: Limit generated code to Drift and Flutter localization. Do not add Freezed, Riverpod generator, GoRouter builder, or model generators in this feature.

**Rationale**: Drift generation materially improves schema safety; localization generation prevents missing/incorrect message APIs. Other generators add build complexity before the model/route surface warrants them.

## 10. Testing toolchain

**Decision**: Use SDK `flutter_test` and `integration_test`, Riverpod overrides, Drift temporary/in-memory databases, file-backed migration fixtures, Flutter semantics testing, and targeted golden tests. `flutter_lints` 6.0.0 supplies the lint baseline.

**Rationale**: The SDK tools cover unit/widget/device behavior and integrate with both platforms without unnecessary test dependencies. File-backed fixtures are required where in-memory SQLite would hide reopen/path/migration behavior.

**Alternative**: Add mocking and golden-management packages immediately; deferred until a test demonstrates a real need.

**Verification**: [Flutter testing overview](https://docs.flutter.dev/testing/overview), [integration testing](https://docs.flutter.dev/testing/integration-tests), [`flutter_lints`](https://pub.dev/packages/flutter_lints).

## 11. Application environments

**Decision**: A compile-time `APP_ENV=development|testing|production` value via `--dart-define`, parsed into a closed enum.

**Rationale**: It is lightweight and deterministic, needs no environment file or runtime server, and allows logging/assertion differences without separate native flavors. No environment may contain a URL, secret, or different data-integrity rule.

**Alternative**: Native product flavors/schemes are deferred until distribution requirements require distinct bundle identifiers or signing profiles.

## 12. Rejected scope

No research choice authorizes OCR, camera, Excel, catalog, matching, pricing, quotation/invoice, PDF, inventory, cloud sync, payment, backup, or restore implementation. Future OCR must be an on-demand adapter and must not become a bootstrap dependency.

## 13. Platform data protection and automatic backup

**Decision**: Keep all foundation data in private application storage, explicitly disable/exclude Android
cloud backup and device transfer, exclude the iOS Application Support database/settings/diagnostic files
from backup, and apply `NSFileProtectionCompleteUntilFirstUserAuthentication` on iOS. Treat protection
application or verification failure as blocking initialization failure.

**Rationale**: Private directory placement alone does not prevent OS-managed backup. Backup/restore is a
future separately specified capability, so automatic copying would bypass consent, integrity checks, and
the constitution's local-data guarantees. Android sandbox encryption and iOS Data Protection provide
platform-native at-rest protection without introducing a key-management dependency in this feature.

**Alternatives**:

- Permit default OS backup: rejected because it can transmit or restore database/diagnostic state outside
  the approved backup workflow.
- Add application-level database encryption now: deferred because this foundation stores no business or
  customer data and the constitution requires maintainable simplicity; future sensitive-data specifications
  must re-evaluate threat model and key management.
- Implement backup/restore now: explicitly out of scope.

**Implementation boundary**: Android policy is declarative in manifests and backup/data-extraction XML.
iOS uses a small native adapter to apply and read URL backup-exclusion and file-protection attributes for
the database, sidecars, settings, and diagnostic paths.
