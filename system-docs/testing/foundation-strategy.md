# Foundation Testing Strategy

## Automated Layers

- **Unit tests**: configuration, state transitions, error mapping, numeral boundaries, theme policy, repository semantics.
- **Widget & semantics tests**: RTL shell/routes, mixed text, shared states, contrast-relevant theme tokens, focus/labels, 200% text scale, navigation stacks.
- **Database tests**: defaults, transaction rollback, reopen persistence, migration from every snapshot, failed migration preservation, newer schema refusal.
- **Integration tests**: cold/warm startup, force-close/reopen, theme persistence, navigation/restoration, initialization failure/retry, airplane-mode use.

---

## Platform Matrix

| Purpose | Android | iOS |
|---|---|---|
| **Minimum compatibility** | Pixel 2 API 26 emulator | iPhone 8 iOS 15 simulator |
| **Current compatibility** | Current supported SDK/device | Current supported iOS simulator/device |
| **Performance/offline exit** | Physical Pixel 4a (6 GB, arm64) | Physical iPhone SE 2nd generation on iOS 15+ |

Record the exact model, OS, build mode/commit, storage state, and results. Virtual devices can establish minimum-OS behavior but do not replace physical performance/offline evidence. If a named physical reference is unavailable, use documented equivalent-or-slower hardware and state the substitution; faster-only hardware does not satisfy the baseline gate.

---

## Offline Acceptance Method

Enable airplane mode and disable Wi-Fi before process launch. Exercise startup, every foundation route, settings read/write/restart, bundled localization/fonts, errors, and retry. Monitor for connection attempts and inspect Android manifests/iOS entitlements and the resolved dependency graph. Inspect Android backup/data-extraction exclusions and cleartext policy, then verify iOS excluded-from-backup and file-protection attributes for the database, sidecars, settings, and diagnostics. Any required transmission, backup-eligible protected file, or missing protection fails the gate.

---

## Performance Method

Use a production-like profile/release build. Measure at least 20 cold and 20 warm launches after one untimed preparation run. Cold readiness target is 3 seconds; warm target is 2 seconds. Record median and worst result. Navigation feedback begins within 100 ms. Do not compare debug build timings to acceptance thresholds.

---

## Evidence Records & Completed Reports

All quality gates are evidenced under `system-docs/testing/evidence/`:
- [Static & Automated Test Evidence](evidence/static-and-automated.md) (Format, Analyze, 83/83 Tests Passed)
- [Developer Onboarding & Rehearsal Evidence](evidence/developer-onboarding.md)
- [Android Platform Validation Evidence](evidence/android-validation.md)
- [iOS Platform Validation Evidence](evidence/ios-validation.md) (Pending Apple environment)
- [Offline Privacy & Backup Exclusion Evidence](evidence/offline-privacy-validation.md)
- [Reliability & 100-Cycle Validation Evidence](evidence/reliability-validation.md)
- [Performance Benchmarking Evidence](evidence/performance-validation.md)
- [Arabic-First & Accessibility Validation Evidence](evidence/arabic-accessibility-validation.md)
- [Constitutional & Scope Audit Evidence](evidence/constitution-and-scope-audit.md)
