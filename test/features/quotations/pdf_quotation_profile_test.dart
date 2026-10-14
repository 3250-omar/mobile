import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/quotations/data/pdf_quotation_generator.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';
import 'package:offline_quotes/features/settings/domain/business_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DefaultPdfQuotationGenerator generator;
  late Quotation sampleQuotation;
  late BusinessProfile sampleProfile;

  setUp(() {
    generator = DefaultPdfQuotationGenerator();

    sampleQuotation = Quotation(
      id: 1,
      referenceNumber: 'QT-20261014-001',
      customerName: 'المهندس طارق السعدني',
      customerPhone: '01012345678',
      status: QuotationStatus.sent,
      subtotalPiastres: 150000,
      discountPiastres: 5000,
      taxPiastres: 0,
      grandTotalPiastres: 145000,
      items: const [
        QuotationItem(
          id: 1,
          quotationId: 1,
          productCode: 'K-20',
          productName: 'كوع 20 مم بولي بروبلين',
          quantity: 10,
          unit: 'قطعة',
          unitPricePiastres: 10000,
          lineTotalPiastres: 100000,
        ),
        QuotationItem(
          id: 2,
          quotationId: 1,
          productCode: 'M-20',
          productName: 'محبس دفن 20 مم إيطالي',
          quantity: 1,
          unit: 'قطعة',
          unitPricePiastres: 50000,
          lineTotalPiastres: 50000,
        ),
      ],
      issueDate: DateTime(2026, 10, 14),
      createdAt: DateTime(2026, 10, 14),
      updatedAt: DateTime(2026, 10, 14),
    );

    sampleProfile = BusinessProfile(
      id: 1,
      businessName: 'مؤسسة الشروق لمهمات السباكة',
      ownerName: 'الحاج إبراهيم',
      phonePrimary: '01099998888',
      phoneSecondary: '01233334444',
      address: 'شارع البحر',
      city: 'المنصورة',
      taxNumber: '123-456-789',
      commercialRegister: '98765',
      defaultQuotationNotes: 'الأسعار سارية لمدة أسبوع من تاريخ إصدار العرض',
      updatedAt: DateTime(2026, 10, 14),
    );
  });

  group('DefaultPdfQuotationGenerator Tests', () {
    test(
      'generates valid PDF bytes without business profile (fallback)',
      () async {
        final bytes = await generator.generateQuotationPdf(
          quotation: sampleQuotation,
        );

        expect(bytes, isNotEmpty);
        // PDF documents start with %PDF header bytes
        expect(String.fromCharCodes(bytes.take(5)), equals('%PDF-'));
      },
    );

    test(
      'generates valid PDF bytes with full business profile branding',
      () async {
        final bytes = await generator.generateQuotationPdf(
          quotation: sampleQuotation,
          businessProfile: sampleProfile,
        );

        expect(bytes, isNotEmpty);
        expect(String.fromCharCodes(bytes.take(5)), equals('%PDF-'));
        // Verifies document size reflects content
        expect(bytes.length, greaterThan(2000));
      },
    );
  });
}
