# Developer and AI-Agent Entry Point

## Required Reading

Before changing the project, read:

1. [Project Constitution](.specify/memory/constitution.md)
2. The active feature specification and its Clarifications section
3. The active feature plan, research, data model, contracts, and quickstart
4. [System Documentation](system-docs/README.md)
5. [Foundation Architecture](system-docs/architecture/project-foundation.md)

For the project foundation, reference [specs/001-project-foundation/plan.md](specs/001-project-foundation/plan.md) and [specs/001-project-foundation/tasks.md](specs/001-project-foundation/tasks.md).

---

## Actual Repository Tree & Layer Boundaries

```text
lib/
├── app/
│   ├── app.dart                   # Root OfflineQuotesApp with GoRouter, forced Arabic locale, and theme
│   ├── bootstrap/
│   │   ├── app_environment.dart   # Closed compile-time APP_ENV parser (development/testing/production)
│   │   ├── bootstrap.dart         # Async bootstrap orchestrator sequence
│   │   ├── bootstrap_gate.dart    # Bootstrap gate preventing shell exposure before ready
│   │   ├── initialization_controller.dart # Single-flight state machine
│   │   ├── initialization_state.dart      # Immutable initialization states and attempt IDs
│   │   └── providers.dart         # Manual Riverpod composition without code-gen or service locators
│   ├── navigation/
│   │   ├── app_destination.dart   # Navigation branch enumeration
│   │   ├── app_router.dart        # StatefulShellRoute with 4 branches + 2 root push routes
│   │   ├── app_shell.dart         # RTL Scaffold with 4-item NavigationBar and prominent Scan FAB
│   │   ├── back_navigation_policy.dart # Platform-consistent back stack pops
│   │   └── route_names.dart       # Stable route paths and names
│   ├── localization/
│   │   ├── bidi_text.dart         # LTR segment isolation (wrapLtr) in RTL Arabic context
│   │   ├── locale_policy.dart     # Arabic default policy and fallback enforcement
│   │   └── numeral_policy.dart    # Dual numeral normalization (Eastern to Western Arabic digits)
│   └── theme/
│       ├── app_theme.dart         # Material 3 light/dark ThemeData compositions
│       ├── theme_controller.dart  # Riverpod appThemeModeProvider mapping settings to ThemeMode
│       └── tokens/                # Semantic tokens: app_colors, app_spacing, app_shapes, app_typography, app_motion
├── core/
│   ├── database/
│   │   ├── app_database.dart      # Drift database instance with verified pragmas (WAL, foreign_keys)
│   │   ├── database_connection.dart # Private application storage connection
│   │   ├── migrations/            # Forward-only migration strategy and integrity verification
│   │   └── tables/
│   │       └── app_settings_table.dart # Foundational app_settings table (singleton id = 1)
│   ├── diagnostics/
│   │   ├── app_logger.dart        # Diagnostic logger with early in-memory buffer
│   │   ├── diagnostic_event.dart  # Structured JSONL event schema
│   │   ├── diagnostic_reference_view.dart # Safe user-facing diagnostic reference viewer
│   │   ├── local_log_sink.dart    # 3x512 KiB rotating file log sink
│   │   └── redaction.dart         # Strict allowlist/blocklist attribute scrubber
│   ├── errors/
│   │   ├── app_failure.dart       # Strongly typed domain failure representation
│   │   └── failure_mapper.dart    # Infrastructure-to-domain exception converter
│   ├── lifecycle/
│   │   └── app_lifecycle_coordinator.dart # Inactive/paused/resumed flush and reload coordinator
│   └── storage/
│       └── platform_data_protection.dart  # Android sandbox check & iOS MethodChannel backup exclusion
├── features/
│   ├── home/presentation/        # Arabic non-business overview screen
│   ├── products/presentation/    # Truthful unavailable products placeholder
│   ├── quotations/presentation/  # Truthful unavailable quotations placeholder
│   ├── invoices/presentation/    # Truthful unavailable invoices placeholder
│   ├── scan/presentation/        # Truthful unavailable OCR/scan placeholder
│   └── settings/                 # Fully functional persistent theme preferences
│       ├── domain/               # AppSettings entity, SettingsRepository contract
│       ├── data/                 # DriftSettingsRepository implementation
│       ├── application/          # SettingsController (StateNotifier with transactional rollback)
│       └── presentation/         # SettingsScreen with Arabic System/Light/Dark radio tiles
├── shared/widgets/               # Reusable UI widgets (AppButton, AppTextField, AppCard, AppLoadingState, etc.)
└── l10n/                         # Arabic ARB template and generated localization delegates
```

---

## Non-Negotiable Working Rules

1. **100% Offline Core**: Strictly zero external network traffic, telemetry, cloud synchronization, or remote authentication.
2. **Arabic-First RTL**: Arabic is the first-launch default language with bundled Noto Sans Arabic fonts.
3. **Platform Integrity**:
   - Android: Target API 26 minimum. `allowBackup=false`, cloud transfer excluded in `backup_rules.xml` and `data_extraction_rules.xml`.
   - iOS: Minimum iOS 15.0. Backup exclusion and `NSFileProtectionCompleteUntilFirstUserAuthentication`.
   - Never claim iOS test or build success without running in a genuine Apple macOS environment.
4. **Data Ownership & Persistence**:
   - Drift over SQLite with forward-only migrations.
   - Id = 1 singleton table for `app_settings`.
   - Never delete, wipe, or auto-reset data upon initialization or migration failure.
5. **Architectural Separation**:
   - `features/**/domain` has zero dependencies on Flutter, Drift, or external packages.
   - Features do not import other features.
   - Riverpod manually handles DI in `lib/app/bootstrap/providers.dart`. No reflection, mirrors, or secondary locators.
6. **Scope Boundary**:
   - OCR/camera, catalog Excel parsing, pricing, quotations/invoices business calculations, and PDF generation are strictly deferred to future features.

---

## Quality Gates & Verification

```sh
# Static Analysis & Freshness
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze lib test
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- lib drift_schemas

# Automated Test Suite (85 tests)
flutter test
```
