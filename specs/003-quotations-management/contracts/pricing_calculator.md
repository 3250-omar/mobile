# Contract: PricingCalculator

```dart
/// Pure deterministic financial calculation utility operating strictly in integer minor units (piastres).
class PricingCalculator {
  const PricingCalculator();

  /// Calculates a single line total: (unitPricePiastres * quantity) - lineDiscountPiastres.
  /// Cannot be negative.
  int calculateLineTotal({
    required int unitPricePiastres,
    required int quantity,
    int lineDiscountPiastres = 0,
  });

  /// Computes the subtotal sum of a list of line totals.
  int calculateSubtotal(List<int> lineTotals);

  /// Computes a percentage-based discount with half-up integer rounding:
  /// (subtotalPiastres * basisPoints + 5000) ~/ 10000.
  int calculatePercentDiscount({
    required int subtotalPiastres,
    required int basisPoints, // e.g. 5% = 500
  });

  /// Computes the grand total: subtotal - effectiveDiscount + tax.
  /// Effective discount is clamped to never exceed subtotal.
  int calculateGrandTotal({
    required int subtotalPiastres,
    required int discountPiastres,
    int taxPiastres = 0,
  });
}
```
