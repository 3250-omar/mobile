# Technical Research: Backup & Restore

## Decision 1: Backup Container Architecture

- **Decision**: Use a structured binary container format (`.aqb` - Arabic Quotes Backup) containing:
  - Magic header: `AQB1` (4 bytes).
  - Flags: 1 byte (bit 0: isEncrypted, bit 1: isCompressed).
  - Metadata length: 4 bytes (big-endian integer).
  - Metadata JSON UTF-8: version, timestamp, SHA-256 payload checksum, record counts (products, quotations, invoices), salt and IV (if encrypted).
  - Payload: raw SQLite database binary (or AES-256-GCM encrypted ciphertext).
- **Rationale**: Self-describing container allows instant validation of version, checksum, and encryption status without reading the entire payload into RAM. Guarantees tamper-detection and forward compatibility.
- **Alternatives Considered**:
  - *Plain `.sqlite` file copy*: Lacks tamper detection, version metadata, and cannot support password protection without risking SQLite header corruption.
  - *Full JSON dump/export*: Drastically slower, consumes massive memory for large catalogs, and cannot guarantee exact byte-for-byte fidelity of SQLite indices and pragmas.

## Decision 2: SQLite WAL Checkpoint & Atomic Snapshot

- **Decision**: Before copying the database file during backup, execute `PRAGMA wal_checkpoint(TRUNCATE)` on the active SQLite database connection.
- **Rationale**: In WAL mode, recent commits may reside exclusively in `-wal` and `-shm` auxiliary files. Truncating the checkpoint forces all pages back into the main `.sqlite` file, allowing a single, completely consistent database file to be packaged without needing auxiliary files.
- **Alternatives Considered**:
  - *Copying `.sqlite` + `.sqlite-wal` + `.sqlite-shm` together*: High risk of race condition if a write occurs midway, and harder to package/restore safely across different storage paths.

## Decision 3: Non-Destructive Two-Stage Restore with Auto-Rollback

- **Decision**:
  1. Validate backup file checksum and metadata.
  2. If valid, create a safety copy of current active database: `<db_path>.pre_restore.bak`.
  3. Close active database connections.
  4. Write restored database file to active path.
  5. Open temporary SQLite connection and execute `PRAGMA integrity_check`.
  6. If `integrity_check` returns `ok`, delete `.pre_restore.bak` and reinitialize the app database.
  7. If any check fails, immediately restore `.pre_restore.bak` back to active path and surface error.
- **Rationale**: Adheres to Constitution Principle IV (Data Integrity and Historical Immutability). Restores can never result in a bricked database or unrecoverable state.
- **Alternatives Considered**:
  - *Direct overwrite without backup*: Rejected; any corrupt file or sudden crash during file write results in permanent total data loss.

## Decision 4: Pure Dart Encryption & Hash Verification

- **Decision**: Use standard Dart `crypto` package for SHA-256 hashing. For password encryption, use standard AES-256-GCM or AES-CBC with HMAC-SHA256 authenticated encryption using PBKDF2 key derivation (10,000 iterations).
- **Rationale**: 100% offline, cross-platform on Android and iOS without native C++ compilation overhead or external platform channel dependencies.
- **Alternatives Considered**:
  - *Platform-native Keystore/Keychain encryption*: Cannot be shared across devices (e.g., from Android to iOS), defeating the primary purpose of backup export.
