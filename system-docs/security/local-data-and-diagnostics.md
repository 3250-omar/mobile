# Local Data Security & Diagnostics Policy

**Status**: Implemented for Feature `001-project-foundation`.

---

## 1. Zero-Network Security Model

The application adheres to an uncompromising offline boundary:
- **No Remote Telemetry**: Zero analytics SDKs (no Firebase, Sentry, Datadog, Mixpanel).
- **No Background Sync**: No silent background fetch, push notifications, or cloud endpoints.
- **No Remote Fonts/Assets**: All fonts (Noto Sans Arabic) and assets are bundled in the binary.
- **Network Permission Deprivation**: The Android manifest omits unnecessary network permissions, and cleartext traffic is explicitly prohibited.

---

## 2. Local Diagnostic Architecture

Diagnostics assist troubleshooting without compromising user privacy:
- **Component**: `AppLogger` orchestrates structured event logging.
- **Early Memory Buffer**: Events logged prior to file-system availability (e.g., during storage initialization) are held in a circular FIFO in-memory buffer (maximum 200 events) and flushed once `LocalLogSink` attaches.
- **Persistent Log Sink**:
  - Format: Structured JSON Lines (`.jsonl`).
  - Storage Cap: Maximum 3 rolling files of 512 KiB each (total persistent log footprint is strictly bounded to ≤ 1.5 MiB).
  - Rotation: When `diagnostics_current.jsonl` exceeds 512 KiB, it is rotated to `diagnostics_1.jsonl` and `diagnostics_2.jsonl`. Older entries are safely pruned locally.

---

## 3. Strict Data Redaction & Sanitization

Logs are scrubbed before reaching disk or presentation:
- **Prohibited Attributes**: File system paths (e.g. `/data/user/0/...`), raw SQL queries, stack traces, and fixture keys are intercepted and redacted by `RedactionPolicy`.
- **Allowed Attributes**: Only safe structured keys (e.g. `stage`, `attemptId`, `themeMode`, `status`, `eventCode`) are retained.
- **User-Facing Presentation**: Presentation layers never expose raw infrastructure exceptions. When an unexpected error occurs, the user sees a friendly Arabic explanation alongside a sanitized diagnostic attempt reference (e.g., `ERR-BOOTSTRAP-CONFIG`).

---

## 4. Diagnostic Reference Viewer & User Utility

In the event of an initialization or persistence failure:
- The user is directed to the `DiagnosticReferenceView`.
- The view displays:
  - Human-readable localized explanation.
  - Opaque alphanumeric Diagnostic Reference ID.
  - A single-tap "Copy Diagnostic Code" action for offline support communication.
- No automatic export, background transmission, or cloud reporting occurs.

---

## 5. Platform Data Protection & OS Backup Exclusions

| Platform | Policy | Mechanism |
|---|---|---|
| **Android** | Zero cloud backup or cross-device transfer | `android:allowBackup="false"`, `res/xml/backup_rules.xml`, and `res/xml/data_extraction_rules.xml` |
| **Android** | Cleartext traffic disabled | `android:usesCleartextTraffic="false"` |
| **iOS** | Backup exclusion | `URLResourceKey.isExcludedFromBackupKey = true` on database and logs |
| **iOS** | At-rest device encryption | `NSFileProtectionType.completeUntilFirstUserAuthentication` |
