import 'dart:typed_data';

import 'invoice.dart';

/// Contract for generating 100% offline Arabic PDF invoices and receipts.
abstract class PdfInvoiceGenerator {
  /// Generates offline Arabic PDF document bytes for the specified invoice.
  Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    bool isThermalReceipt = false,
  });
}
