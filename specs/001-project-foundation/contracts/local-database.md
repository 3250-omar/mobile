# Contract: Local Database

## Responsibilities

- Resolve/open the private application-support SQLite file.
- Enable and verify foreign keys, WAL journal mode, a 5-second busy timeout, and `synchronous=FULL` for every connection.
- Report current/supported schema versions.
- Apply forward migrations transactionally where supported.
- Expose transaction execution to repositories.
- Close resources explicitly in tests and controlled teardown.

## Guarantees

- Opening and migration require no network.
- Initialization never deletes, resets, or downgrades a database after failure.
- A newer-than-supported schema produces a typed blocking failure.
- A transaction either commits all writes or exposes none.
- Migration fixtures verify every supported prior version and preserve data.
- Raw database exceptions do not cross into presentation.

## Path and lifecycle

Use a fixed application-owned filename beneath the OS private application-support directory. Do not use public/shared storage. Keep one application-scoped connection; do not depend on termination callbacks for integrity.

Before the database is considered ready, the platform-protection adapter MUST confirm:

- Android application data is excluded from cloud backup and device transfer by manifest and data-extraction
  policy, remains in the encrypted application sandbox, and disallows cleartext application traffic.
- iOS database, WAL/SHM sidecars, settings, and diagnostic paths are excluded from backup and use
  `NSFileProtectionCompleteUntilFirstUserAuthentication`.
- Any inability to apply or verify required protection returns a typed blocking failure without relocating,
  deleting, or recreating data.

A future backup implementation must checkpoint/close WAL before copying the database and sidecar state. That workflow is explicitly outside this feature.

## Out of scope

No product, OCR, catalog, quotation, invoice, pricing, PDF, inventory, or backup schema is defined.
