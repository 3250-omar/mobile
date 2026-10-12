# Feature Specification: Flutter Application Foundation

**Feature Branch**: `001-project-foundation`

**Created**: 2026-10-12

**Status**: Draft

**Input**: User description: "Establish the production-quality, fully offline, Arabic-first Flutter application foundation for Android and iOS."

## Clarifications

### Session 2026-10-12

- Q: Which primary navigation structure should the phone application use for its six foundational
  destinations? -> A: Use a four-item bottom bar for Home, Products, Quotations, and Invoices, a prominent
  Scan action, and place Settings in a secondary menu.
- Q: What minimum operating-system versions should this feature support? -> A: Support Android 8.0
  (API 26) and newer and iOS 15 and newer.
- Q: How should light and dark themes behave for users? -> A: Follow the device theme by default and
  provide persisted System, Light, and Dark choices in Settings.
- Q: Which numeral convention should the Arabic interface use for app-generated numbers? -> A: Display
  Western digits for app-generated numeric values, accept Western and Arabic-Indic input, and preserve
  digits inside literal names and codes.
- Q: What should the app allow when its local database cannot be opened or migrated safely after retries?
  -> A: Preserve all local files, block unsafe use, offer retry and diagnostic guidance, and provide no
  in-app reset or deletion in this feature.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start and Use the App Offline (Priority: P1)

As a shop owner, I can open the application without internet access and reach a usable Arabic home
screen so that connectivity never blocks my work.

**Why this priority**: Offline availability and reliable startup are constitutional requirements and
the prerequisite for every later feature.

**Independent Test**: Install a clean build on a supported device, disable all network connectivity,
launch the application, and confirm that initialization completes and the home shell is usable without
authentication or remote-service errors.

**Acceptance Scenarios**:

1. **Given** a supported device with no network connectivity and no prior app data, **When** the user
   launches the app, **Then** the app initializes local resources and displays the Arabic home screen.
2. **Given** a supported device in airplane mode with existing settings, **When** the user relaunches the
   app, **Then** the app restores those settings and displays the shell without a remote dependency.
3. **Given** initialization cannot complete, **When** the app starts, **Then** the user sees an Arabic,
   actionable error state and a safe retry action rather than a blank screen or silent failure.
4. **Given** local data cannot be opened or migrated safely after retry, **When** startup remains blocked,
   **Then** the app preserves all local files, provides diagnostic guidance, and offers no reset action.

---

### User Story 2 - Navigate an Arabic-First Application Shell (Priority: P1)

As an Arabic-speaking shop owner, I can move between the foundational destinations using a predictable
RTL navigation experience so that I understand where future workflows will live.

**Why this priority**: A correct Arabic shell is the user-facing foundation on which independent
features will be added.

**Independent Test**: Start the app in Arabic and visit Home, Scan handwritten list, Products,
Quotations, Invoices, and Settings, verifying destination identity, back behavior, RTL direction, and
offline navigation. Placeholder destinations provide orientation only and perform no business actions.

**Acceptance Scenarios**:

1. **Given** the Arabic application shell, **When** the user selects Home, Products, Quotations, or
   Invoices from the bottom bar, invokes the prominent Scan action, or selects Settings from the
   secondary menu, **Then** the labeled foundational screen opens with correct RTL navigation and a clear
   current-location state.
2. **Given** the user navigated away from Home, **When** the user invokes platform back navigation,
   **Then** navigation follows a predictable hierarchy without exiting unexpectedly or losing settings.
3. **Given** the user opens an out-of-scope destination, **When** its business capability is unavailable,
   **Then** the app presents a clear neutral placeholder and does not simulate completed functionality.

---

### User Story 3 - Read and Operate a Consistent Interface (Priority: P2)

As a shop owner using the app repeatedly during the workday, I receive consistent, accessible controls,
feedback, and layouts so that common actions are easy to recognize and operate.

**Why this priority**: A shared visual and interaction language prevents later features from becoming
inconsistent or difficult to use.

**Independent Test**: Review the component showcase or foundational screens at supported text scales,
screen sizes, themes, and interaction states, and confirm that each required component is readable,
operable, consistent, and correctly mirrored in RTL.

**Acceptance Scenarios**:

1. **Given** any foundational screen, **When** buttons, fields, cards, dialogs, navigation, loading,
   empty, or error states appear, **Then** they follow the same approved visual and interaction rules.
2. **Given** a user increases system text size or uses a compact supported screen, **When** the shell is
   displayed, **Then** essential text and controls remain readable and usable without clipped actions.
3. **Given** mixed Arabic text and Arabic-Indic or Western numerals, **When** content is rendered, **Then**
   reading order and alignment remain understandable, app-generated values use Western digits, literal
   names and codes preserve their digits, and no characters are corrupted.

---

### User Story 4 - Keep Foundational Preferences (Priority: P2)

As a shop owner, I can change available foundational preferences and find them unchanged after restarting
the app so that the application respects my working preferences offline.

**Why this priority**: Persistent settings prove that the local data foundation works before business
data is introduced.

**Independent Test**: Change each available foundational setting, terminate the app, keep the device
offline, relaunch it, and verify the saved values are restored consistently.

**Acceptance Scenarios**:

1. **Given** the Settings screen, **When** the user changes a foundational preference, **Then** the app
   confirms the new value and uses it where applicable.
2. **Given** saved preferences and no network connection, **When** the app restarts, **Then** the same
   values are restored.
3. **Given** a settings write fails, **When** the user attempts a change, **Then** the previous valid value
   remains active and the failure is clearly reported.
4. **Given** the theme preference is System, **When** the device appearance changes, **Then** the app uses
   the matching theme; **Given** Light or Dark is selected, **Then** that override remains active after restart.

---

### User Story 5 - Recover from Lifecycle and Initialization Problems (Priority: P2)

As a shop owner, I can background, resume, interrupt, and retry the app without corruption or unexplained
failure so that normal device lifecycle events do not disrupt foundational use.

**Why this priority**: Mobile lifecycle reliability protects future documents and settings from partial
initialization and inconsistent state.

**Independent Test**: Exercise cold start, warm start, background/resume, interrupted initialization,
and safe retry on Android and iOS while offline, then verify a single coherent application state.

**Acceptance Scenarios**:

1. **Given** the app is initialized, **When** it is backgrounded and resumed, **Then** it returns to a
   valid screen without repeating destructive initialization or losing saved settings.
2. **Given** initialization was interrupted, **When** the user relaunches the app, **Then** initialization
   safely resumes or restarts without exposing partial data.
3. **Given** a recoverable local failure, **When** the user retries, **Then** the app either reaches the
   shell or reports a stable actionable failure with no silent data loss.

---

### User Story 6 - Onboard and Validate the Project Locally (Priority: P3)

As a future developer, I can follow project documentation to set up, analyze, test, and build the
application locally so that the foundation remains maintainable across both platforms.

**Why this priority**: Repeatable local development and validation are necessary for safe incremental
delivery but follow the end-user startup and shell experience.

**Independent Test**: A developer unfamiliar with the repository follows only the maintained onboarding
documentation and completes the documented analysis, tests, Android build, and applicable iOS build.

**Acceptance Scenarios**:

1. **Given** a supported development environment, **When** a developer follows the onboarding guide,
   **Then** required tools, configuration modes, formatting, analysis, testing, and build steps are clear.
2. **Given** an appropriate Apple development environment, **When** the documented iOS build steps are
   followed, **Then** the application builds for the documented target; signing prerequisites are explicit.
3. **Given** a non-Apple environment, **When** the developer reads the guide, **Then** it clearly states
   that iOS build and signing require an appropriate Apple development environment.

### Edge Cases

- First launch occurs in airplane mode with no previously created local database.
- The app is terminated while local initialization or a settings write is in progress.
- A stored schema version is older than the application expects, or migration cannot complete.
- Local storage is unavailable, full, read-only, or contains malformed foundational settings.
- The device locale is non-Arabic while the app has never stored a language preference.
- Arabic and Latin text, Arabic-Indic and Western numerals, and long labels appear in one view.
- System text scaling, display scaling, landscape orientation, or a compact screen stresses the layout.
- A user rapidly selects multiple destinations or invokes back navigation during startup.
- The app resumes after the operating system has reclaimed its process.
- A recoverable initialization retry is attempted multiple times; the app must not duplicate data or
  apply a migration more than once.
- A local database remains unreadable or incompatible after retries; the app must preserve its files,
  block unsafe use, and must not offer or perform an in-app reset.
- Camera, media, notification, location, contacts, network, and other sensitive permissions have not been
  granted; the foundational shell must remain fully usable without requesting them.

## Requirements *(mandatory)*

### Functional Requirements

#### Application Foundation

- **FR-001**: The product MUST provide one shared mobile application supporting Android 8.0 (API 26)
  and newer and iOS 15 and newer.
- **FR-002**: The app MUST coordinate startup so that foundational configuration, localization, local
  persistence, and error handling reach a known state before the interactive shell is shown.
- **FR-003**: The app MUST start and remain usable for foundational journeys with all network access
  disabled and MUST NOT require remote authentication or a backend during startup.
- **FR-004**: The app MUST support distinct development, testing, and production configurations without
  changing the product's offline guarantees or exposing production-sensitive values in other modes.
- **FR-005**: Unhandled and initialization errors MUST be converted into consistent, user-safe states;
  initialization failures MUST be visible, recorded locally without sensitive content, and recoverable
  where retry is safe. A blocking local-data failure MUST preserve local files and MUST NOT expose an
  in-app reset or deletion action in this feature.
- **FR-006**: Startup MUST be idempotent: repeated launch, retry, or resume MUST NOT duplicate foundational
  records, rerun completed migrations destructively, or produce conflicting application state.

#### Arabic-First Localization

- **FR-007**: Arabic MUST be the default language on first launch regardless of device language.
- **FR-008**: Every foundational screen and shared component MUST support RTL layout, navigation direction,
  alignment, focus order, and directional icon behavior appropriate to Arabic.
- **FR-009**: Foundational text MUST use legible Arabic-capable typography and correctly render Arabic,
  Latin, bidirectional text, Arabic-Indic numerals, Western numerals, and common punctuation.
- **FR-010**: The localization foundation MUST allow additional languages without changing feature
  behavior or embedding user-facing copy directly in screens and shared states.
- **FR-011**: App-generated numeric values MUST display Western digits. Numeric input MUST accept Western
  and Arabic-Indic digits as equivalent values. Digits contained in literal user-entered names, labels,
  identifiers, or codes MUST be preserved rather than reformatted. Presentation MUST NOT alter stored values.

#### Navigation and Application Shell

- **FR-012**: The initial phone shell MUST provide a four-item bottom navigation bar for Home, Products,
  Quotations, and Invoices; a visually prominent and independently accessible Scan handwritten list
  action; and Settings in a secondary menu reachable from the shell.
- **FR-013**: Home MUST be the initial destination after successful startup unless a safe restoration rule
  explicitly returns the user to a previously valid foundational destination.
- **FR-014**: Navigation MUST identify the active destination, prevent duplicate destination stacking,
  preserve predictable back behavior, and remain fully functional offline. Android system back and
  predictive-back behavior and iOS back gestures MUST follow their platform conventions while producing
  the same destination hierarchy and data-safety outcome.
- **FR-015**: Destinations whose business functionality is out of scope MUST show honest foundational
  placeholders and MUST NOT create, recognize, import, match, price, invoice, or generate documents.
- **FR-016**: The shell MUST preserve valid navigation state across ordinary background and resume events
  and recover safely when process state cannot be restored.

#### Design System

- **FR-017**: The product MUST define reusable rules for color, light and dark themes, typography, spacing,
  shape, elevation, icon direction, interaction feedback, and motion. Theme behavior MUST follow the
  device by default and provide System, Light, and Dark choices in Settings.
- **FR-018**: The foundation MUST provide consistent user-visible variants for buttons, form fields,
  cards, dialogs, loading states, error states, empty states, and navigation elements.
- **FR-019**: Each interactive component MUST define enabled, pressed, focused, selected, disabled, loading,
  validation-error, and success states where those states apply.
- **FR-020**: Foundational screens MUST adapt without loss of essential content or actions across supported
  phone sizes, portrait and landscape orientation, and supported text scaling.
- **FR-021**: All controls MUST have meaningful accessible names, logical traversal order, sufficient
  contrast, non-color-only status cues, and touch targets of at least 44 by 44 logical pixels.
- **FR-022**: Loading, empty, and error states MUST explain the current condition in Arabic and provide an
  appropriate next action when user recovery is possible.
#### Local Persistence Foundation

- **FR-023**: The app MUST create or open its local SQLite database without network connectivity.
- **FR-024**: The persistence foundation MUST track schema versions and apply ordered migrations atomically;
  a failed migration MUST leave the last valid data state recoverable and MUST block unsafe use. Retry MUST
  be safe, and repeated failure MUST NOT trigger automatic recreation, reset, deletion, or downgrade.
- **FR-025**: Multi-step local writes MUST support transactional all-or-nothing behavior.
- **FR-026**: Data access boundaries MUST allow local storage behavior to be tested and replaced without
  changing user-facing or domain behavior.
- **FR-027**: The foundation MUST persist supported settings locally, including the System, Light, or Dark
  theme choice, and restore their last confirmed values after a process restart while offline.
- **FR-028**: The persistence foundation MUST reserve clear, separately evolvable boundaries for future
  catalog, quotation, and invoice data without defining those business schemas in this feature.
- **FR-029**: Persistence errors MUST NOT be ignored, represented as successful writes, or silently reset
  valid settings to defaults.

#### Architecture, Diagnostics, and Developer Experience

- **FR-030**: Project organization MUST isolate feature presentation, domain rules, data responsibilities,
  and shared infrastructure while avoiding abstractions without a current testability or replacement need.
- **FR-031**: Infrastructure capabilities MUST be accessed through stable boundaries so local persistence,
  logging, configuration, and future offline AI adapters can be independently tested or replaced.
- **FR-032**: Dependency ownership and direction MUST be consistent and prevent presentation concerns from
  becoming the authoritative location for persistence or domain rules.
- **FR-033**: Diagnostic events MUST be stored or exposed locally, MUST avoid customer or business-sensitive
  content, and MUST NOT require cloud logging, telemetry, or a network connection.
- **FR-034**: The repository MUST enforce consistent formatting, static analysis, and lint rules for
  application and test code.
- **FR-035**: Automated tests MUST cover startup coordination, configuration selection, localization and
  RTL behavior, navigation, shared component states, database creation and migration, settings persistence,
  error recovery, and offline acceptance on both target platforms where behavior differs.
- **FR-036**: Maintained documentation MUST explain local setup, required tooling, project organization,
  configuration modes, formatting, analysis, tests, Android builds, and iOS build/signing prerequisites.
- **FR-037**: iOS documentation MUST explicitly require an appropriate Apple development environment for
  iOS builds and signing; inability to build iOS elsewhere MUST NOT be represented as platform validation.
- **FR-038**: Destructive or irreversible actions introduced by future features MUST use a reusable,
  accessible confirmation state that identifies the consequence and provides distinct confirm and cancel
  actions; this feature MUST demonstrate the state without performing a business-data operation.
- **FR-039**: The foundational shell MUST start and remain usable without requesting camera, media,
  notification, location, contacts, network, or other sensitive runtime permissions. Permission requests
  belong only to later approved features at the moment the related user action requires them.

### Non-Functional Requirements

- **NFR-001 — Offline**: Foundational startup, navigation, settings access, diagnostics, and recovery MUST
  complete with network access disabled and without runtime backend dependencies.
- **NFR-002 — Startup performance**: On supported mid-range reference devices, 95% of measured warm starts
  MUST show a usable shell within 2 seconds and 95% of measured clean cold starts within 4 seconds,
  excluding operating-system installation work. Reference devices and measurement method must be recorded.
- **NFR-003 — Reliability**: Across 100 automated startup/lifecycle cycles per target platform, no cycle
  may cause a crash, duplicated migration, corrupted setting, or silent initialization failure.
- **NFR-004 — Arabic correctness**: All foundational screens and shared states MUST pass documented RTL,
  bidirectional-text, numeral, font-rendering, and truncation checks on Android and iOS independently.
- **NFR-005 — Accessibility**: Foundational journeys MUST be completable with platform screen readers and
  supported text scaling, with no inaccessible required action or information conveyed only by color.
- **NFR-006 — Privacy**: The foundation MUST perform no unauthorized network transmission and SHOULD omit
  unnecessary internet permissions where the target platform permits; diagnostics MUST remain local.
- **NFR-007 — Maintainability**: Foundational modules MUST be independently testable, documented, and
  replaceable at defined boundaries without duplicating configuration, error, or persistence rules.
- **NFR-008 — Platform parity**: Every acceptance scenario MUST be validated independently on Android and
  iOS; a platform-specific exception requires an approved specification amendment.
- **NFR-009 — Failure visibility**: Every startup or persistence failure that prevents correct operation
  MUST produce a deterministic local diagnostic record and a user-visible state; silent fallback is forbidden.
- **NFR-010 — Visual simplicity**: The shell and shared components MUST remain clean, professional, and
  optimized for repeated shop use without decorative interaction that delays or obscures core actions.

### Key Entities

- **Application Configuration**: The selected non-secret operating mode and its locally available behavior;
  development, testing, and production modes share the same offline guarantees.
- **Application Settings**: User-controlled foundational preferences, including a required theme choice
  of System, Light, or Dark, with a last-confirmed value and local update time.
- **Initialization State**: The observable startup phase and outcome: not started, initializing, ready,
  recoverable failure, or blocking failure, including a non-sensitive local diagnostic reference.
- **Schema Version**: The current local data format version and the ordered migration history needed to
  establish that version safely.
- **Local Diagnostic Event**: A non-sensitive record of a foundational warning or failure, including time,
  severity, category, configuration mode, platform context, and safe troubleshooting details.
- **Navigation Destination**: A stable identity, localized label, accessibility label, icon semantics, and
  availability state for each foundational section.

### Dependencies

- The ratified project constitution at `.specify/memory/constitution.md`.
- Android 8.0 (API 26) or newer and iOS 15 or newer devices, including their standard accessibility
  and lifecycle facilities.
- Local device storage available to the application.
- An appropriate Apple development environment for iOS build, signing, and device validation.
- Future feature specifications will define OCR, Excel import, catalog operations, matching, pricing,
  quotations, invoices, PDFs, backup, and restore; this feature exposes no business behavior for them.

### Explicitly Out of Scope

- OCR, AI inference, and camera-based text recognition.
- Excel parsing or imports and product catalog business operations.
- Product normalization or matching.
- Quotation pricing, discounts, and financial business logic.
- Invoice or quotation document generation and PDF generation.
- Backup and restore behavior.
- Cloud synchronization, online authentication, remote telemetry, inventory, ERP, and online payments.
- Complete future product, quotation, invoice, customer, OCR, or document database schemas.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A clean installation reaches a usable Arabic home shell with networking disabled on every
  acceptance device running Android 8.0 (API 26) or newer or iOS 15 or newer, including devices at both
  minimum supported versions.
- **SC-002**: At least 95% of measured warm launches reach the usable shell within 2 seconds and at least
  95% of measured clean cold launches within 4 seconds on documented mid-range reference devices.
- **SC-003**: Home, Products, Quotations, and Invoices are directly reachable offline from the bottom bar;
  Scan is directly reachable through its prominent action; Settings is reachable within two actions;
  all six destinations are correctly labeled in Arabic and provide predictable back navigation.
- **SC-004**: 100% of the foundational screen and shared-component test matrix passes for RTL direction,
  mixed text, Western display digits, both accepted input digit systems, literal-digit preservation,
  supported text scaling, portrait and landscape layouts, and both target platforms.
- **SC-005**: Every required shared component demonstrates all applicable normal, disabled, loading, empty,
  validation, error, and recovery states with consistent appearance and behavior.
- **SC-006**: Local data initializes successfully on a clean offline install, and 100 consecutive launch,
  resume, retry, and migration test cycles per platform produce no duplicate data or corruption.
- **SC-007**: Every exposed foundational setting retains its last confirmed value through termination and
  offline restart in all persistence acceptance tests; System follows device appearance, while Light and
  Dark remain fixed until the user changes the preference.
- **SC-008**: Every simulated initialization, migration, storage, and settings failure produces a visible,
  actionable state and a non-sensitive local diagnostic; none results in a blank screen, false success,
  automatic local-data recreation, reset, or deletion. Blocking failures offer retry and guidance only.
- **SC-009**: Static analysis, formatting verification, and all automated foundation tests complete with
  zero errors before the feature is accepted.
- **SC-010**: A developer unfamiliar with the project can use only the maintained documentation to set up
  the environment and complete analysis, tests, and an Android build; on an appropriate Apple environment,
  the same documentation enables an iOS build and clearly explains signing.
- **SC-011**: Screen-reader users can complete startup, navigate all foundational destinations, recognize
  the active destination, change an exposed setting, and understand an error state without inaccessible
  required actions.
- **SC-012**: Network monitoring during all foundational acceptance journeys observes zero attempted remote
  connections by application-controlled code.
- **SC-013**: Clean-install and subsequent-launch acceptance tests complete without any sensitive runtime
  permission prompt on both Android and iOS.

## Assumptions

- The target form factor for this feature is phones; tablet-specific optimization may be specified later,
  while layouts must still avoid failure on larger supported screens.
- Arabic is selected on first launch. The localization foundation permits future languages, but this
  feature does not require a user-facing language switch unless separately approved.
- The exact Arabic font family, brand palette, and reference device list are planning/design decisions
  constrained by the observable requirements above.
- Development, testing, and production modes are selected before application launch; end users do not
  switch modes at runtime.
- Foundational settings contain no financial or business records. Future business data requires separate
  specifications and migrations.
- A safe default may be used only when no prior valid setting exists. Corrupt or unreadable existing data
  must be reported rather than silently replaced.
- The startup performance targets are initial acceptance baselines and may be tightened after representative
  device measurements; relaxing them requires specification review.

## Open Questions

No blocking requirement ambiguities remain. Planning must record the reference performance devices,
exact Arabic font licensing/embedding choice, and brand palette while preserving every observable
requirement in this specification.

## Constitution Compliance

- **Offline and privacy**: Startup, navigation, persistence, diagnostics, and settings require no network,
  backend, authentication, cloud logging, or telemetry.
- **Cross-platform and Arabic-first**: Android and iOS are independently accepted; Arabic RTL, mixed text,
  numeral handling, accessibility, and Arabic-capable typography are explicit test gates.
- **Local ownership and integrity**: SQLite initialization, atomic migrations, transactions, visible errors,
  idempotency, and non-destructive settings persistence are mandatory.
- **Modularity and maintainability**: Responsibilities are separated at testable boundaries without
  prescribing unnecessary class structures or speculative abstraction.
- **Testing and documentation**: Unit, integration, lifecycle, device, performance, accessibility, and
  offline acceptance evidence is required, with maintained onboarding documentation.
- **Incremental scope**: The feature creates only the application foundation and honest destination
  placeholders; OCR, imports, matching, finance, documents, and backup/restore remain separate features.

No constitutional exception or conflict is requested by this specification.
