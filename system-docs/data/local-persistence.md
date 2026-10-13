# Local Persistence & Data Safety Architecture

**Status**: Implemented for Feature `001-project-foundation`.

---

## 1. Engine & Storage Placement

The persistence layer uses [Drift](https://drift.simonbinder.eu/) with SQLite via `sqlite3_flutter_libs`.
All database files reside exclusively inside the platform's private application support directory:
- **Android**: `/data/user/0/com.offlinequotes.mobile/databases/app_database.sqlite` (or `app_flutter/`)
- **iOS**: `Library/Application Support/app_database.sqlite`

Storage in public directories (e.g. `/sdcard`, `Downloads`) is strictly prohibited and asserted at initialization.

---

## 2. Foundational Database Schema (Version 1)

The foundation defines exactly one table, `app_settings`, managing device-local user preferences:

```sql
CREATE TABLE app_settings (
  id INTEGER NOT NULL PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  theme_mode TEXT NOT NULL DEFAULT 'system' CHECK (theme_mode IN ('system', 'light', 'dark')),
  locale_tag TEXT NOT NULL DEFAULT 'ar' CHECK (locale_tag = 'ar'),
  created_at_utc INTEGER NOT NULL,
  updated_at_utc INTEGER NOT NULL,
  revision INTEGER NOT NULL DEFAULT 0 CHECK (revision >= 0)
);
```

### Invariants & Business Constraints:
- **Singleton Row**: The `CHECK (id = 1)` constraint guarantees that at most one configuration row exists.
- **Allowed Themes**: `system`, `light`, or `dark`.
- **Locale Constraint**: `ar` (Arabic) is the only valid and selectable locale tag in the foundation.
- **Optimistic Concurrency / Auditing**: Every modification increments `revision` and updates `updated_at_utc`.
- **Scope Guard**: Zero business tables (products, quotes, invoices, scan items) exist in Version 1.

---

## 3. SQLite Pragmas & WAL Integrity

Upon opening the database connection, the following pragmas are executed:
```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA foreign_keys = ON;
```

### WAL Future-Backup Implications
In Write-Ahead Logging (WAL) mode:
1. SQLite creates two accompanying sidecar files: `app_database.sqlite-wal` and `app_database.sqlite-shm`.
2. Committed transactions initially reside in the `-wal` file until checkpointed into the main database file.
3. **Crucial Rule for Future Backup Features**: Any future export, backup, or file copy must never copy `app_database.sqlite` alone while connections are active. It must either perform an explicit `PRAGMA wal_checkpoint(TRUNCATE)` before file reading or use SQLite's native backup API (`sqlite3_backup_*`) to guarantee snapshot consistency.

---

## 4. Migrations & Safe Failure Recovery

- **Forward-Only Migrations**: Schema migrations are registered sequentially.
- **Newer-Schema Refusal**: If an older version of the app opens a database with a schema version greater than supported, initialization halts with `MIGRATION_NEWER_SCHEMA`. The app **never** downgrades or overwrites newer data.
- **Failed Migration Policy**: If a migration script fails, the transaction rolls back, and initialization aborts with `MIGRATION_FAILED`. The database file is **never deleted, reset, or truncated**. The user is shown safe Arabic recovery guidance with a diagnostic error code.

---

## 5. Platform Backup Exclusions

Operating systems often attempt automatic cloud backups (Google Drive, Apple iCloud). To maintain total privacy and offline ownership:
1. **Android**: `android:allowBackup="false"` is declared in `AndroidManifest.xml`. In addition, `backup_rules.xml` and `data_extraction_rules.xml` exclude `databases/`, `shared_prefs/`, and `files/` from cloud sync and device transfers.
2. **iOS**: All database and sidecar files are tagged with `URLResourceKey.isExcludedFromBackupKey = true` and `NSFileProtectionType.completeUntilFirstUserAuthentication`.
