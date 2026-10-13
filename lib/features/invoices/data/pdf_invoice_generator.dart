import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/invoice.dart';
import '../domain/pdf_invoice_generator.dart';

/// 100% Offline Arabic PDF Invoice & Receipt generator.
/// Operates strictly without internet connectivity using bundled fonts and offline QR codes.
class DefaultPdfInvoiceGenerator implements PdfInvoiceGenerator {
  DefaultPdfInvoiceGenerator({this.regularFontBytes, this.boldFontBytes});

  final Uint8List? regularFontBytes;
  final Uint8List? boldFontBytes;

  @override
  Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    bool isThermalReceipt = false,
  }) async {
    final regularFont = await _loadRegularFont();
    final boldFont = await _loadBoldFont();

    final pdf = pw.Document(
      title: 'فاتورة ${invoice.referenceNumber}',
      author: 'Offline Quotes App',
    );

    final theme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
      fontFallback: [pw.Font.helvetica()],
    );

    final pageFormat = isThermalReceipt
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            double.infinity,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a4;

    final qrData =
        'INV:${invoice.referenceNumber}|DATE:${invoice.issueDate.toIso8601String()}|TOTAL:${invoice.grandTotalPiastres}|PAID:${invoice.paidAmountPiastres}|BAL:${invoice.remainingBalancePiastres}';

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        textDirection: pw.TextDirection.rtl,
        theme: theme,
        build: (pw.Context context) {
          if (isThermalReceipt) {
            return _buildThermalReceipt(invoice, qrData);
          }
          return _buildA4Invoice(invoice, qrData);
        },
      ),
    );

    return pdf.save();
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

  pw.Widget _buildA4Invoice(Invoice invoice, String qrData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Header
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'فاتورة مبيعات ضريبية',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'رقم الفاتورة: ${invoice.referenceNumber}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(
                  'تاريخ الإصدار: ${invoice.issueDate.year}-${invoice.issueDate.month.toString().padLeft(2, '0')}-${invoice.issueDate.day.toString().padLeft(2, '0')}',
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
                if (invoice.dueDate != null)
                  pw.Text(
                    'تاريخ الاستحقاق: ${invoice.dueDate!.year}-${invoice.dueDate!.month.toString().padLeft(2, '0')}-${invoice.dueDate!.day.toString().padLeft(2, '0')}',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _getStatusColor(invoice.status),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                invoice.status.arabicLabel,
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 10),

        // Customer details
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'بيانات العميل',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'الاسم: ${invoice.customerName}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  if (invoice.customerPhone != null &&
                      invoice.customerPhone!.isNotEmpty)
                    pw.Text(
                      'الهاتف: ${invoice.customerPhone}',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 16),

        // Line Items Table
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey800,
          ),
          cellAlignment: pw.Alignment.centerRight,
          cellStyle: const pw.TextStyle(fontSize: 10),
          headers: [
            'م',
            'كود الصنف',
            'اسم الصنف',
            'الوحدة',
            'الكمية',
            'سعر الوحدة',
            'الإجمالي',
          ],
          data: [
            for (var i = 0; i < invoice.items.length; i++)
              [
                (i + 1).toString(),
                invoice.items[i].productCode,
                invoice.items[i].productName,
                invoice.items[i].unit,
                invoice.items[i].quantity.toString(),
                '${invoice.items[i].formattedUnitPriceEgp} ج.م',
                '${invoice.items[i].formattedLineTotalEgp} ج.م',
              ],
          ],
        ),
        pw.SizedBox(height: 16),

        // Financial Summary & QR Code
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // QR Code for offline verification
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: qrData,
                  width: 80,
                  height: 80,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'رمز التحقق دون اتصال',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),

            // Financial totals
            pw.Container(
              width: 220,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                children: [
                  _buildSummaryRow(
                    'المجموع الفرعي:',
                    '${invoice.formattedSubtotalEgp} ج.م',
                  ),
                  if (invoice.discountPiastres > 0)
                    _buildSummaryRow(
                      'الخصم:',
                      '- ${invoice.formattedDiscountEgp} ج.م',
                      color: PdfColors.red700,
                    ),
                  if (invoice.taxPiastres > 0)
                    _buildSummaryRow(
                      'ضريبة القيمة المضافة:',
                      '+ ${invoice.taxPiastres ~/ 100}.${(invoice.taxPiastres % 100).toString().padLeft(2, '0')} ج.م',
                    ),
                  pw.Divider(color: PdfColors.grey300),
                  _buildSummaryRow(
                    'الإجمالي الكلي:',
                    '${invoice.formattedGrandTotalEgp} ج.م',
                    isBold: true,
                  ),
                  _buildSummaryRow(
                    'المبلغ المسدد:',
                    '${invoice.formattedPaidAmountEgp} ج.م',
                    color: PdfColors.green800,
                  ),
                  _buildSummaryRow(
                    'المتبقي:',
                    '${invoice.formattedRemainingBalanceEgp} ج.م',
                    isBold: true,
                    color: PdfColors.red800,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Payments History Section
        if (invoice.payments.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          pw.Text(
            'سجل الدفعات المستلمة',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey200, width: 0.5),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              color: PdfColors.grey800,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellAlignment: pw.Alignment.centerRight,
            cellStyle: const pw.TextStyle(fontSize: 9),
            headers: ['التاريخ', 'طريقة الدفع', 'المبلغ', 'ملاحظات'],
            data: [
              for (final p in invoice.payments)
                [
                  '${p.paymentDate.year}-${p.paymentDate.month.toString().padLeft(2, '0')}-${p.paymentDate.day.toString().padLeft(2, '0')}',
                  p.paymentMethod.arabicLabel,
                  '${p.formattedAmountEgp} ج.م',
                  p.notes ?? '-',
                ],
            ],
          ),
        ],

        // Notes
        if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          pw.Text(
            'ملاحظات: ${invoice.notes}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],

        pw.Spacer(),
        pw.Divider(color: PdfColors.grey300),
        pw.Center(
          child: pw.Text(
            'شكراً لتعاملكم معنا - تم إصدار هذه الفاتورة إلكترونياً بدون اتصال بالإنترنت',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildThermalReceipt(Invoice invoice, String qrData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Center(
          child: pw.Text(
            'إيصال مبيعات',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Center(
          child: pw.Text(
            invoice.referenceNumber,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'العميل: ${invoice.customerName}',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          'التاريخ: ${invoice.issueDate.year}-${invoice.issueDate.month.toString().padLeft(2, '0')}-${invoice.issueDate.day.toString().padLeft(2, '0')}',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Divider(color: PdfColors.black, thickness: 0.5),

        // Items
        for (final item in invoice.items)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    '${item.productName} (${item.quantity} ${item.unit})',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Text(
                  '${item.formattedLineTotalEgp} ج.م',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),

        pw.Divider(color: PdfColors.black, thickness: 0.5),

        // Totals
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'الإجمالي:',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${invoice.formattedGrandTotalEgp} ج.م',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('المدفوع:', style: const pw.TextStyle(fontSize: 9)),
            pw.Text(
              '${invoice.formattedPaidAmountEgp} ج.م',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'المتبقي:',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${invoice.formattedRemainingBalanceEgp} ج.م',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: qrData,
            width: 60,
            height: 60,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            'شكراً لزيارتكم',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  PdfColor _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return PdfColors.green700;
      case InvoiceStatus.partiallyPaid:
        return PdfColors.orange700;
      case InvoiceStatus.unpaid:
        return PdfColors.blue700;
      case InvoiceStatus.cancelled:
        return PdfColors.red700;
    }
  }
}
