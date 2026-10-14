import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/invoices/data/pdf_invoice_generator.dart';
import 'package:offline_quotes/features/invoices/domain/invoice.dart';
import 'package:offline_quotes/features/settings/domain/business_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DefaultPdfInvoiceGenerator', () {
    late DefaultPdfInvoiceGenerator generator;

    setUp(() {
      generator = DefaultPdfInvoiceGenerator();
    });

    test('generates valid A4 PDF bytes starting with %PDF- header', () async {
      final invoice = Invoice(
        id: 1,
        referenceNumber: 'INV-2026-0001',
        customerName: 'شركة النيل للتجارة',
        customerPhone: '01012345678',
        status: InvoiceStatus.partiallyPaid,
        issueDate: DateTime(2026, 10, 13),
        dueDate: DateTime(2026, 11, 13),
        notes: 'الدفع عند التوريد',
        subtotalPiastres: 25000,
        discountPiastres: 1000,
        taxPiastres: 3360,
        grandTotalPiastres: 27360,
        paidAmountPiastres: 10000,
        items: const [
          InvoiceItem(
            id: 1,
            invoiceId: 1,
            productCode: 'VAL-01',
            productName: 'محبس نحاس 1 بوصة',
            unit: 'قطعة',
            unitPricePiastres: 12500,
            quantity: 2,
            lineTotalPiastres: 25000,
          ),
        ],
        payments: [
          InvoicePayment(
            id: 1,
            invoiceId: 1,
            amountPiastres: 10000,
            paymentMethod: PaymentMethod.cash,
            paymentDate: DateTime(2026, 10, 13),
            notes: 'دفعة أولى',
            createdAt: DateTime(2026, 10, 13),
          ),
        ],
        createdAt: DateTime(2026, 10, 13),
        updatedAt: DateTime(2026, 10, 13),
      );

      final bytes = await generator.generateInvoicePdf(
        invoice: invoice,
        isThermalReceipt: false,
      );

      expect(bytes, isNotEmpty);
      // PDF documents start with %PDF- header (ASCII)
      final header = ascii.decode(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('generates valid 80mm thermal receipt bytes', () async {
      final invoice = Invoice(
        id: 2,
        referenceNumber: 'INV-2026-0002',
        customerName: 'عميل نقدي',
        status: InvoiceStatus.paid,
        issueDate: DateTime(2026, 10, 13),
        subtotalPiastres: 5000,
        grandTotalPiastres: 5000,
        paidAmountPiastres: 5000,
        items: const [
          InvoiceItem(
            id: 1,
            invoiceId: 2,
            productCode: 'ELB-20',
            productName: 'كوع بولي',
            unit: 'قطعة',
            unitPricePiastres: 2500,
            quantity: 2,
            lineTotalPiastres: 5000,
          ),
        ],
        createdAt: DateTime(2026, 10, 13),
        updatedAt: DateTime(2026, 10, 13),
      );

      final bytes = await generator.generateInvoicePdf(
        invoice: invoice,
        isThermalReceipt: true,
      );

      expect(bytes, isNotEmpty);
      final header = ascii.decode(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test(
      'generates valid A4 PDF with business profile and legal footer terms',
      () async {
        final invoice = Invoice(
          id: 3,
          referenceNumber: 'INV-2026-0003',
          customerName: 'مقاولات السلام',
          customerPhone: '01011112222',
          status: InvoiceStatus.unpaid,
          issueDate: DateTime(2026, 10, 14),
          subtotalPiastres: 50000,
          grandTotalPiastres: 50000,
          items: const [
            InvoiceItem(
              id: 1,
              invoiceId: 3,
              productCode: 'P-1',
              productName: 'ماسورة 1 بوصة',
              unit: 'متر',
              unitPricePiastres: 5000,
              quantity: 10,
              lineTotalPiastres: 50000,
            ),
          ],
          createdAt: DateTime(2026, 10, 14),
          updatedAt: DateTime(2026, 10, 14),
        );

        final profile = BusinessProfile(
          id: 1,
          businessName: 'مؤسسة السلام لمهمات السباكة',
          phonePrimary: '01012345678',
          city: 'المنصورة',
          taxNumber: '123-456',
          commercialRegister: '7890',
          defaultInvoiceTerms: 'البضاعة المباعة ترد خلال 14 يوماً',
          updatedAt: DateTime(2026, 10, 14),
        );

        final bytes = await generator.generateInvoicePdf(
          invoice: invoice,
          businessProfile: profile,
        );

        expect(bytes, isNotEmpty);
        final header = ascii.decode(bytes.sublist(0, 5));
        expect(header, equals('%PDF-'));
        expect(bytes.length, greaterThan(2000));
      },
    );
  });
}
