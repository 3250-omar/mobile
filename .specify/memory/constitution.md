<!--
Sync Impact Report
- Version change: template (unratified) -> 1.0.0
- Modified principles: placeholder principles -> fifteen project-specific principles
- Added sections: Product Constraints; Workflow and Quality Gates
- Removed sections: none (placeholder sections were concretized)
- Follow-up TODOs: none
-->
# Offline Arabic Quotation and Invoice App Constitution

## Core Principles

### I. 100% Offline Operation (NON-NEGOTIABLE)
Every core user journey MUST work with network access disabled. Arabic handwriting OCR, catalog import
and lookup, matching, review, pricing, PDF generation, backup, and restore MUST NOT depend on cloud
inference, a backend, runtime authentication, or an online license check. No component may silently
fall back to a network service.

### II. Cross-Platform Flutter Delivery
Flutter MUST be the shared framework for Android and iOS. Native integrations MAY be used for device
capabilities, performance, or offline AI inference, but MUST expose documented interfaces and receive
platform-specific tests. Success on one platform does not establish support on the other.

### III. Local Data Ownership
Users MUST import product data manually from Excel; the normalized catalog MUST reside in local SQLite.
Quotations, invoices, settings, customer and business data, and OCR data needed for audit or recovery
MUST persist on-device and remain usable without an account or network connection.

### IV. Data Integrity and Historical Immutability
Logical database operations MUST be transactional and atomic. Schema changes MUST use versioned, tested
migrations. Imports MUST report accepted, changed, duplicate, and rejected rows and MUST NOT silently
discard data. Skipped or invalid document items MUST be surfaced. Finalized documents MUST keep
immutable snapshots of descriptions, quantities, prices, discounts, and totals. Backup and restore MUST
be reliable, integrity-checked, and tested before production release.

### V. Deterministic Financial Accuracy
Money MUST use fixed-precision decimal or integer minor units, never binary floating point. Rounding,
precision, discount order, and formatting MUST be specified and boundary-tested. AI and OCR MUST NEVER
calculate or override totals. Only the deterministic pricing module may compute totals from approved
quantities, price snapshots, and manual discounts. Persisted records and PDFs MUST agree exactly.

### VI. Evidence-Gated AI Reliability
Offline handwritten Arabic OCR is an unverified technical risk. Before choosing a production model or
making an irreversible architecture commitment, a proof of concept MUST be measured on representative,
consented domain handwriting and target devices. An approved specification MUST define accuracy,
latency, memory, package-size, thermal, and device thresholds. OCR output is always a fallible suggestion;
confidence, provenance, failures, and ambiguity MUST be visible where available.

### VII. Human-in-the-Loop Control
Automatic product preselection MUST require an approved reliability threshold and unambiguous matching.
Uncertain, conflicting, incomplete, or unmatched items MUST be flagged and MUST NOT be silently omitted
or accepted. Users MUST be able to correct recognition and selections. Explicit final approval is
required before a document is finalized or its final PDF generated.

### VIII. Arabic-First Experience
Arabic RTL behavior MUST be the default design and test baseline. OCR, normalization, search, and
matching MUST cover Arabic handwriting, colloquial abbreviations, mixed Arabic and Latin text,
Arabic-Indic and Western numerals, and fractional sizes. UI and PDFs MUST correctly handle shaping,
embedded Arabic fonts, bidirectional text, and mixed numerals on both platforms.

### IX. Modular and Replaceable Architecture
OCR, parsing, normalization, matching, catalog management, pricing, PDF generation, and persistence
MUST be separate modules with explicit contracts. Business rules MUST NOT live in UI, model adapters,
or PDF layout code. Modules, especially OCR and matching, MUST be independently testable and replaceable.

### X. Comprehensive Verification
Critical logic MUST have unit tests. Imports, SQLite, migrations, module contracts, backup/restore, and
PDF consistency MUST have integration tests. Real-device and performance tests MUST cover offline OCR,
camera, Arabic rendering, file access, and document generation. Offline acceptance tests MUST disable
network access. Android and iOS MUST be validated independently. Financial, migration, and data-loss
regressions block release.

### XI. Security and Privacy by Default
Customer, business, catalog, image, OCR, document, usage, and diagnostic data MUST NOT be transmitted
without a separately approved specification and informed user action. Dependencies MUST be checked for
telemetry and remote calls. Sensitive local data and backups MUST use platform-appropriate protection;
secrets belong in secure platform storage. Logs MUST exclude sensitive content. Restore MUST verify
integrity and require confirmation before overwriting valid data.

### XII. Spec-Driven Development
Every feature MUST pass through specification, clarification, technical planning, dependency-ordered
tasks, consistency analysis, implementation, and validation. Each stage MUST use approved preceding
artifacts. Implementation MUST NOT begin with unresolved financial, integrity, privacy, or OCR acceptance
requirements. Completion requires acceptance criteria and constitutional checks to pass.

### XIII. Maintainable Simplicity
Code MUST be readable, consistent, and organized by responsibility. Reuse and dependency injection
SHOULD be used when they improve clarity, testing, or replacement. Abstractions MUST have demonstrated
value; speculative layers and duplicated rules are prohibited. Dependencies MUST be justified,
maintained, license-compatible, cross-platform, and offline at runtime.

### XIV. Living Project Documentation
Documentation MUST live under `system-docs/` and cover architecture, decisions, business rules, module
contracts, data and migrations, imports, finance, OCR evaluation, security, backup/restore, testing, and
important changes. `AGENTS.md` MUST be created and maintained as the developer and AI-agent entry point
during subsequent appropriate documentation work; this constitution does not create it.

### XV. Incremental Delivery and Scope Discipline
Features MUST ship in small, independently reviewable phases with acceptance criteria, risks, and
migration or rollback implications. The whole application MUST NOT be one implementation iteration.
Cloud synchronization, inventory, ERP, online payments, and unrelated capabilities MUST NOT enter design
or implementation without a separately approved specification and constitutional scope review.

## Product Constraints

- The initial domain is quotations and invoices for plumbing and sanitary supplies shops.
- The core flow is capture, on-device OCR, local parsing and matching, review and correction,
  deterministic fixed-price calculation with optional manual discount, approval, persistence, and
  Arabic-compatible PDF generation.
- SQLite is authoritative; Excel is a user-controlled import source, not synchronization.
- Matching MUST use local data and expose testable confidence or reasons.
- Finalized documents are distinct from drafts. Later changes MUST create a traceable revision or other
  approved record; historical financial facts MUST NOT be mutated in place.
- OCR failure MUST degrade safely to manual entry and MUST NOT block the quotation workflow.

## Workflow and Quality Gates

1. Each phase MUST start with an approved specification covering scope, exclusions, acceptance criteria,
   offline and Arabic behavior, both platforms, and risk.
2. Clarification MUST resolve material ambiguity before planning, especially for money, data, privacy,
   OCR thresholds, and finalization.
3. Plans MUST define module boundaries, local data changes, migrations, platform work, tests,
   documentation impact, and measurable performance targets.
4. Tasks MUST be small, dependency-ordered, and traceable. Consistency analysis MUST precede coding.
5. Reviews MUST verify this constitution, exact finance, history safety, offline operation, Arabic UX,
   documentation, and applicable Android and iOS evidence.
6. OCR work MUST provide metrics from the approved evaluation set; demonstrations alone are insufficient.
7. Exceptions require documented scope, rationale, risk, owner, expiry, and project-owner approval. No
   exception may weaken offline operation, financial accuracy, historical integrity, or final approval.

## Governance

This constitution governs specifications, plans, tasks, code, tests, and documentation and prevails over
conflicting project practices. Amendments MUST state the exact change, rationale, affected artifacts,
compatibility or migration impact, and validation plan, and require explicit project-owner approval.
They MUST update this file, its version and amendment date, and affected documentation or follow-up work.

Governance uses semantic versioning: MAJOR for removing or incompatibly redefining principles or rules;
MINOR for new principles, sections, or materially expanded duties; PATCH for non-semantic clarification.
The ratification date remains the initial adoption date.

Every specification and plan review MUST include a constitution check. Every implementation review and
release candidate MUST provide applicable quality-gate evidence. Noncompliance blocks acceptance unless
a permitted, time-bounded exception is approved. Reviews MUST confirm authorized scope, current docs,
migrations and backups, and independent platform validation.

**Version**: 1.0.0 | **Ratified**: 2026-10-12 | **Last Amended**: 2026-10-12
