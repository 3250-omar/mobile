# Tasks: 006-dashboard-quick-actions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Directory structure and feature module initialization

- [x] T001 Create home feature module directories in `lib/features/home/domain/`, `lib/features/home/data/`, `lib/features/home/application/`, and `lib/features/home/presentation/widgets/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain entities, contracts, and state models that MUST be complete before user stories

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 [P] Implement `DashboardMetrics` pure Dart domain entity with integer piastre fields in `lib/features/home/domain/dashboard_metrics.dart`
- [x] T003 [P] Implement `RecentActivityItem` pure Dart domain entity and `ActivityType` enum in `lib/features/home/domain/recent_activity_item.dart`
- [x] T004 Implement `DashboardRepository` abstract interface contract in `lib/features/home/domain/dashboard_repository.dart`
- [x] T005 [P] Implement `DashboardState` application model in `lib/features/home/application/dashboard_state.dart`

**Checkpoint**: Foundation ready - domain entities and repository contracts defined.

---

## Phase 3: User Story 1 - Business & Catalog Metrics Overview (Priority: P1) 🎯 MVP

**Goal**: Display live aggregated business counts and sums (products, quotations, receivables, revenue) computed locally in SQLite via Drift.

**Independent Test**: Provide products, quotations, and invoices in SQLite and verify that `DriftDashboardRepository` and `HomeScreen` compute and display exact figures without network.

### Tests for User Story 1

- [x] T006 [P] [US1] Unit and integration tests for metrics aggregation queries in `test/features/home/drift_dashboard_repository_test.dart`

### Implementation for User Story 1

- [x] T007 [US1] Implement `DriftDashboardRepository` with SQLite `COUNT` and `SUM` queries and reactive streams in `lib/features/home/data/drift_dashboard_repository.dart`
- [x] T008 [US1] Implement `DashboardController` StateNotifier for metric loading and stream subscriptions in `lib/features/home/application/dashboard_controller.dart`
- [x] T009 [P] [US1] Register `dashboardRepositoryProvider` and `dashboardControllerProvider` in `lib/app/bootstrap/providers.dart`
- [x] T010 [P] [US1] Implement `MetricCard` widget with Arabic RTL styling and minor units currency formatting in `lib/features/home/presentation/widgets/metric_card.dart`
- [x] T011 [US1] Update `HomeScreen` to render live metric cards with reactive state in `lib/features/home/presentation/home_screen.dart`

**Checkpoint**: User Story 1 fully functional and testable independently.

---

## Phase 4: User Story 2 - Prominent Quick Action Shortcuts (Priority: P1)

**Goal**: Provide direct one-tap shortcuts to high-frequency actions: Scan (`/scan`), New Quotation (`/quotations/new`), New Invoice (`/invoices/new`), Catalog (`/products`).

**Independent Test**: Tapping each button immediately invokes GoRouter navigation to the target path.

### Tests for User Story 2

- [x] T012 [P] [US2] Widget test verifying quick action buttons trigger navigation in `test/features/home/home_screen_test.dart`

### Implementation for User Story 2

- [x] T013 [P] [US2] Implement `QuickActionButton` widget with $\ge 48$dp touch targets and Arabic labels in `lib/features/home/presentation/widgets/quick_action_button.dart`
- [x] T014 [US2] Integrate Quick Action row in `HomeScreen` for `/scan`, `/quotations/new`, `/invoices/new`, and `/products` in `lib/features/home/presentation/home_screen.dart`

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - Recent Activity Stream (Priority: P2)

**Goal**: Display the latest 5 commercial documents with status badges, customer names, and formatted amounts, supporting direct drill-down navigation.

**Independent Test**: Insert recent quotations and invoices, verify recent activity shows the merged top 5 chronologically, and tapping navigates to the document.

### Tests for User Story 3

- [x] T015 [P] [US3] Unit tests for recent activity queries and sorting in `test/features/home/drift_dashboard_repository_test.dart`

### Implementation for User Story 3

- [x] T016 [US3] Implement `getRecentActivities` and `watchRecentActivities` in `lib/features/home/data/drift_dashboard_repository.dart`
- [x] T017 [US3] Update `DashboardController` to load and observe recent activities in `lib/features/home/application/dashboard_controller.dart`
- [x] T018 [P] [US3] Implement `RecentActivityTile` widget with status badge and Arabic currency formatting in `lib/features/home/presentation/widgets/recent_activity_tile.dart`
- [x] T019 [US3] Integrate recent activity list and empty state in `HomeScreen` in `lib/features/home/presentation/home_screen.dart`

**Checkpoint**: All three primary user stories functional and independently testable.

---

## Phase 6: User Story 4 - Offline Status & Shop Header (Priority: P3)

**Goal**: Present shop name from `app_settings` and explicit 100% offline indicator on the dashboard header.

**Independent Test**: Verify shop name from settings displays in header, with fallback to localized default if unset.

### Implementation for User Story 4

- [x] T020 [P] [US4] Implement `DashboardHeader` widget observing shop settings and displaying offline badge in `lib/features/home/presentation/widgets/dashboard_header.dart`
- [x] T021 [US4] Embed `DashboardHeader` at the top of `HomeScreen` in `lib/features/home/presentation/home_screen.dart`

---

## Phase 7: Polish & Quality Gates

**Purpose**: Format code, analyze lints, run entire test suite, and verify architecture compliance

- [x] T022 Run `dart format --output=none --set-exit-if-changed lib test`
- [x] T023 Run `flutter analyze lib test`
- [x] T024 Run full test suite `flutter test`
- [x] T025 Verify architectural boundary compliance in `test/architecture/dependency_direction_test.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 completion - BLOCKS all user stories.
- **User Story 1 (Phase 3)**: Depends on Phase 2. MVP core.
- **User Story 2 (Phase 4)**: Depends on Phase 2. Independent of US1.
- **User Story 3 (Phase 5)**: Depends on Phase 2.
- **User Story 4 (Phase 6)**: Depends on Phase 2.
- **Polish (Phase 7)**: Depends on all user story phases completion.

### Parallel Opportunities

- T002, T003, T005 can be implemented in parallel.
- T010, T013, T018, T020 can be created in parallel as independent widgets.
