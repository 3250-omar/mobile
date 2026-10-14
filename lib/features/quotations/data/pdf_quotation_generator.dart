import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/localization/bidi_text.dart';
import '../../settings/domain/business_profile.dart';
import '../domain/pdf_quotation_generator.dart';
import '../domain/quotation.dart';

/// 100% Offline Arabic PDF Quotation generator.
/// Operates strictly without internet connectivity using bundled fonts and offline QR code.
class DefaultPdfQuotationGenerator implements PdfQuotationGenerator {
  DefaultPdfQuotationGenerator({this.regularFontBytes, this.boldFontBytes});

  final Uint8List? regularFontBytes;
  final Uint8List? boldFontBytes;

  @override
  Future<Uint8List> generateQuotationPdf({
    required Quotation quotation,
    BusinessProfile? businessProfile,
  }) async {
    final regularFont = await _loadRegularFont();
    final boldFont = await _loadBoldFont();

    final pdf = pw.Document(
      title: 'عرض سعر ${quotation.referenceNumber}',
      author: businessProfile?.businessName ?? 'تسعيرة',
    );

    final theme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
      fontFallback: [pw.Font.helvetica()],
    );

    // Load store logo if available
    pw.MemoryImage? logoImage;
    if (businessProfile?.logoPath != null) {
      try {
        final logoFile = File(businessProfile!.logoPath!);
        if (await logoFile.exists()) {
          final bytes = await logoFile.readAsBytes();
          logoImage = pw.MemoryImage(bytes);
        }
      } catch (_) {}
    }

    final qrData =
        'QUOTE:${quotation.referenceNumber}|DATE:${quotation.issueDate.toIso8601String()}|TOTAL:${quotation.grandTotalPiastres}|ITEMS:${quotation.items.length}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // 1. Merchant Business Header
              _buildMerchantHeader(businessProfile, logoImage),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.blueGrey200, thickness: 1.5),
              pw.SizedBox(height: 10),

              // 2. Quotation Title & Meta Bar
              _buildQuotationMeta(quotation),
              pw.SizedBox(height: 12),

              // 3. Customer Info Box
              _buildCustomerBox(quotation),
              pw.SizedBox(height: 14),

              // 4. Quotation Items Table
              _buildItemsTable(quotation),
              pw.SizedBox(height: 14),

              // 5. Totals & Verification QR
              _buildTotalsAndQr(quotation, qrData),
              pw.SizedBox(height: 16),

              // 6. Notes & Terms
              _buildNotesSection(quotation, businessProfile),
              pw.Spacer(),

              // 7. Footer
              _buildDocumentFooter(businessProfile),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildMerchantHeader(
    BusinessProfile? profile,
    pw.MemoryImage? logoImage,
  ) {
    final storeName = profile?.businessName.isNotEmpty == true
        ? profile!.businessName
        : 'تسعيرة للأدوات الصحية والسباكة';

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                storeName,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                ),
              ),
              if (profile?.ownerName != null &&
                  profile!.ownerName!.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  'بإدارة: ${profile.ownerName!}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              pw.SizedBox(height: 4),
              if (profile?.phonePrimary.isNotEmpty == true)
                pw.Text(
                  'هاتف: ${BidiText.wrapLtr(profile!.phonePrimary)}${profile.phoneSecondary != null && profile.phoneSecondary!.isNotEmpty ? ' • واتساب: ${BidiText.wrapLtr(profile.phoneSecondary!)}' : ''}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey800,
                  ),
                ),
              if (profile?.address != null || profile?.city != null)
                pw.Text(
                  [
                    if (profile?.city != null && profile!.city!.isNotEmpty)
                      profile.city,
                    if (profile?.address != null &&
                        profile!.address!.isNotEmpty)
                      profile.address,
                  ].join(' - '),
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              if (profile?.hasTaxCredentials == true) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  [
                    if (profile?.commercialRegister != null &&
                        profile!.commercialRegister!.isNotEmpty)
                      'س.ت: ${BidiText.wrapLtr(profile.commercialRegister!)}',
                    if (profile?.taxNumber != null &&
                        profile!.taxNumber!.isNotEmpty)
                      'ب.ض: ${BidiText.wrapLtr(profile.taxNumber!)}',
                  ].join(' | '),
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.blueGrey700,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (logoImage != null)
          pw.Container(
            width: 55,
            height: 55,
            margin: const pw.EdgeInsets.only(right: 8),
            child: pw.Image(logoImage, fit: pw.BoxFit.contain),
          ),
      ],
    );
  }

  pw.Widget _buildQuotationMeta(Quotation quotation) {
    final statusColor = switch (quotation.status) {
      QuotationStatus.accepted => PdfColors.green700,
      QuotationStatus.rejected => PdfColors.red700,
      QuotationStatus.sent => PdfColors.blue700,
      QuotationStatus.draft => PdfColors.grey700,
      QuotationStatus.convertedToInvoice => PdfColors.teal700,
    };

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'عرض أسعار طلبية',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'رقم العرض: ${quotation.referenceNumber}',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                color: statusColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                quotation.status.arabicLabel,
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 10),
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'تاريخ العرض: ${quotation.issueDate.year}/${quotation.issueDate.month.toString().padLeft(2, '0')}/${quotation.issueDate.day.toString().padLeft(2, '0')}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCustomerBox(Quotation quotation) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'المطلوب من السيد: ${quotation.customerName}',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          if (quotation.customerPhone != null &&
              quotation.customerPhone!.isNotEmpty)
            pw.Text(
              'هاتف: ${BidiText.wrapLtr(quotation.customerPhone!)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(Quotation quotation) {
    final headers = [
      'م',
      'كود الصنف',
      'اسم الصنف والمواصفات',
      'الكمية',
      'الوحدة',
      'السعر',
      'الإجمالي',
    ];

    final rows = <List<String>>[];
    for (int i = 0; i < quotation.items.length; i++) {
      final item = quotation.items[i];
      rows.add([
        '${i + 1}',
        item.productCode,
        item.productName,
        item.quantity.toString(),
        item.unit,
        '${item.formattedUnitPriceEgp} ج.م',
        '${item.formattedLineTotalEgp} ج.م',
      ]);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
    );
  }

  pw.Widget _buildTotalsAndQr(Quotation quotation, String qrData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.BarcodeWidget(
          barcode: pw.Barcode.qrCode(),
          data: qrData,
          width: 55,
          height: 55,
        ),
        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Column(
            children: [
              _buildSummaryRow(
                'الإجمالي الفرعي:',
                '${quotation.formattedSubtotalEgp} ج.م',
              ),
              if (quotation.discountPiastres > 0) ...[
                pw.SizedBox(height: 3),
                _buildSummaryRow(
                  'الخصم:',
                  '- ${quotation.formattedDiscountEgp} ج.م',
                  color: PdfColors.red700,
                ),
              ],
              if (quotation.taxPiastres > 0) ...[
                pw.SizedBox(height: 3),
                _buildSummaryRow(
                  'ضريبة القيمة المضافة:',
                  '+ ${quotation.formattedTaxEgp} ج.م',
                ),
              ],
              pw.Divider(color: PdfColors.grey300),
              _buildSummaryRow(
                'الإجمالي النهائي:',
                '${quotation.formattedGrandTotalEgp} ج.م',
                isBold: true,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 10,
    PdfColor? color,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildNotesSection(Quotation quotation, BusinessProfile? profile) {
    final noteText =
        (quotation.notes != null && quotation.notes!.trim().isNotEmpty)
        ? quotation.notes!
        : profile?.defaultQuotationNotes;

    if (noteText == null || noteText.trim().isEmpty) {
      return pw.SizedBox();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملاحظات وشروط العرض:',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.brown800,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            noteText,
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.brown900),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDocumentFooter(BusinessProfile? profile) {
    return pw.Center(
      child: pw.Text(
        'حرر بواسطة تطبيق تسعيرة لإدارة مهمات وأدوات السباكة • 100% دون إنترنت',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
      ),
    );
  }

  Future<pw.Font> _loadRegularFont() async {
    if (regularFontBytes != null) {
      try {
        return pw.Font.ttf(regularFontBytes!.buffer.asByteData());
      } catch (_) {
        return pw.Font.helvetica();
      }
    }
    try {
      final data = await rootBundle.load(
        'assets/fonts/NotoSansArabic-Regular.ttf',
      );
      return pw.Font.ttf(data);
    } catch (_) {
      return pw.Font.helvetica();
    }
  }

  Future<pw.Font> _loadBoldFont() async {
    if (boldFontBytes != null) {
      try {
        return pw.Font.ttf(boldFontBytes!.buffer.asByteData());
      } catch (_) {
        return pw.Font.helveticaBold();
      }
    }
    try {
      final data = await rootBundle.load(
        'assets/fonts/NotoSansArabic-Bold.ttf',
      );
      return pw.Font.ttf(data);
    } catch (_) {
      return pw.Font.helveticaBold();
    }
  }
}
