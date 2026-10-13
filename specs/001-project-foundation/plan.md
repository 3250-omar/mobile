# Implementation Plan: Flutter Application Foundation

**Branch**: `001-project-foundation` | **Date**: 2026-10-12 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/001-project-foundation/spec.md`

## Summary

Establish a production-quality Flutter 3.47.5 / Dart 3.13.4 application shell for Android 8 (API 26) and iOS 15+. Use a pragmatic feature-first architecture, Riverpod for state composition and dependency injection, GoRouter for state-preserving navigation, Drift over SQLite for transactional persistence, generated ARB localization, bundled Arabic fonts, and privacy-safe local diagnostics. Startup renders an Arabic bootstrap gate, opens and migrates SQLite offline, loads settings, then exposes the shell. Blocking failures preserve files and offer retry/diagnostics; storage is never silently reset.

Only the navigable shell, design-system primitives, settings persistence, database/diagnostics foundations, tests, and documentation are included. OCR, camera recognition, Excel import, catalog operations, matching, pricing, quotation/invoice logic, PDF generation, and backup/restore are excluded.

## Technical Context

**Language/Version**: Dart 3.13.4 with Flutter 3.47.5 stable

**Primary Dependencies**: `material_ui` 1.6.0, `flutter_riverpod` 3.4.3, `go_router` 18.0.2, `drift` 2.35.2, `drift_flutter` 0.3.1, `logging` 1.3.0, `path_provider` 2.1.6, `path` 1.9.1, `intl` 0.20.3; Flutter SDK localization

**Development Dependencies**: `flutter_lints` 6.0.0, `drift_dev` 2.35.1, `build_runner` 2.16.2, SDK `flutter_test` and `integration_test`

**Storage**: SQLite through Drift; one `app_settings` table, schema snapshots, transactional migrations, application-support database; bounded JSONL diagnostics outside SQLite

**Testing**: Unit, widget/semantics, migration, stable golden, and integration tests on Android and iOS

**Target Platform**: Android 8/API 26+ and iOS 15+

**Project Type**: Mobile application

**Performance Goals**: Interactive shell within 3 seconds cold and 2 seconds warm on reference hardware; navigation response starts within 100 ms; settings success only after commit

**Constraints**: Fully offline; Arabic/current locale and RTL by default; no authentication, backend, cloud logging, remote fonts, runtime downloads, silent failure, or destructive recovery
**Scale/Scope**: Six foundational destinations, four shell branches, one settings aggregate, replaceable local infrastructure

### Application identity

- Flutter/Dart project: `offline_quotes`
- Organization: `com.offlinequotes`
- Android application ID: `com.offlinequotes.mobile`
- iOS bundle ID: `com.offlinequotes.mobile`

These are approved technical identifiers for deterministic scaffolding, not final user-facing branding.

## Constitution Check

### Pre-design gate

| Principle | Planned evidence | Result |
|---|---|---|
| 100% Offline | No runtime network dependency/permission; all startup assets and services are local | PASS |
| Cross-Platform | Shared Flutter source; API 26+ and iOS 15+ validation | PASS |
| Local Data Ownership | SQLite and diagnostics stay in private application support | PASS |
| Data Integrity | Transactions, migration snapshots/tests, idempotent startup, no reset-on-failure | PASS |
| Financial Accuracy | No financial calculation is introduced | PASS |
| AI Reliability | No OCR/model integration; future OCR remains a replaceable feature adapter | PASS |
| Human-in-the-Loop | No recognition/finalization behavior is introduced | PASS |
| Arabic-First | Arabic ARB, bundled fonts, RTL shell, bidi/numeral rules, device tests | PASS |
| Modular Architecture | Feature boundaries and replaceable infrastructure adapters | PASS |
| Testing | Unit, widget, migration, integration, offline, performance, Android/iOS evidence | PASS |
| Security and Privacy | No transmission; private protected paths; Android/iOS automatic-backup exclusion; redacted bounded logs; no secrets | PASS |
| Spec-Driven Development | Constitution, spec, clarification, research, and plan precede tasks/code | PASS |
| Maintainability | Riverpod handles state/DI; limited codegen; active boundaries only | PASS |
| Documentation | Feature artifacts, `system-docs/`, and `AGENTS.md` | PASS |
| Incremental Delivery | Foundation independent; future modules are unavailable screens only | PASS |
| Scope Discipline | No cloud, inventory, ERP, payment, or future business implementation | PASS |

### Post-design gate

The data model and contracts introduce only settings, initialization, navigation, database, and diagnostics concepts. No backend or future business schema is introduced. All gates remain **PASS**; no exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/001-project-foundation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/{application-initialization,diagnostics-and-errors,local-database,navigation,platform-data-protection,settings-repository}.md
system-docs/{README.md,architecture/project-foundation.md,development/setup.md,testing/foundation-strategy.md}
AGENTS.md
```

### Source Code (to be created during implementation)

```text
android/
ios/
assets/fonts/
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── bootstrap/{app_environment.dart,bootstrap.dart,initialization_controller.dart}
│   ├── localization/locale_policy.dart
│   ├── navigation/{app_router.dart,app_shell.dart,route_names.dart}
│   └── theme/{app_theme.dart,tokens/}
├── core/
│   ├── database/{app_database.dart,database_connection.dart,migrations/,tables/app_settings_table.dart}
│   ├── diagnostics/
│   ├── errors/
│   ├── lifecycle/
│   └── storage/platform_data_protection.dart
├── features/
│   ├── home/presentation/
│   ├── scan/presentation/
│   ├── products/presentation/
│   ├── quotations/presentation/
│   ├── invoices/presentation/
│   └── settings/{application/,data/,domain/,presentation/}
├── l10n/app_ar.arb
└── shared/widgets/
test/{app/,core/,features/,shared/}
integration_test/
drift_schemas/
```

**Structure Decision**: Organization is feature-first; `app/`, `core/`, and `shared/` hold genuine cross-cutting concerns. Only Settings needs domain/application/data layers now. Other destinations contain localized presentation-only unavailable states, so speculative empty layers are prohibited. Presentation may use application/domain contracts; data implements domain contracts; domain imports no Flutter, Drift, router, or plugin. Features do not import each other. The app root wires adapters through Riverpod.

## Architecture Decisions

### State management and dependency injection

Riverpod owns observable state and dependency composition. Bootstrap constructs environment, logger, database, settings repository, router, and theme controller. Provider overrides replace adapters in tests. Use manual providers/notifiers; no second locator and no Riverpod codegen until repetition justifies it.

Initialization is immutable: `notStarted`, `initializing(stage)`, `ready(settings)`, `failed(failure, attemptId)`. Retry starts an idempotent new attempt while retaining the diagnostic reference. Only `ready` exposes the shell.

### Navigation

GoRouter uses `StatefulShellRoute.indexedStack` for Home, Products, Quotations, and Invoices. Home is initial. Scan is a prominent root route returning to its origin; Settings is a secondary root route. Named routes/stable paths prevent string scattering.

Back dismisses overlays, pops nested content, returns a branch to root, returns to Home, then permits platform exit. iOS gestures and Android system/predictive back follow conventions. Branch state persists; repeated branch selection may pop that branch to root.

### Errors, diagnostics, and configuration

Expected failures become typed `AppFailure` values with stable code, localized safe message key, retryability, and optional diagnostic reference. Root zone/framework handlers capture unexpected errors; UI never displays raw exceptions.

Three rotating JSONL files of at most 512 KiB each under application support remain usable if SQLite fails. Early events buffer; free text/identifiers are redacted; business/customer/OCR content is excluded; nothing is transmitted. Viewing/copying requires deliberate user action.

Development/testing/production use typed compile-time `APP_ENV` via `--dart-define`. Unknown values fail into the bootstrap error screen. Environments contain no secrets/endpoints and cannot weaken offline behavior. Tests use provider overrides.

## Application Initialization and Lifecycle

1. Ensure bindings and validate configuration.
2. Establish framework/zone capture and emergency diagnostic buffering.
3. Resolve private application support and start the file sink.
4. Open SQLite, enable required pragmas, validate/migrate transactionally, and check opening/integrity.
5. Load the settings singleton or insert deterministic defaults in one transaction.
6. Construct theme, localization, and router; transition to ready.

A bundled Arabic gate renders during startup. Failure blocks the shell and presents localized explanation, retry, and diagnostics. Retry closes partial resources and repeats safely. Files are never deleted, recreated, or downgraded automatically.

The connection lives for the process and is disposed by tests. Backgrounding flushes settings/log buffers without migration; resume restores shell state and reloads only stale data. Force-close safety relies on commits, not termination callbacks.

## Arabic-First UI and Design System

`ar` is the default and only selectable locale here; ARB/generated localization makes future locales additive. Root direction is RTL and directional APIs are mandatory. Product codes/file names and other LTR fragments use bidi isolation. Literal name/code digits remain unchanged; generated numbers use Western digits; input accepts Western and Arabic-Indic digits and normalizes only at validation.

Bundle static Noto Sans Arabic 400/500/600/700 with Noto Sans Latin fallback and license notices. No remote fonts. Text at 200% must not clip or hide actions.

Use semantic tokens. Initial light tokens: background `#F8FAFC`, surface `#FFFFFF`, text `#020617`, primary `#0F172A`, action `#0369A1`, on-action `#FFFFFF`, muted text `#475569`, border `#E2E8F0`, error `#B91C1C`. Initial dark tokens: background `#020617`, surface `#0F172A`, text `#F8FAFC`, primary `#E2E8F0`, action `#38BDF8`, on-action `#082F49`, muted text `#CBD5E1`, border `#334155`, error `#FCA5A5`. Contrast tests gate both themes. Persist System/Light/Dark, defaulting to System.

Use a 4-point base/8-point primary spacing rhythm and restrained radii. Buttons, inputs, cards, dialogs, loading, empty, and error states expose semantic/interaction variants. Touch targets are 48 logical pixels minimum; focus is visible; semantics are labeled; text contrast is 4.5:1 and control/large text 3:1; safe areas/reduced motion are honored. Wider screens constrain content; tablet-specific navigation is deferred.

## Local Persistence Strategy

Drift supplies typed SQLite, transactions, and migration testing. Store a fixed file under private application support. Every connection enables foreign keys, WAL journal mode, a 5-second busy timeout, and `synchronous=FULL`; initialization verifies requested pragmas and fails explicitly if required integrity settings cannot be established. File-backed tests on Android and iOS validate the choice. A future backup feature must checkpoint/close WAL before copying, but no backup workflow is included here.

### Platform data protection and backup exclusion

- Android uses the application sandbox/file-based encryption, sets `android:allowBackup=false`, disables
  legacy full backup, and supplies Android 12+ data-extraction rules that exclude all application domains
  from cloud backup and device transfer. Release configuration also disallows cleartext traffic.
- iOS stores the database, WAL/SHM sidecars, settings, and diagnostic files below Application Support,
  marks them excluded from backup, and applies `NSFileProtectionCompleteUntilFirstUserAuthentication`.
  A small documented native adapter applies and verifies the URL resource/file-protection attributes.
- Failure to establish required protection is a blocking initialization failure. No code silently falls
  back to an unprotected or backup-eligible location.
- A future approved backup/restore feature may revise these exclusions only with integrity, consent,
  migration, and constitutional review.

Schema changes are forward-only, transactional where SQLite permits, backed by committed snapshots in `drift_schemas/`, and tested from every supported prior version. Newer-than-supported schema is a blocking, non-destructive failure. Repositories own complete-operation transaction boundaries.

Only `app_settings` is created. Product, OCR, quotation, invoice, pricing, PDF, and backup tables are prohibited. Reads return immutable snapshots; writes report success after commit. See [data-model.md](./data-model.md) and [contracts/local-database.md](./contracts/local-database.md).

## Testing and Validation Strategy

- Unit: configuration, initialization transitions, error mapping, numeral boundaries, theme, repository.
- Widget: destinations, branch preservation/back, shared states, 200% text, semantics, themes, mixed RTL/LTR.
- Database: temporary/in-memory defaults/transactions plus file fixtures for upgrades, failed migration preservation, and reopen persistence.
- Integration: airplane-mode cold/warm startup, force-close/relaunch, storage failure/retry, restoration, navigation on each platform.
- Performance: record mode, OS, model, storage state, and five launches. Minimum compatibility references a Pixel 2 API 26 emulator and iPhone 8 iOS 15 simulator. Performance references a physical Pixel 4a (6 GB, arm64) and iPhone SE 2nd generation on iOS 15 or later. An unavailable reference may be replaced only by documented equivalent-or-slower hardware; record the actual models.
- Gates: formatting, analysis, generated-code freshness, tests, Android release build. iOS build/signing must run on macOS/Xcode with Apple tooling and cannot be claimed from Windows.
- Offline: airplane mode before launch, verify no network attempt for startup/navigation/settings/assets, inspect Android/iOS declarations for unnecessary networking.

Commands/evidence are in [quickstart.md](./quickstart.md) and `system-docs/testing/foundation-strategy.md`.

## Documentation Plan

- `AGENTS.md` links constitution, artifacts, architecture, setup, and tests.
- Architecture, setup, and test strategy live under `system-docs/`.
- Architectural changes require the owning document or ADR to change and a constitution check.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Flutter 3.47 standalone UI packages are new | Pin/lock; run both platforms; isolate UI imports |
| SQLite lifecycle/locking differences | File-backed platform tests; transactions; retry; preserve files |
| Arabic bidi/font/text-scale regression | Bundled fonts; mixed-text fixtures; RTL golden/semantics/device tests |
| iOS not testable on current Windows host | macOS/Xcode build and iOS device runs are implementation exit gates |
| Future dependency adds networking | Review graph/manifests/entitlements; retain offline release gate |
| Future OCR pressures startup | Load on demand behind a feature adapter; never bootstrap it |

## Complexity Tracking

No constitutional violation or unjustified abstraction is planned. Riverpod serves state and DI, codegen is limited to Drift/localization, and future feature layers are not pre-created.
