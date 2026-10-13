# Contract: Settings Repository

## Operations

- `load() -> AppSettings`: returns the singleton immutable snapshot; first successful use creates defaults atomically if missing.
- `watch() -> Stream<AppSettings>`: emits committed snapshots only and begins with current data.
- `setThemeMode(mode) -> AppSettings`: atomically validates, persists, increments revision, updates timestamp, then returns the committed snapshot.

Locale storage is provisioned for future localization, but no locale-change operation is user-accessible in this feature.

## Guarantees

- Default is theme `system`, locale `ar`.
- Reads and writes are offline and require no authentication.
- Unsupported values fail explicitly.
- Failed writes leave both stored and published state unchanged.
- A successful result means the change survives close/reopen.
- Data-layer exceptions map to typed application failures.

## Testing substitutes

Tests may provide an in-memory implementation with identical commit/failure semantics. Integration and migration tests must use SQLite and must not rely only on the substitute.

