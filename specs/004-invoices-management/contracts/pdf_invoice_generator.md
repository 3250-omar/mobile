# Contract: PdfInvoiceGenerator

```dart
import 'dart:typed_data';

abstract class PdfInvoiceGenerator {
  /// Generates 100% offline Arabic PDF document bytes for an invoice.
  Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    bool isThermalReceipt = false,
  });
}
```
