# Contract: Diagnostics and Errors

## Error boundary

Infrastructure exceptions are mapped to an `AppFailure` before reaching UI. User-visible content is localized Arabic and must not contain stack traces, database paths, SQL, or sensitive values.

## Local diagnostics

- Capture startup stage, stable event code, UTC time, level, attempt ID, and allowlisted technical attributes.
- Persist to bounded rotating files independent of SQLite.
- Buffer early events until the file sink is available.
- Redact/omit business names, customer data, OCR text, catalog content, document data, secrets, and unrestricted free text.
- Perform no automatic upload, analytics, crash reporting, or network transmission.
- Viewing/copying requires an explicit user action.

## Failure behavior

- Retryable failures expose Retry and prevent duplicate concurrent attempts.
- Nonretryable configuration/newer-schema failures explain the next safe action.
- No error path silently proceeds with partial state or deletes local data.
- If the file sink also fails, retain a bounded in-memory reference for the current session and state that diagnostics could not be persisted.

## Verification

Tests inject representative exceptions, assert stable mappings/localized output, scan diagnostic output for prohibited fixtures, exercise rotation, and run with unavailable database and unavailable diagnostic directory independently.
