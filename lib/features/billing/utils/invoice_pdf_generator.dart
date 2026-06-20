import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';

class InvoicePdfGenerator {
  Future<void> generateAndShare(
    Invoice invoice, {
    String? propertyName,
    String? unitName,
  }) async {
    final pdfData = await _generatePdf(
      invoice,
      propertyName: propertyName,
      unitName: unitName,
    );
    final monthYearSafe = invoice.monthYear
        .replaceAll(' ', '_')
        .replaceAll('/', '_');
    final displayNum = invoice.invoiceNumber.isNotEmpty
        ? invoice.invoiceNumber
        : invoice.id.substring(0, 6);
    final filename = 'invoice_${displayNum}_$monthYearSafe.pdf';
    await Printing.sharePdf(bytes: pdfData, filename: filename);
  }

  Future<void> generateAndPrint(
    Invoice invoice, {
    String? propertyName,
    String? unitName,
  }) async {
    final pdfData = await _generatePdf(
      invoice,
      propertyName: propertyName,
      unitName: unitName,
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  Future<Uint8List> _generatePdf(
    Invoice invoice, {
    String? propertyName,
    String? unitName,
  }) async {
    final doc = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');

    // Load Outfit font
    final outfitRegular = await PdfGoogleFonts.outfitRegular();
    final outfitBold = await PdfGoogleFonts.outfitBold();
    final outfitSemiBold = await PdfGoogleFonts.outfitMedium();
    final baseStyle = pw.TextStyle(font: outfitRegular, fontSize: 10);
    final greyStyle = pw.TextStyle(
      font: outfitRegular,
      color: PdfColors.grey600,
      fontSize: 9,
    );

    final primaryColor = PdfColor.fromHex('#6366F1');
    final lightPurple = PdfColor.fromHex('#EEF2FF');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── HEADER ────────────────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Left: INVOICE label + invoice id
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          font: outfitBold,
                          fontSize: 28,
                          color: primaryColor,
                          letterSpacing: 2,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        '#${invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : invoice.id.substring(0, 6)}',
                        style: pw.TextStyle(
                          font: outfitRegular,
                          fontSize: 11,
                          color: PdfColors.grey500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  // Right: App info block
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Barivara',
                        style: pw.TextStyle(
                          font: outfitBold,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        invoice.monthYear,
                        style: pw.TextStyle(
                          font: outfitSemiBold,
                          fontSize: 12,
                          color: PdfColors.grey800,
                        ),
                      ),
                      if (propertyName != null)
                        pw.Text(
                          propertyName,
                          style: greyStyle.copyWith(fontSize: 9),
                        ),
                      if (unitName != null)
                        pw.Text(
                          unitName,
                          style: greyStyle.copyWith(fontSize: 9),
                        ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),
              pw.Divider(thickness: 1.5, color: primaryColor),
              pw.SizedBox(height: 12),

              // ── BILL TO / STATUS ─────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BILL TO',
                        style: pw.TextStyle(
                          font: outfitBold,
                          fontSize: 9,
                          color: PdfColors.grey600,
                          letterSpacing: 1,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        invoice.renterName ?? 'Tenant',
                        style: pw.TextStyle(font: outfitBold, fontSize: 14),
                      ),
                      pw.Text(
                        'Unit: ${unitName ?? invoice.unitId}',
                        style: greyStyle,
                      ),
                      pw.Text(
                        'Generated: ${invoice.createdAt != null ? dateFormat.format(invoice.createdAt!) : dateFormat.format(DateTime.now())}',
                        style: greyStyle,
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'STATUS',
                        style: pw.TextStyle(
                          font: outfitBold,
                          fontSize: 9,
                          color: PdfColors.grey600,
                          letterSpacing: 1,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: invoice.status.toLowerCase() == 'paid'
                              ? PdfColors.green50
                              : PdfColors.red50,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          invoice.status.toUpperCase(),
                          style: pw.TextStyle(
                            font: outfitBold,
                            fontSize: 11,
                            color: invoice.status.toLowerCase() == 'paid'
                                ? PdfColors.green700
                                : PdfColors.red700,
                          ),
                        ),
                      ),
                      if (invoice.paidAt != null)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            'Paid: ${dateFormat.format(invoice.paidAt!)}',
                            style: greyStyle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // ── BREAKDOWN TABLE ───────────────────────────────────────
              pw.Text(
                'BILLING BREAKDOWN',
                style: pw.TextStyle(
                  font: outfitBold,
                  fontSize: 9,
                  color: PdfColors.grey600,
                  letterSpacing: 1,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder(
                  bottom: pw.BorderSide(color: PdfColors.grey300),
                  horizontalInside: pw.BorderSide(color: PdfColors.grey200),
                ),
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: lightPurple),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: pw.Text(
                          'Description',
                          style: pw.TextStyle(font: outfitBold, fontSize: 10),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: pw.Text(
                          'Amount',
                          style: pw.TextStyle(font: outfitBold, fontSize: 10),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  // Base Rent
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: pw.Text('Base Rent', style: baseStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: pw.Text(
                          '${invoice.baseRent} TK',
                          style: baseStyle,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  // Utilities
                  ...invoice.utilities.entries.map(
                    (e) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: pw.Text(
                            e.key[0].toUpperCase() + e.key.substring(1),
                            style: baseStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: pw.Text(
                            '${e.value} TK',
                            style: baseStyle,
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Other charges
                  if (invoice.otherCharges > 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: pw.Text('Other Charges', style: baseStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: pw.Text(
                            '${invoice.otherCharges} TK',
                            style: baseStyle,
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 12),

              // ── TOTAL ─────────────────────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: pw.BoxDecoration(
                      color: lightPurple,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'TOTAL:  ',
                          style: pw.TextStyle(
                            font: outfitBold,
                            fontSize: 12,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.Text(
                          '${invoice.totalAmount} TK',
                          style: pw.TextStyle(
                            font: outfitBold,
                            fontSize: 20,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // ── FOOTER ────────────────────────────────────────────────
              pw.Divider(color: PdfColors.grey300, thickness: 0.5),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Computer-generated document · No signature required',
                  style: greyStyle.copyWith(fontSize: 8),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'Thank you for using Barivara!',
                  style: pw.TextStyle(
                    font: outfitBold,
                    fontSize: 10,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }
}
