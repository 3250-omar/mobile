import 'dart:typed_data';

import '../../settings/domain/business_profile.dart';
import 'invoice.dart';

/// Contract for generating 100% offline Arabic PDF invoices and receipts.
abstract class PdfInvoiceGenerator {
  /// Generates offline Arabic PDF document bytes for the specified invoice.
  Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    BusinessProfile? businessProfile,
    bool isThermalReceipt = false,
  });
}
