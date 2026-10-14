# Implementation Plan: 008-business-profile

**Branch**: `008-business-profile` | **Date**: 2026-10-14 | **Spec**: [specs/008-business-profile/spec.md](spec.md)

**Input**: Feature specification from `specs/008-business-profile/spec.md`

## Summary

Implement 100% offline business profile and document customization:
1. Local SQLite singleton table `business_profiles` (id = 1) managed with Drift.
2. Sandboxed local store logo management (`FilePicker.pickFiles(type: FileType.image)` -> saved to application support directory).
3. Riverpod `BusinessProfileController` with atomic updates and validation.
4. Arabic RTL settings screen (`BusinessProfileScreen`) with live document header card preview.
5. Injected header and footer customization into `PdfQuotationGenerator` and `PdfInvoiceGenerator`.

## Technical Context

**Language/Version**: Dart 3.13.5 / Flutter 3.47.7  
**Primary Dependencies**: `flutter_riverpod`, `drift`, `sqlite3`, `path_provider`, `file_picker`, `pdf`, `printing`  
**Storage**: Drift over local SQLite (`business_profiles` table, singleton id = 1) + sandboxed logo file in application support directory  
**Testing**: `flutter_test`, fake repository implementations, widget tests, PDF builder unit tests  
**Target Platform**: Android (API 26+) and iOS (15.0+)  
**Project Type**: Offline-first Flutter mobile application  
**Performance Goals**: Instant header live preview (< 16ms), PDF generation with high-res logo in < 1.5 seconds  
**Constraints**: 100% offline, zero cloud storage, zero network access, strict LTR isolation for phone numbers in Arabic RTL  
**Scale/Scope**: 1 singleton business profile entity, 1 management screen, 2 updated PDF generators  

## Constitution Check

| Principle | Assessment | Compliance |
|-----------|------------|------------|
| I. 100% Offline Operation | Logo stored locally, zero remote calls or telemetry. | PASS |
| II. Cross-Platform Flutter | Works identically on Android and iOS via standard file storage. | PASS |
| III. Local Data Ownership | Profile persists in SQLite; logo persists in app sandbox. | PASS |
| IV. Data Integrity | Transactional upsert with id=1 singleton; never wiped on error. | PASS |
| V. Financial Accuracy | Does not modify financial calculations; only document headers & notes. | PASS |
| VIII. Arabic-First RTL | Proper Noto Sans Arabic typography, LTR phone wrapping, RTL document header. | PASS |
| IX. Modular Architecture | Domain entity and repository contract isolated from Flutter & Drift. | PASS |
| XI. Security & Privacy | No cloud transmission, strict sandboxed file paths. | PASS |

## Project Structure

### Documentation (this feature)

```text
specs/008-business-profile/
├── spec.md
├── checklists/
│   └── requirements.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/
│   └── business_profile_service.md
├── quickstart.md
└── tasks.md
```

### Source Code Layout

```text
lib/
├── core/
│   └── database/
│       ├── tables/
│       │   └── business_profile_table.dart     # Drift singleton table id = 1
│       └── app_database.dart                  # Schema update & migration
├── features/
│   ├── settings/
│   │   ├── domain/
│   │   │   ├── business_profile.dart           # Pure Dart entity
│   │   │   └── business_profile_repository.dart # Abstract contract
│   │   ├── data/
│   │   │   └── drift_business_profile_repository.dart # Drift implementation
│   │   ├── application/
│   │   │   └── business_profile_controller.dart # StateNotifier
│   │   └── presentation/
│   │       ├── business_profile_screen.dart    # Profile editor
│   │       └── widgets/
│   │           └── business_header_preview_card.dart # Live visual preview
│   ├── quotations/
│   │   └── data/
│   │       └── default_pdf_quotation_generator.dart # Injected profile header
│   └── invoices/
│       └── data/
│           └── default_pdf_invoice_generator.dart   # Injected profile header
test/
├── features/
│   └── settings/
│       ├── business_profile_repository_test.dart
│       ├── business_profile_controller_test.dart
│       └── business_profile_screen_test.dart
└── support/
    └── fake_business_profile_repository.dart
```
