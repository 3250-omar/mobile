# Research & Technical Decisions: Quotations Management & Pricing Engine (003)

## 1. Deterministic Minor-Unit Financial Arithmetic

### Problem
Financial totals in Arabic quotations (e.g. plumbing orders with 50+ lines, unit prices with piastre fractions, and overall percent or fixed discounts) can drift by cents when binary `double` floats are multiplied and rounded unpredictably.

### Decision
- Store and compute all currency values as integer piastres (`int` in Dart, mapped to 64-bit integer in SQLite).
- 1 Egyptian Pound (EGP / ج.م) = 100 Piastres (قروش).
- For percentage discounts (e.g., 5.5%):
  $$\text{discount\_piastres} = \left\lfloor \frac{\text{subtotal\_piastres} \times \text{discount\_basis\_points} + 5000}{10000} \right\rfloor$$
  where basis points = percentage $\times 100$ (e.g., $5.5\% = 550$ bps).
- Half-up integer rounding ensures identical calculation across platforms without float inaccuracies.
- Formatting for display: integer division `piastres ~/ 100` for pounds and remainder `(piastres.abs() % 100).toString().padLeft(2, '0')` for piastres.

---

## 2. Relational Schema & Historical Snapshotting

### Problem
If a plumbing supplier changes the catalog price of "كوع 20 مم" next week from 12.50 to 18.00 EGP, or deletes an obsolete SKU, previously created and sent quotations must NOT silently recalculate or crash with broken foreign keys (Constitution Principle IV).

### Decision
- Database has two tables:
  1. `quotations`: header record with customer info, date, status, notes, subtotal, discount, tax, total.
  2. `quotation_items`: line items referencing `quotation_id` with foreign key `ON DELETE CASCADE`.
- Line items store both an optional `product_id` (nullable, so deleted products do not break FK) and frozen snapshot fields:
  - `product_code_snapshot`: String
  - `product_name_snapshot`: String
  - `unit_snapshot`: String
  - `unit_price_piastres`: int
  - `quantity`: int (or scaled decimal if fractions needed)
  - `discount_piastres`: int (line-level discount)
  - `line_total_piastres`: int
- Ad-hoc / custom items have `product_id = null` and store their user-provided title, unit, and price directly in the snapshot fields.
- When quotation is finalized (`accepted`), the record is locked from modification.

---

## 3. Human-Readable Quotation Reference Numbering

### Decision
- Sequential yearly format: `QT-YYYY-####` (e.g., `QT-2026-0001`, `QT-2026-0002`).
- Generated atomically by inspecting the highest sequence number for the current calendar year.
- Easy to communicate verbally over the phone to Arabic-speaking contractors.

---

## 4. Quotation Lifecycle State Machine

```text
[ draft ] ---------> [ sent ] ---------> [ accepted ] (Finalized Snapshot)
    |                   |                     |
    |                   v                     v
    +------------> [ rejected ]      [ converted_to_invoice ] (Feature 004)
```

- `draft`: Fully editable; items can be added, modified, or removed.
- `sent`: Communicated to client; editable until accepted.
- `accepted`: Approved by client; editing is locked to preserve legal snapshot.
- `rejected`: Declined by client; kept for sales history and audit.
- `converted_to_invoice`: Flagged for conversion in upcoming Feature 004.
