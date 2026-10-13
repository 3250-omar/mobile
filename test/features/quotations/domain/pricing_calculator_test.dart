import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/quotations/domain/pricing_calculator.dart';

void main() {
  group('PricingCalculator Deterministic Financial Tests', () {
    const calc = PricingCalculator();

    test('calculates line total accurately in integer piastres', () {
      // 5 items @ 12.50 EGP (1250 piastres)
      final lineTotal = calc.calculateLineTotal(
        unitPricePiastres: 1250,
        quantity: 5,
      );
      expect(lineTotal, 6250); // 62.50 EGP
    });

    test('applies line discount without allowing negative total', () {
      // 2 items @ 50.00 EGP (5000 piastres) = 10000 piastres with 15.00 EGP discount (1500 piastres)
      final normalDiscount = calc.calculateLineTotal(
        unitPricePiastres: 5000,
        quantity: 2,
        lineDiscountPiastres: 1500,
      );
      expect(normalDiscount, 8500); // 85.00 EGP

      // Discount exceeding gross price clamps to 0
      final excessDiscount = calc.calculateLineTotal(
        unitPricePiastres: 1000,
        quantity: 1,
        lineDiscountPiastres: 5000,
      );
      expect(excessDiscount, 0);
    });

    test('sums subtotal accurately across multiple lines', () {
      final subtotal = calc.calculateSubtotal([6250, 8500, 13000]);
      expect(subtotal, 27750); // 277.50 EGP
    });

    test('calculates percentage discount using half-up integer rounding', () {
      // 100.00 EGP (10000 piastres) with 5% discount (500 basis points) = 500 piastres
      expect(
        calc.calculatePercentDiscount(
          subtotalPiastres: 10000,
          basisPoints: 500,
        ),
        500,
      );

      // Fractional rounding test:
      // 123.45 EGP (12345 piastres) with 5.5% (550 basis points)
      // 12345 * 550 = 6789750
      // (6789750 + 5000) ~/ 10000 = 679 piastres (6.79 EGP)
      expect(
        calc.calculatePercentDiscount(
          subtotalPiastres: 12345,
          basisPoints: 550,
        ),
        679,
      );
    });

    test('calculates grand total with discount clamping and tax addition', () {
      // Subtotal 200.00 EGP (20000 piastres), discount 25.00 EGP (2500 piastres), tax 14% (2800 piastres)
      final grandTotal = calc.calculateGrandTotal(
        subtotalPiastres: 20000,
        discountPiastres: 2500,
        taxPiastres: 2800,
      );
      // (20000 - 2500) + 2800 = 20300 piastres (203.00 EGP)
      expect(grandTotal, 20300);

      // Discount exceeding subtotal is clamped
      final clampedTotal = calc.calculateGrandTotal(
        subtotalPiastres: 10000,
        discountPiastres: 15000,
      );
      expect(clampedTotal, 0);
    });
  });
}
