# Contract: Navigation

## Route inventory

| Destination | Placement | Foundation behavior |
|---|---|---|
| Home | primary branch, initial | Foundational home content |
| Products | primary branch | Localized unavailable/empty state |
| Quotations | primary branch | Localized unavailable/empty state |
| Invoices | primary branch | Localized unavailable/empty state |
| Scan | prominent root route/action | Localized unavailable state; no camera permission |
| Settings | secondary root route | Theme setting and foundation information |

## Guarantees

- Four primary branch navigators retain independent state.
- Scan/Settings return to the originating branch and state.
- Named route identifiers and stable paths are unique.
- Back order is overlay, nested route, branch root, Home, platform exit.
- Deep links to known foundational routes work offline after initialization.
- Unknown routes show a localized safe error with a Home action.
- Navigation does not instantiate future business services or request permissions.
- Android and iOS back/gesture behavior follows their platform conventions.

## Acceptance evidence

Widget tests cover every route, repeated branch selection, preserved stacks, unknown route, and RTL order. Device tests cover Android system/predictive back and iOS swipe-back where supported.

