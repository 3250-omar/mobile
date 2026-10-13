# Implementation Plan: 006-dashboard-quick-actions

**Branch**: `006-dashboard-quick-actions` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/006-dashboard-quick-actions/spec.md`

## Summary

Transform the foundational placeholder `HomeScreen` into an interactive, 100% offline Arabic business dashboard. The dashboard aggregates live metrics directly from SQLite via Drift (`products`, `quotations`, `invoices`), provides one-tap Quick Actions to initiate high-frequency workflows (OCR scan, quotation creation, invoice creation, catalog view), and lists recent activity with direct drill-down navigation.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: `flutter_riverpod`, `drift`, `go_router`, `intl`  
**Storage**: Local SQLite via Drift (`AppDatabase`)  
**Testing**: `flutter test` (Unit, Widget, Repository integration)  
**Target Platform**: Android (API 26+) and iOS (15.0+)  
**Project Type**: Mobile Application  
**Performance Goals**: Dashboard metrics aggregation query < 50ms, 60fps scrolling  
**Constraints**: 100% offline (0 network requests), deterministic integer piastre calculations, Arabic RTL first, pure Dart domain layer  
**Scale/Scope**: 1 unified dashboard screen, 1 repository implementation, 1 controller, reusable presentation components  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I (100% Offline Operation)**: PASS. All data is read from local SQLite. Zero cloud or network dependencies.
- **Principle III (Local Data Ownership)**: PASS. All transactions persist in the local app database.
- **Principle IV (Data Integrity and Historical Immutability)**: PASS. Read-only queries against existing tables, no mutations or data loss.
- **Principle V (Deterministic Financial Accuracy)**: PASS. Financial totals remain strictly in integer minor units (piastres), aggregated using SQLite sums and formatted with two decimal places.
- **Principle VIII (Arabic-First Experience)**: PASS. RTL layout, Cairo / Noto Sans Arabic typography, localized Arabic number formatting.
- **Principle IX (Modular Architecture)**: PASS. Pure Dart domain with zero external dependencies; clean separation of Data, Application, and Presentation.

## Project Structure

### Documentation (this feature)

```text
specs/006-dashboard-quick-actions/
├── spec.md              # Feature specification
├── plan.md              # Implementation plan
├── research.md          # Technical decisions and research
├── data-model.md        # Domain entities and state models
├── quickstart.md        # Quickstart validation guide
├── contracts/
│   └── dashboard_repository.md # Repository contract
├── checklists/
│   └── requirements.md  # Specification checklist
└── tasks.md             # Generated tasks
```

### Source Code

```text
lib/
├── features/
│   └── home/
│       ├── domain/
│       │   ├── dashboard_metrics.dart
│       │   ├── recent_activity_item.dart
│       │   └── dashboard_repository.dart
│       ├── data/
│       │   └── drift_dashboard_repository.dart
│       ├── application/
│       │   ├── dashboard_state.dart
│       │   └── dashboard_controller.dart
│       └── presentation/
│           ├── home_screen.dart
│           └── widgets/
│               ├── dashboard_header.dart
│               ├── metric_card.dart
│               ├── quick_action_button.dart
│               └── recent_activity_tile.dart
test/
└── features/
    └── home/
        ├── drift_dashboard_repository_test.dart
        ├── dashboard_controller_test.dart
        └── home_screen_test.dart
```

**Structure Decision**: Standard feature slice under `lib/features/home/` with domain, data, application, and presentation layers adhering to architectural constraints.

## Complexity Tracking

No constitution violations. Direct SQLite aggregation and Riverpod state management.
