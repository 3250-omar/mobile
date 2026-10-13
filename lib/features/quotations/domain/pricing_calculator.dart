/// Pure deterministic financial calculation utility operating strictly in integer minor units (piastres).
/// Enforces Constitution Principle V: zero floating-point arithmetic for financial totals.
class PricingCalculator {
  const PricingCalculator();

  /// Calculates a single line total: `(unitPricePiastres * quantity) - lineDiscountPiastres`.
  /// Clamped to never be negative.
  int calculateLineTotal({
    required int unitPricePiastres,
    required int quantity,
    int lineDiscountPiastres = 0,
  }) {
    if (quantity <= 0 || unitPricePiastres <= 0) return 0;
    final gross = unitPricePiastres * quantity;
    final net = gross - (lineDiscountPiastres > 0 ? lineDiscountPiastres : 0);
    return net > 0 ? net : 0;
  }

  /// Calculates subtotal as sum of line item totals.
  int calculateSubtotal(List<int> lineTotals) {
    return lineTotals.fold(0, (acc, item) => acc + (item > 0 ? item : 0));
  }

  /// Calculates percentage-based discount with half-up integer rounding:
  /// `(subtotalPiastres * basisPoints + 5000) ~/ 10000`.
  /// 1% = 100 basis points; 5.5% = 550 basis points.
  int calculatePercentDiscount({
    required int subtotalPiastres,
    required int basisPoints,
  }) {
    if (subtotalPiastres <= 0 || basisPoints <= 0) return 0;
    final discount = (subtotalPiastres * basisPoints + 5000) ~/ 10000;
    return discount > subtotalPiastres ? subtotalPiastres : discount;
  }

  /// Computes grand total: `subtotal - effectiveDiscount + effectiveTax`.
  /// Effective discount is clamped so the total before tax cannot be negative.
  int calculateGrandTotal({
    required int subtotalPiastres,
    required int discountPiastres,
    int taxPiastres = 0,
  }) {
    if (subtotalPiastres <= 0) return taxPiastres > 0 ? taxPiastres : 0;
    final clampedDiscount = discountPiastres > subtotalPiastres
        ? subtotalPiastres
        : (discountPiastres < 0 ? 0 : discountPiastres);
    final clampedTax = taxPiastres < 0 ? 0 : taxPiastres;
    return (subtotalPiastres - clampedDiscount) + clampedTax;
  }
}
