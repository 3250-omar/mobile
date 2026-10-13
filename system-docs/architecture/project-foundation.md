# Project Foundation Architecture

**Status**: Implemented and verified under feature `001-project-foundation`.

---

## 1. Shape and Dependency Direction

The codebase adheres strictly to a feature-first, layered architecture:
- `lib/app/`: Owns root application lifecycle, bootstrap pipeline, Riverpod dependency injection (`providers.dart`), navigation configuration, theme tokens, and Arabic numeral/bidi policies.
- `lib/core/`: Encapsulates cross-cutting infrastructure: Drift SQLite database, schema migrations, structured local diagnostic logging, failure abstraction/mapping, platform storage protection, and app lifecycle hooks.
- `lib/features/`: Contains domain-driven feature slices:
  - `features/settings/`: Complete vertical slice (`domain`, `data`, `application`, `presentation`) managing persistent application preferences (`AppSettings`).
  - `features/home/`: Presentation overview displaying truthful offline readiness.
  - `features/products/`, `features/quotations/`, `features/invoices/`, `features/scan/`: Honest, truthful placeholder screens indicating future capabilities without invoking unbundled APIs or network services.
- `lib/shared/`: Proven, accessible reusable components (`AppButton`, `AppTextField`, `AppCard`, `AppConfirmationDialog`, `AppLoadingState`, `AppEmptyState`, `AppErrorState`).

### Boundary Constraints
- `domain/` contains zero imports of Flutter, Drift, Riverpod, or third-party packages.
- Features never import other features (enforced by `test/architecture/dependency_direction_test.dart`).
- State management and DI are composed manually via Riverpod in `lib/app/bootstrap/providers.dart`. No secondary service locator (GetIt) or code generation annotations (`@riverpod`) are used.

---

## 2. Startup and Bootstrap Pipeline

Startup execution is managed by `InitializationController` through a sequential single-flight state machine:
1. **Configuration**: Verifies closed compile-time `AppEnvironment` (`development`, `testing`, `production`).
2. **Diagnostics**: Initializes `AppLogger` and attaches `LocalLogSink` to flush early in-memory events.
3. **Storage Protection**: Ensures files reside within private app sandbox; applies iOS backup exclusion and verification.
4. **Database & Migrations**: Opens SQLite with WAL mode, foreign keys, and executes forward migrations. Refuses newer schema versions without destructive reset.
5. **Settings Loading**: Reads foundational `app_settings` (defaulting atomically to revision 0 if absent).
6. **Composition**: Emits `ready(settings)` to transition `BootstrapGate` and display `OfflineQuotesApp`.

If any stage fails, `BootstrapGate` blocks navigation to prevent partial state corruption, presenting localized error guidance and a diagnostic reference copy utility.

---

## 3. Navigation & Shell Architecture

- Implemented via `go_router` using an indexed `StatefulShellRoute`.
- Provides four primary RTL navigation branches:
  1. **الرئيسية** (Home) — Initial location.
  2. **المنتجات** (Products) — Independent navigation stack.
  3. **عروض الأسعار** (Quotations) — Independent navigation stack.
  4. **الفواتير** (Invoices) — Independent navigation stack.
- Two root pushed destinations:
  - **المسح الضوئي** (Scan) — Prominent center FloatingActionButton on the bottom bar.
  - **الإعدادات** (Settings) — Action icon in the Home AppBar.
- Platform back navigation policy preserves tab state and pops to Home before exiting.

---

## 4. Local Persistence & Data Safety

- **Engine**: Drift with SQLite over `sqlite3_flutter_libs`.
- **Database Schema**: Version 1 schema defines `app_settings` with singleton constraint (`CHECK id = 1`), `theme_mode` (`system`, `light`, `dark`), and `locale_tag` (`ar`).
- **Integrity**: Full WAL pragma configuration, synchronized writes, and forward-only schema snapshots (`drift_schemas/`).
- **Platform Protection**:
  - Android: `android:allowBackup="false"`, `backup_rules.xml`, and `data_extraction_rules.xml` exclude all databases, shared preferences, and logs from cloud backups or device transfers.
  - iOS: Native Swift plugin sets `isExcludedFromBackupKey` and `NSFileProtectionCompleteUntilFirstUserAuthentication` on all database, WAL, SHM, and log files.

---

## 5. Design System & Arabic-First RTL

- Default language is forced to Arabic (`ar`) with RTL text directionality.
- Font hierarchy uses locally bundled Noto Sans Arabic (weights 400, 500, 600, 700) with local Noto Sans Latin fallback.
- WCAG AA contrast compliance: minimum 4.5:1 for body copy and 3.0:1 for interactive controls across both Light and Dark themes.
- Touch targets strictly enforce a minimum dimension of 48×48 logical pixels.
- Dynamic text scaling verified up to 200% without clipped essential controls.
