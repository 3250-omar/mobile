# Contract: Platform Data Protection

## Purpose

Prevent foundational local data from being transmitted or restored through automatic OS backup before a
separately approved backup/restore feature exists, while using native encrypted private storage.

## Protected scope

- SQLite database plus WAL and SHM sidecars.
- Persisted settings.
- Local diagnostic files and their directory.

## Operations

- `apply(paths)`: apply platform backup-exclusion and file-protection policy to every existing path and its
  containing application-owned directory.
- `verify(paths)`: return success only when every required path has the effective platform policy.
- New database sidecars or rotated diagnostic files inherit directory protection and are verified after creation.

## Guarantees

- No protected path is eligible for Android cloud backup/device transfer or iOS backup.
- Android uses only private sandbox paths, disables cleartext application traffic, and declares explicit
  backup/data-extraction exclusions.
- iOS uses `NSFileProtectionCompleteUntilFirstUserAuthentication` and the URL excluded-from-backup flag.
- Apply/verify failure maps to a typed blocking initialization failure.
- The adapter performs no upload, export, restore, encryption-key management, deletion, or reset.

## Verification

- Unit/contract tests cover success, partial failure, new sidecar/log files, and idempotent reapplication.
- Android acceptance inspects the merged release manifest and data-extraction resources.
- iOS acceptance reads effective file attributes on simulator and physical device.
