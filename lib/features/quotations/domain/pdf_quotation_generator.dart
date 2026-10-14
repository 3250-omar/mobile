import 'dart:typed_data';

import '../../settings/domain/business_profile.dart';
import 'quotation.dart';

/// Contract for generating 100% offline Arabic PDF quotations.
abstract class PdfQuotationGenerator {
  /// Generates offline Arabic PDF document bytes for the specified quotation.
  Future<Uint8List> generateQuotationPdf({
    required Quotation quotation,
    BusinessProfile? businessProfile,
  });
}
