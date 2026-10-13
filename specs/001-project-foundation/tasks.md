# Tasks: Flutter Application Foundation

**Feature**: `001-project-foundation`  
**Input**: Approved artifacts in `specs/001-project-foundation/`  
**Tests**: Required; write story tests before implementation.  
**Scope guard**: No OCR/camera recognition, Excel/catalog operations, matching, pricing, quotation/invoice logic, PDF, backup/restore, cloud/backend/authentication/telemetry, inventory, ERP, or payments.

## Format

Every item uses `- [ ] T### [P?] [US#?] Objective in exact path (Depends; Refs; Verify)`. `[P]` means parallel after stated dependencies. Story phases require `[US#]`; setup/foundation/final gates do not. Complete a task only when verification passes without unrelated changes.

## Phase 1 — Phase A: Flutter Project Initialization

**Purpose**: Reproducible Android/iOS workspace and quality baseline.

- [x] T001 Scaffold Flutter 3.47.5 with project `offline_quotes`, organization `com.offlinequotes`, and Android/iOS identifier `com.offlinequotes.mobile` in `pubspec.yaml`, `lib/main.dart`, `android/`, `ios/`, and `test/widget_test.dart`, removing sample-counter behavior (Depends: none; Refs: FR-001, NFR-008; Verify: Flutter/Dart are 3.47.5/3.13.4, both platforms exist, and generated identifiers match exactly).
- [x] T002 Add approved runtime/dev versions, SDK constraint, local font assets, and `generate: true` in `pubspec.yaml`, then resolve `pubspec.lock` without unapproved packages (Depends: T001; Refs: FR-004, FR-030; Verify: `flutter pub get` resolves `research.md` versions and dependencies contain no cloud/backend SDK).
- [x] T003 [P] Set Android API 26/iOS 15 minima and platform privacy policy in `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/res/xml/backup_rules.xml`, `android/app/src/main/res/xml/data_extraction_rules.xml`, `ios/Podfile`, and `ios/Runner.xcodeproj/project.pbxproj`: no unnecessary Internet/sensitive permissions, Android `allowBackup=false`, legacy/full and Android 12+ cloud/device-transfer exclusion, and cleartext disabled (Depends: T001; Refs: FR-001, FR-039, NFR-006, SC-012, SC-013; Verify: merged release manifest/resources and iOS project inspection pass).
- [x] T004 [P] Configure strict analysis/formatting and Flutter/IDE ignores in `analysis_options.yaml`, `.gitignore`, and `.metadata` without global actionable-warning suppression (Depends: T001; Refs: FR-034, SC-009; Verify: formatting/analyzer can be zero-error gates).
- [x] T005 Configure localization/Drift generation in `l10n.yaml`, `build.yaml`, and `lib/l10n/app_ar.arb`, with Arabic template/default and no Dart-embedded user copy (Depends: T002; Refs: FR-007, FR-010, FR-034; Verify: gen_l10n/build_runner outputs are deterministic).
- [x] T006 Audit packages/fonts and platform defaults for support, networking/telemetry, automatic backup, maintenance, and licenses in `system-docs/security/dependency-audit.md` and `assets/fonts/OFL.txt` (Depends: T002; Refs: Constitution XI/XIII, NFR-006; Verify: each dependency and OS backup path has an offline/privacy/license disposition).

**Checkpoint**: Workspace, platform minima, generators, and static-quality configuration are reviewable.

---

## Phase 2 — Phase B: Core Architecture (Blocking)

**Purpose**: Minimal configuration, error, diagnostics, bootstrap, and composition boundaries. Complete before all stories.

- [x] T007 [P] Write failing `APP_ENV` tests in `test/app/bootstrap/app_environment_test.dart` for development/testing/production and missing/unknown rejection without endpoint/secret fallback (Depends: T005; Refs: FR-004, NFR-001; Verify: all closed-enum branches are asserted).
- [x] T008 [P] Write failing failure-mapping tests in `test/core/errors/app_failure_test.dart` for stable codes, categories, retryability, localized keys, and redaction (Depends: T005; Refs: FR-005, FR-029; Verify: SQL, paths, stacks, and sensitive fixtures never reach user output).
- [x] T009 [P] Write failing diagnostic tests in `test/core/diagnostics/local_diagnostics_test.dart` for early buffering, three 512 KiB JSONL files, allowlists, redaction, local-only operation, sink failure, and disposal (Depends: T005; Refs: FR-033, NFR-006, NFR-009; Verify: prohibited fixtures are absent).
- [x] T010 [P] Write failing single-flight initialization tests in `test/app/bootstrap/initialization_controller_test.dart` for `notStarted`, every `initializing(stage)`, `ready(settings)`, and `failed(failure, attemptId)` (Depends: T005; Refs: FR-002, FR-006; Verify: concurrent starts share one attempt and only ready exposes shell).
- [x] T011 Implement closed compile-time environment parsing in `lib/app/bootstrap/app_environment.dart` with no URL, secret, runtime file, or weaker offline behavior (Depends: T007; Refs: FR-004; Verify: T007 passes).
- [x] T012 Implement typed failures/mappings in `lib/core/errors/app_failure.dart` and `lib/core/errors/failure_mapper.dart` (Depends: T008; Refs: FR-005, FR-029, FR-031; Verify: T008 passes and presentation sees no raw infrastructure exception).
- [x] T013 Implement logger adapter, early buffer, redaction, correlation, and rotating sink in `lib/core/diagnostics/app_logger.dart`, `local_log_sink.dart`, and `redaction.dart` (Depends: T009, T012; Refs: FR-005, FR-033; Verify: T009 passes with database or diagnostic directory unavailable).
- [x] T014 Implement initialization stages/state and injectable single-flight skeleton in `lib/app/bootstrap/initialization_state.dart` and `initialization_controller.dart` (Depends: T010, T012, T013; Refs: FR-002, FR-006, FR-031; Verify: T010 passes and retry has a new attempt ID).
- [x] T015 Define manual Riverpod composition/test overrides in `lib/app/bootstrap/providers.dart` for environment, diagnostics, initialization, database, settings, router, and theme; add no second locator/generator (Depends: T011-T014; Refs: FR-030-FR-032; Verify: adapters replace independently in tests).
- [x] T016 Implement root error capture and minimal Arabic-capable loading/failure gate in `lib/app/bootstrap/bootstrap.dart` and `bootstrap_gate.dart`, never showing shell before ready (Depends: T014, T015; Refs: FR-002, FR-005, SC-008; Verify: injected failures show safe states, not blank frames).
- [x] T017 Implement composition/disposal entry points in `lib/main.dart` and `lib/app/app.dart`, keeping UI imports out of domain code (Depends: T015, T016; Refs: FR-002, FR-030-FR-032; Verify: overridden smoke test mounts/disposes without backend/network).
- [x] T018 Add dependency-boundary tests in `test/architecture/dependency_direction_test.dart` rejecting feature-to-feature imports and Flutter/Drift/GoRouter/plugin imports from `lib/features/**/domain/` (Depends: T017; Refs: FR-030, FR-031, FR-032, NFR-007; Verify: representative forbidden fixtures fail).

**Checkpoint**: Core composition is testable; story work may begin.

---

## Phase 3 — Phase C/F: User Story 1 — Start and Use the App Offline (Priority: P1) MVP

**Goal**: Clean/subsequent offline launch safely initializes SQLite/settings and reaches Arabic Home; failure is visible and non-destructive.

**Independent Test**: In airplane mode, launch with no data and existing data; confirm Arabic Home, no authentication/network, and injected storage failure with retry/guidance and preserved files.

### Tests first

- [x] T019 [P] [US1] Write failing file-backed database/migration and protection-contract tests in `test/core/database/app_database_test.dart`, `test/core/database/fixtures/`, and `test/core/storage/platform_data_protection_test.dart` for clean creation, pragmas, rollback, reopen, older upgrade, failed-migration preservation, newer-schema refusal, idempotent backup exclusion/file protection, new sidecars/rotated logs, and protection failure (Depends: T018; Refs: FR-023-FR-025, NFR-006, SC-006, SC-012; Verify: required pragmas and protection contract are asserted).
- [x] T020 [P] [US1] Write failing repository tests in `test/features/settings/data/settings_repository_test.dart` for atomic defaults, committed-only streams, corrupt data, rollback, and reopen (Depends: T018; Refs: FR-027, FR-029; Verify: failed writes keep stored/published state unchanged).
- [x] T021 [P] [US1] Write failing locale/RTL/font/bidi/numeral tests in `test/app/localization/locale_policy_test.dart` and `numeral_policy_test.dart` (Depends: T018; Refs: FR-007-FR-011, SC-004; Verify: Western generated digits, equivalent dual-digit input, unchanged literal digits).
- [x] T022 [P] [US1] Write failing clean/subsequent/failure startup tests in `test/app/bootstrap/offline_startup_test.dart` and `integration_test/offline_startup_test.dart` (Depends: T018; Refs: US1, FR-002/003/005, SC-001/008; Verify: no network service and every initialization stage is injectable).

### Implementation

- [x] T023 [US1] Define Drift/AppSettings in `lib/core/database/tables/app_settings_table.dart` and `lib/features/settings/domain/app_settings.dart` with: `id` required/default 1/CHECK id=1; `themeMode` required/default system/only system|light|dark; `localeTag` required/default ar/valid BCP-47/only ar selectable; immutable `createdAtUtc`; transaction-updated `updatedAtUtc`; nonnegative `revision` default 0 (Depends: T019, T020; Refs: data-model, FR-027-FR-029; Verify: exactly one foundational table and no business tables).
- [x] T024 [US1] Implement private-support database opening, fixed filename, verified pragmas, forward-only migrations, schema snapshots, and platform protection in `lib/core/database/database_connection.dart`, `app_database.dart`, `migrations/migration_strategy.dart`, `lib/core/storage/platform_data_protection.dart`, `ios/Runner/LocalDataProtection.swift`, `ios/Runner/AppDelegate.swift`, and `drift_schemas/`; exclude database/WAL/SHM/settings/diagnostics from backup and apply `NSFileProtectionCompleteUntilFirstUserAuthentication` on iOS (Depends: T023; Refs: FR-023-FR-026, FR-028, NFR-006; Verify: T019 passes and protection failure blocks without reset/delete/downgrade).
- [x] T025 [US1] Implement repository port/Drift adapter in `lib/features/settings/domain/settings_repository.dart` and `lib/features/settings/data/drift_settings_repository.dart`, inserting defaults once and publishing after commit (Depends: T024; Refs: FR-026/027/029; Verify: T020 passes with substitute and file-backed Drift).
- [x] T026 [P] [US1] Complete Arabic startup/Home/error resources in `lib/l10n/app_ar.arb`, bundle Noto Sans Arabic 400/500/600/700 and Noto Sans fallback under `assets/fonts/`, and force default Arabic via `lib/app/localization/locale_policy.dart` (Depends: T021, T006; Refs: FR-007-FR-010, NFR-004; Verify: shaping works with no runtime download).
- [x] T027 [P] [US1] Implement pure numeral/bidi utilities in `lib/app/localization/numeral_policy.dart` and `bidi_text.dart` without changing stored literals (Depends: T021; Refs: FR-009, FR-011; Verify: T021 mixed-text fixtures pass).
- [x] T028 [US1] Implement localized non-business Home in `lib/features/home/presentation/home_screen.dart` with RTL directional layout and no simulated future capability (Depends: T026, T027; Refs: FR-013, FR-015; Verify: compact portrait/landscape rendering passes offline).
- [x] T029 [US1] Wire diagnostics, platform-protection apply/verify, database/migration, settings load, localization, and Home readiness in `lib/app/bootstrap/bootstrap.dart`, `initialization_controller.dart`, and `providers.dart` (Depends: T024-T028; Refs: FR-002/003/006, NFR-006, SC-001/006/012; Verify: T022 passes, protection precedes ready, and concurrent launch creates one settings row).
- [x] T030 [US1] Complete Arabic blocking/retry/diagnostic guidance without reset/delete in `lib/app/bootstrap/bootstrap_gate.dart` and `test/app/bootstrap/offline_startup_test.dart` (Depends: T029; Refs: US1 scenarios 3-4, FR-005/024, SC-008; Verify: each failure is visible, recorded, safe, and file-preserving).

**Checkpoint**: MVP proves offline Arabic startup and local-data safety.

---

## Phase 4 — Phase D: User Story 2 — Navigate an Arabic-First Shell (Priority: P1)

**Goal**: Four RTL branches, prominent Scan, secondary Settings, predictable back, and truthful placeholders.

**Independent Test**: Offline from Arabic Home, visit six destinations, verify active/RTL state, preserved stacks, Scan/Settings return, and back/unknown routes without permissions/business services.

### Tests first

- [x] T031 [P] [US2] Write failing router/shell tests in `test/app/navigation/app_router_test.dart` and `app_shell_test.dart` for unique names/paths, Home initial, RTL order, active semantics, repeated selection, four stacks, Scan/Settings return, and unknown recovery (Depends: T030; Refs: FR-012-FR-016, SC-003; Verify: rapid selection/back cases included).
- [x] T032 [P] [US2] Write failing platform cases in `integration_test/navigation_test.dart` for Android system/predictive back and iOS gesture hierarchy, conditionally executed rather than inferred (Depends: T030; Refs: FR-014, NFR-008; Verify: overlay → nested → branch root → Home → exit is recorded).

### Implementation

- [x] T033 [US2] Centralize Arabic navigation/accessibility/placeholder/unknown-route copy in `lib/l10n/app_ar.arb` (Depends: T031; Refs: FR-008/010/015/022; Verify: all six identities exist and screens hard-code no user copy).
- [x] T034 [P] [US2] Implement honest Products, Quotations, Invoices, Scan, and initial Settings placeholders in `lib/features/products/presentation/products_screen.dart`, `quotations/presentation/quotations_screen.dart`, `invoices/presentation/invoices_screen.dart`, `scan/presentation/scan_screen.dart`, and `settings/presentation/settings_screen.dart` without camera/OCR/catalog/pricing/document/permission APIs (Depends: T033; Refs: FR-015, FR-039; Verify: all five placeholders compile, identify unavailability, and perform no business action; T057 later replaces only Settings).
- [x] T035 [P] [US2] Create stable destination identities/routes in `lib/app/navigation/app_destination.dart` and `route_names.dart`, leaving localized copy to presentation (Depends: T033; Refs: FR-012-FR-014; Verify: identifiers/paths are unique and test-addressable).
- [x] T036 [US2] Implement RTL shell with four-item bottom bar, accessible prominent Scan, and Settings menu in `lib/app/navigation/app_shell.dart` (Depends: T034, T035; Refs: FR-012/014, SC-003; Verify: shell tests pass and Scan is independently keyboard/screen-reader reachable).
- [x] T037 [US2] Configure GoRouter indexed stateful shell, four navigator keys, root Scan/Settings, restoration IDs, unknown handling, and Home initial in `lib/app/navigation/app_router.dart` (Depends: T035, T036; Refs: FR-013-FR-016; Verify: route/stack tests pass offline).
- [x] T038 [US2] Implement platform-consistent back and repeated-branch pop-to-root in `lib/app/navigation/back_navigation_policy.dart` and integrate it into `app_router.dart` (Depends: T037; Refs: FR-014, US2 scenario 2; Verify: widget hierarchy passes and T032 is runnable per platform).
- [x] T039 [US2] Run/refine navigation suites in `test/app/navigation/` and `integration_test/navigation_test.dart`, documenting platform harness needs in `system-docs/testing/foundation-strategy.md` without claiming unexecuted iOS results (Depends: T038; Refs: SC-003, NFR-008; Verify: host tests pass; device cases are pass/fail/unverified).

**Checkpoint**: Six destinations are reachable, truthful, state-preserving, and offline.

---

## Phase 5 — Phase E: User Story 3 — Consistent Accessible Interface (Priority: P2)

**Goal**: Restrained Arabic-first components remain readable/operable across themes, orientations, and text scales.

**Independent Test**: Render the showcase/screens in RTL, all themes, compact/wide portrait/landscape, 100%-200% text, keyboard traversal, reduced motion, and semantics inspection.

### Tests first

- [x] T040 [P] [US3] Write failing token tests in `test/app/theme/app_theme_test.dart` for approved colors, System/Light/Dark, 4.5:1 text and 3:1 control contrast, 4/8 spacing, radii, and elevation (Depends: T030; Refs: FR-017/021, NFR-005; Verify: contrast uses actual token pairs).
- [x] T041 [P] [US3] Write failing button/field tests in `test/shared/widgets/app_button_test.dart` and `app_text_field_test.dart` for applicable enabled, pressed, focused, disabled, loading, validation, success, semantics, and 48-pixel targets (Depends: T030; Refs: FR-018-FR-021, SC-005; Verify: non-color cues asserted).
- [x] T042 [P] [US3] Write failing card/dialog/confirmation tests in `test/shared/widgets/app_card_dialog_test.dart` for focus, distinct confirm/cancel, consequence text, back cancellation, and no-op demo (Depends: T030; Refs: FR-018, FR-019, FR-021, FR-038; Verify: no business data mutation).
- [x] T043 [P] [US3] Write failing loading/empty/error tests in `test/shared/widgets/app_feedback_state_test.dart` requiring Arabic condition text, recovery action, stable layout, and no unlabeled indefinite spinner (Depends: T030; Refs: FR-018, FR-022, SC-005; Verify: semantics distinguish state/action).
- [x] T044 [P] [US3] Write failing responsive/accessibility/mixed-text tests in `test/shared/foundation_component_showcase_test.dart` for sizes/orientations, 100%-200% text, RTL focus, reduced motion, Arabic/Latin codes, and numeral sets (Depends: T030; Refs: FR-008-FR-011, FR-020/021, SC-004/011; Verify: no clipped essential action).

### Implementation

- [x] T045 [P] [US3] Implement approved semantic light/dark colors in `lib/app/theme/tokens/app_colors.dart` (Depends: T040; Refs: FR-017/021; Verify: token contrast tests pass).
- [x] T046 [P] [US3] Implement typography, spacing, radius, elevation, duration, and reduced-motion tokens in `lib/app/theme/tokens/app_typography.dart`, `app_spacing.dart`, `app_shapes.dart`, and `app_motion.dart` (Depends: T040, T026; Refs: FR-017/020, NFR-010; Verify: no unexplained raw component constants).
- [x] T047 [US3] Compose light/dark themes, font fallback, directional icon policy, control defaults, and System resolution in `lib/app/theme/app_theme.dart` (Depends: T045, T046; Refs: FR-017-FR-019; Verify: T040 passes without network fonts).
- [x] T048 [P] [US3] Implement reusable button variants/loading semantics in `lib/shared/widgets/app_button.dart` (Depends: T041, T045-T047; Refs: FR-018/019/021; Verify: all applicable state/target tests pass).
- [x] T049 [P] [US3] Implement reusable field decoration, validation/success, bidi direction, and numeral hooks in `lib/shared/widgets/app_text_field.dart` (Depends: T041, T027, T045-T047; Refs: FR-011, FR-018-FR-021; Verify: tests pass without stored-literal mutation).
- [x] T050 [P] [US3] Implement card/dialog/confirmation in `lib/shared/widgets/app_card.dart`, `app_dialog.dart`, and `app_confirmation_dialog.dart` (Depends: T042, T045-T047; Refs: FR-018/019/038; Verify: dialog tests pass and demo is non-destructive).
- [x] T051 [P] [US3] Implement loading/empty/error states in `lib/shared/widgets/app_loading_state.dart`, `app_empty_state.dart`, and `app_error_state.dart` (Depends: T043, T045-T047; Refs: FR-018/022; Verify: feedback tests pass with caller localization).
- [x] T052 [US3] Create test-only showcase in `test/support/foundation_component_showcase.dart`, apply shared design to Home/shell/placeholders, and add stable goldens under `test/goldens/` where useful (Depends: T039, T044, T048-T051; Refs: SC-004/005, NFR-010; Verify: full showcase matrix passes without decorative delay/clipping).

**Checkpoint**: Design system is reusable, Arabic-first, theme-complete, accessible, and unbranded.

---

## Phase 6 — Phase F: User Story 4 — Keep Foundational Preferences (Priority: P2)

**Goal**: System/Light/Dark persists only after commit; failed writes retain/report the prior value.

**Independent Test**: Offline, change each mode, force-close/reopen, change system appearance, and inject failure; verify persistence/rollback.

### Tests first

- [x] T053 [P] [US4] Write failing controller tests in `test/features/settings/application/settings_controller_test.dart` for load, serialized updates, commit-before-publish, revision, invalid values, and rollback (Depends: T030; Refs: FR-027/029; Verify: no success before durable commit).
- [x] T054 [P] [US4] Write failing screen tests in `test/features/settings/presentation/settings_screen_test.dart` for Arabic System/Light/Dark, selection, loading, accessible feedback, and no language/environment switch (Depends: T052; Refs: FR-017/021/027; Verify: choices are screen-reader named and ≥48 pixels).
- [x] T055 [P] [US4] Write failing restart tests in `integration_test/settings_persistence_test.dart` for all modes, system response, reopen, and failed write preserving last confirmation (Depends: T030; Refs: US4, SC-007; Verify: revision/value recorded before/after reopen).

### Implementation

- [x] T056 [US4] Implement immutable Riverpod settings controller in `lib/features/settings/application/settings_controller.dart`, using only `SettingsRepository` and serializing changes (Depends: T053, T025; Refs: FR-026/027/029; Verify: T053 passes).
- [x] T057 [US4] Replace Settings placeholder with Arabic theme controls in `lib/features/settings/presentation/settings_screen.dart`, using shared components and durable success/safe failure feedback (Depends: T054, T056; Refs: FR-017/022/027; Verify: T054 passes and no unsupported preference appears).
- [x] T058 [US4] Bind committed settings/OS appearance to application theme in `lib/app/app.dart` and `lib/app/theme/theme_controller.dart` without recreating persistence/navigation (Depends: T047, T056, T057; Refs: US4 scenario 4, SC-007; Verify: System tracks platform; overrides remain fixed).
- [x] T059 [US4] Complete file-backed restart/failure/termination coverage in `test/features/settings/` and `integration_test/settings_persistence_test.dart` (Depends: T055, T058; Refs: FR-027/029, SC-007; Verify: confirmed values survive; failed/uncommitted values do not publish).

**Checkpoint**: Transactional offline preferences are proven.

---

## Phase 7 — Phase B/G: User Story 5 — Lifecycle and Initialization Recovery (Priority: P2)

**Goal**: Resume, interruption, process recreation, and retry preserve one coherent non-destructive state.

**Independent Test**: Per platform offline, interrupt every stage, background/resume, force-close, retry repeatedly, and inject database/diagnostic failures.

### Tests first

- [x] T060 [P] [US5] Write failing lifecycle tests in `test/core/lifecycle/app_lifecycle_coordinator_test.dart` for inactive/paused/resumed/detached, bounded flush, stale reload, no migration rerun, and disposal (Depends: T059; Refs: FR-006/016; Verify: resume creates no second database/repository).
- [x] T061 [P] [US5] Write failing recovery tests in `test/app/bootstrap/initialization_recovery_test.dart` for every stage, concurrent retries, partial cleanup, stable diagnostics, unavailable log directory, and newer schema (Depends: T059; Refs: FR-005/006/024, SC-008; Verify: no reset/delete/downgrade).
- [x] T062 [P] [US5] Add failing device cases in `integration_test/lifecycle_recovery_test.dart` for background/resume, force-close, interrupted initialization/write, process loss, and repeated offline retry (Depends: T059; Refs: US5, NFR-003/008; Verify: cases run independently and record platform).

### Implementation

- [x] T063 [US5] Implement lifecycle coordination in `lib/core/lifecycle/app_lifecycle_coordinator.dart` to flush committed settings/diagnostics, safely reload, and never rely on termination for integrity (Depends: T060; Refs: FR-006/016; Verify: T060 passes).
- [x] T064 [US5] Harden retry, single-flight lock, partial cleanup, and attempt correlation in `lib/app/bootstrap/initialization_controller.dart` and `providers.dart` (Depends: T061, T063; Refs: FR-005/006; Verify: rapid concurrent retry tests pass).
- [x] T065 [US5] Implement localized recovery/blocking guidance and explicit diagnostic-reference view/copy in `lib/app/bootstrap/bootstrap_gate.dart` and `lib/core/diagnostics/diagnostic_reference_view.dart`, exposing no raw path/SQL/stack or automatic export (Depends: T061, T064; Refs: FR-005/033, SC-008; Verify: usable when DB and file diagnostics both fail).
- [x] T066 [US5] Complete host/device recovery suites in `test/app/bootstrap/`, `test/core/lifecycle/`, and `integration_test/lifecycle_recovery_test.dart`, marking unrun iOS cases unverified (Depends: T062-T065; Refs: SC-006/008, NFR-003/008; Verify: host passes and device evidence fields are complete).

**Checkpoint**: Lifecycle/retry is coherent, idempotent, diagnosable, and file-preserving.

---

## Phase 8 — Phase A/G: User Story 6 — Onboard and Validate Locally (Priority: P3)

**Goal**: New developers can set up, generate, analyze, test, run, and build with honest Apple requirements.

**Independent Test**: From clean checkout, use only docs for generation, analysis, tests, Android build, and applicable macOS/iOS build.

- [x] T067 [P] [US6] Create root onboarding in `README.md` with prerequisites, Flutter pin, setup, generation, APP_ENV, offline expectations, and links (Depends: T066; Refs: FR-036, SC-010; Verify: commands are copyable and need no runtime service/secret).
- [x] T068 [P] [US6] Update `AGENTS.md` and `system-docs/architecture/project-foundation.md` to actual tree, dependencies, bootstrap, navigation, theme, and scope (Depends: T066; Refs: FR-030-FR-032/036, Constitution XIV; Verify: documented paths exist and planned work is not called complete).
- [x] T069 [P] [US6] Document settings schema, migrations/transactions, WAL future-backup implication, diagnostics/privacy, and exclusions in `system-docs/data/local-persistence.md` and `system-docs/security/local-data-and-diagnostics.md` (Depends: T066; Refs: FR-023-FR-029/033; Verify: no business schema or backup workflow is introduced).
- [x] T070 [P] [US6] Update actual setup/build/test/Apple commands in `system-docs/development/setup.md`, `system-docs/testing/foundation-strategy.md`, and `specs/001-project-foundation/quickstart.md` (Depends: T066; Refs: FR-034-FR-037, SC-009/010; Verify: iOS requires macOS/Xcode/Apple and is never inferred from Windows).
- [x] T071 [US6] Rehearse clean-checkout onboarding and record environment, commands, outcomes, corrections, and unverified Apple steps in `system-docs/testing/evidence/developer-onboarding.md` (Depends: T067-T070; Refs: US6, SC-010; Verify: docs alone reproduce supported setup/analyze/test/Android build).

**Checkpoint**: Documentation matches the implementation and platform evidence honestly.

---

## Phase 9 — Phase G: Integration, QA, and Constitutional Exit Gates

**Purpose**: Produce acceptance evidence without expanding scope.

- [x] T072 Run format, analysis, generator freshness, unit/widget/database/architecture tests and record commands/results in `system-docs/testing/evidence/static-and-automated.md`, fixing only foundation failures in owning files (Depends: T071; Refs: FR-034, FR-035, SC-009; Verify: zero errors and no generated diff).
- [x] T073 [P] Build/validate production Android on Pixel 2 API 26 and a current target, recording artifact, OS/device, install/start, permissions, and tests in `system-docs/testing/evidence/android-validation.md` (Depends: T072; Refs: FR-001/035, SC-001, NFR-008; Verify: release/device acceptance passes independently).
- [ ] T074 [P] On macOS/Xcode, build iOS release and validate iPhone 8 iOS 15 simulator plus physical iPhone SE 2nd generation or approved equivalent-or-slower, recording signing/device results in `system-docs/testing/evidence/ios-validation.md`; leave unchecked/unverified without Apple environment (Depends: T072; Refs: FR-001/035/037, NFR-008; Verify: no Windows/Android inference).
- [x] T075 [P] Execute clean/subsequent airplane-mode journeys on Android/iOS, monitor connections, inspect merged Android backup/data-extraction/cleartext policy, and read effective iOS backup-exclusion/file-protection attributes for database/sidecars/settings/logs; record zero remote attempts/prompts and protection results in `system-docs/testing/evidence/offline-privacy-validation.md` (Depends: T072; Refs: FR-003/033/039, NFR-006, SC-012/013; Verify: journeys work offline and no protected file is backup-eligible).
- [x] T076 [P] Run 100 startup/lifecycle/retry/migration cycles per platform via `integration_test/reliability_cycles_test.dart` and record counts in `system-docs/testing/evidence/reliability-validation.md` (Depends: T072; Refs: NFR-003, SC-006; Verify: zero crash, duplicate, corruption, silent failure).
- [x] T077 [P] Measure at least 20 cold/20 warm production-like launches plus navigation on reference devices via `integration_test/startup_performance_test.dart`, recording samples/percentiles in `system-docs/testing/evidence/performance-validation.md` (Depends: T072; Refs: NFR-002, SC-002; Verify: ≥95% warm ≤2 s and cold ≤4 s; separately report plan's stricter 3 s cold and ≤100 ms navigation targets).
- [x] T078 [P] Execute Arabic/RTL/bidi/numeral/font/truncation/orientation/text-scale and TalkBack/VoiceOver matrix per platform, recording results in `system-docs/testing/evidence/arabic-accessibility-validation.md` (Depends: T072; Refs: NFR-004, NFR-005, SC-004, SC-011; Verify: journeys/states pass without color-only or inaccessible action).
- [x] T079 Audit dependencies, source, schema, Android/iOS backup and file-protection configuration, manifests/entitlements, and routes for prohibited network/telemetry/permissions/business tables/future features/speculative modules in `system-docs/testing/evidence/constitution-and-scope-audit.md` (Depends: T073-T078; Refs: Constitution I-XV, Out of Scope; Verify: no violation or feature remains blocked).
- [x] T080 Reconcile evidence/links in `specs/001-project-foundation/quickstart.md`, `system-docs/README.md`, and `system-docs/testing/foundation-strategy.md`, accurately marking incomplete platform gates (Depends: T079; Refs: FR-036, SC-001-SC-013; Verify: every FR/NFR/SC maps to evidence and local links resolve).

**Final checkpoint**: Android/iOS gates are independently evidenced. Unavailable iOS execution leaves applicable tasks and acceptance incomplete—not inferred.

---

## Dependencies and Execution Order

```text
Phase 1 Setup
  -> Phase 2 Core Foundation
      -> US1 Offline Startup (MVP)
          -> US2 Navigation
          -> US3 Design System
          -> US4 Settings (also needs US3 components)
              -> US5 Lifecycle Recovery
                  -> US6 Onboarding
                      -> Final QA/platform gates
```

- Phase 1 blocks Phase 2; Phase 2 blocks every story.
- US1 creates SQLite/settings/localization and blocks shell, settings UI, and lifecycle work.
- US2 and early US3 work may overlap after US1; T052 waits for US2 because it applies design to the shell.
- US4 requires the US1 repository and US3 theme/components. US5 requires completed navigation/settings lifecycle surfaces.
- US6 documents actual code, so it follows US5. Final QA follows intended stories/documentation.

### Story dependencies and independent outcomes

| Story | Depends on | Independently demonstrable outcome |
|---|---|---|
| US1 (P1) | Phases 1-2 | Offline Arabic Home after safe initialization and non-destructive failure UI |
| US2 (P1) | US1 | Six truthful destinations with RTL state-preserving navigation |
| US3 (P2) | US1; shell application waits for US2 | Accessible component showcase across themes/layouts |
| US4 (P2) | US1, US3 | Durable theme choice with rollback on write failure |
| US5 (P2) | US1, US2, US4 | Safe resume/interruption/retry and coherent recovery |
| US6 (P3) | US1-US5 | Reproducible setup/tests/builds and platform-honest onboarding |

### Critical path

`T001 -> T002 -> T005 -> T010 -> T014 -> T015 -> T017 -> T018 -> T019-T022 -> T023 -> T024 -> T025 -> T029 -> T030 -> T031 -> T033 -> T036 -> T037 -> T038 -> T040-T044 -> T045-T052 -> T053-T055 -> T056-T059 -> T060-T062 -> T063-T066 -> T067-T071 -> T072 -> T073-T078 -> T079 -> T080`

## Parallel Opportunities

- After T001: T003/T004 parallel while T002 owns `pubspec.yaml`.
- After T005: T007-T010 parallel; converge at T014-T017.
- US1: T019-T022 parallel; then database T023-T025 sequential while T026/T027 run parallel; converge at T029.
- US2: T031/T032 parallel; T034/T035 parallel after centralized localization T033.
- US3: T040-T044 parallel; T045/T046 and later T048-T051 parallel by file; converge T052.
- US4: T053-T055 parallel. US5: T060-T062 parallel. US6: T067-T070 parallel.
- Final QA: T073-T078 parallel after T072, subject to devices/macOS.

### Parallel example: US1

```text
T019 database/migration tests
T020 settings repository tests
T021 localization/numeral tests
T022 offline bootstrap tests
```

### Parallel example: US3

```text
T040 token/theme tests
T041 button/field tests
T042 card/dialog tests
T043 feedback-state tests
T044 responsive/accessibility tests
```

## Implementation Strategy

### MVP first

1. Complete Phases 1-2.
2. Complete US1 through T030.
3. Stop and validate independent airplane-mode startup/retry criteria.
4. Do not call later placeholders, settings UI, or platform QA complete.

### Incremental delivery

US1 proves startup/data safety; US2 adds navigation; US3 adds accessible UI; US4 proves durable preferences; US5 proves lifecycle recovery; US6 makes work reproducible; final QA supplies independent Android/iOS/offline/accessibility/reliability/performance evidence.

## Requirement Coverage Notes

- FR-001–FR-039, NFR-001–NFR-010, SC-001–SC-013, and US1-US6 each have explicit task references.
- T077 reports both the specification's 4-second cold acceptance gate and the plan's stricter 3-second target; neither is silently relaxed.
- The plan's 48-pixel target satisfies the stricter implementation convention above FR-021's 44-pixel minimum.
- iOS tasks remain required and can only be unverified—not passed—without Apple tooling.
- No task creates future business tables or implements an excluded capability.
