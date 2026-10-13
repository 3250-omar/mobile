# Technical Research: Dashboard & Quick Actions

## Decision 1: Metrics Aggregation Strategy

- **Decision**: Perform all aggregation in SQLite using indexed `COUNT(*)` and `SUM()` queries via Drift instead of fetching all records into Dart memory.
- **Rationale**: The catalog can hold thousands of plumbing items, and a merchant may accumulate hundreds of quotations and invoices over time. In-database aggregation takes < 5ms and uses almost zero RAM, guaranteeing instant dashboard loads even on low-end devices.
- **Alternatives Considered**:
  - *Fetching all lists and computing in Dart*: Inefficient and causes UI stutter / memory bloat on large datasets.
  - *Maintaining running counter table*: Increases write complexity, risk of desynchronization on crash or rollback, and requires triggers. Aggregation queries on SQLite are fast enough ($< 5\text{ ms}$).

## Decision 2: Stream-Based Reactive Updates

- **Decision**: Provide both a one-shot `getMetrics()` and a reactive stream `watchMetrics()` and `watchRecentActivities()` using Drift table update watchers.
- **Rationale**: When an invoice is created, marked paid, or catalog imported, Drift automatically emits table updates for watched queries. The dashboard reflects the latest figures instantly without needing manual refresh buttons or complex event buses.
- **Alternatives Considered**:
  - *Polling timer*: Wastes CPU cycles and battery.
  - *Manual pull-to-refresh only*: Degrades user experience; users expect to return from creating an invoice to find their dashboard already updated.

## Decision 3: Recent Activity Union Strategy

- **Decision**: Query the 5 most recent quotations (sorted by `updatedAt DESC LIMIT 5`) and 5 most recent invoices (sorted by `updatedAt DESC LIMIT 5`), merge and sort in memory by timestamp, then take the top 5.
- **Rationale**: The number of items to merge is trivial ($5 + 5 = 10$), avoiding complex cross-table SQLite union queries that would complicate mapping or type safety in Drift. It gives clean strongly typed domain objects (`RecentActivityItem`).
- **Alternatives Considered**:
  - *Complex SQL `UNION ALL`*: Requires raw custom SQL with type casting and is harder to maintain and test.

## Decision 4: Financial Formatting & Bidi Isolation

- **Decision**: Strictly maintain money in minor units (integer piastres) across domain models. Format for display using `NumberFormat.currency(locale: 'ar_EG', symbol: 'ج.م', decimalDigits: 2)` with Arabic numeral normalization and LTR directional wrapping for currency numbers to prevent bidi flipping.
- **Rationale**: Adheres directly to Constitution Principle V (Deterministic Financial Accuracy) and Principle VIII (Arabic-First Experience). Floating point is strictly forbidden.
- **Alternatives Considered**:
  - *Double floats*: Rejected due to IEEE 754 precision loss.
