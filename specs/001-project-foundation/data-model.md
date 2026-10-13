# Foundational Data Model

**Feature**: `001-project-foundation`  
**Scope**: Application initialization and persisted settings only. This is a logical design, not a production migration.

## AppSettings

A singleton aggregate containing only settings needed by the foundation.

| Field | Type | Required | Default | Rules |
|---|---|---:|---|---|
| `id` | integer | yes | `1` | Primary key; CHECK `id = 1` |
| `themeMode` | text enum | yes | `system` | `system`, `light`, or `dark` only |
| `localeTag` | text | yes | `ar` | Valid BCP-47 tag; only `ar` may be selected in this feature |
| `createdAtUtc` | UTC instant | yes | transaction time | Immutable after insert |
| `updatedAtUtc` | UTC instant | yes | transaction time | Updated in the same transaction as changes |
| `revision` | nonnegative integer | yes | `0` | Increments once per committed logical update |

### Invariants

- Exactly one row exists after successful initialization.
- Missing storage is initialized with deterministic defaults in one transaction.
- Invalid enum/tag data is a visible initialization failure, not silently coerced.
- A write publishes new in-memory state only after the transaction commits.
- Reading the aggregate has no network or authentication prerequisite.
- Literal application data is never numeral-transformed by this aggregate.

### State transitions

```text
missing --initialize transaction--> system/ar/revision 0
valid --change theme transaction--> selected theme/ar/revision + 1
valid --future locale migration--> selected theme/new locale/revision + 1
invalid or unavailable --read--> blocking/retryable failure (files preserved)
```

## ApplicationInitializationState

An in-memory state model, not a database table.

| Variant | Data | Allowed next states |
|---|---|---|
| `notStarted` | none | `initializing` |
| `initializing` | stage, attempt ID, start time | next `initializing`, `ready`, `failed` |
| `ready` | immutable `AppSettings` snapshot | `ready` (settings update) |
| `failed` | `AppFailure`, attempt ID, diagnostic reference | `initializing` on explicit retry |

Stages are configuration, diagnostics, storage path, database open, migration, settings load, and application composition. There is no partially usable shell state.

## AppFailure

An application-boundary error value, not persisted business data.

| Field | Purpose |
|---|---|
| `code` | Stable nonlocalized diagnostic/test code |
| `messageKey` | Localized, user-safe Arabic message lookup |
| `category` | Configuration, storage, migration, validation, navigation, or unexpected |
| `retryable` | Whether Retry can reasonably rerun the operation |
| `diagnosticReference` | Opaque local correlation value; never raw sensitive content |
| `causeForLogs` | Redacted technical context available only to local diagnostics |

## DiagnosticEvent

A bounded local JSONL record outside SQLite so database failures remain diagnosable.

| Field | Rules |
|---|---|
| `timestampUtc` | ISO-8601 UTC |
| `level` | debug/info/warning/error; debug may be disabled in production |
| `eventCode` | Stable allowlisted code |
| `attemptId` | Optional bootstrap correlation ID |
| `attributes` | Allowlisted primitive metadata only |

Names, customer details, business details, OCR content, catalog rows, document text, tokens, and unrestricted exception messages are prohibited. Retain at most three rotating 512 KiB files; diagnostics are never sent automatically.

## Relationships

- A successful `ApplicationInitializationState.ready` contains the current `AppSettings` snapshot.
- A failure may reference one or more `DiagnosticEvent` records by opaque attempt/reference ID.
- Diagnostic files do not depend on the database.

## Schema evolution

- Drift schema version is monotonic and forward-only.
- Generated schema snapshots are committed and migrations are tested from every retained version.
- Migration executes transactionally where SQLite permits and preserves the original file on failure.
- A database newer than the application supports is blocked without downgrade/reset.
- This feature defines no product, OCR, quotation, invoice, price, PDF, or backup entity.
