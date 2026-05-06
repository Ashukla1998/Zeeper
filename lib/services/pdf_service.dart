import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/bill_model.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class PdfService {
  static Future<File> generateBill({
    required String shopName,
    required String customerName,
    required List<BillItem> items,
    required double total,
  }) async {
    final ByteData bytes = await rootBundle.load('assets/icon/zeeper.png');

    final Uint8List logoBytes = bytes.buffer.asUint8List();

    final logoImage = pw.MemoryImage(logoBytes);
    // CREATE PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,

        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              // TITLE
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                children: [
                  pw.Text(
                    "ZEEPER BILL",

                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Container(
                    width: 100,
                    height: 100,

                    child: pw.Image(logoImage),
                  ),
                ],
              ),

              pw.Container(height: 20),

              // SHOP INFO
              pw.Text(
                "Shop Name: $shopName",

                style: const pw.TextStyle(fontSize: 16),
              ),

              pw.Container(height: 6),

              pw.Text(
                "Customer Name: $customerName",

                style: const pw.TextStyle(fontSize: 16),
              ),

              pw.Container(height: 6),

              pw.Text(
                "Date: ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now())}",

                style: const pw.TextStyle(fontSize: 16),
              ),

              pw.Container(height: 20),

              // TABLE
              pw.Table(
                border: pw.TableBorder.all(),

                children: [
                  // HEADER
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),

                    children: [
                      tableCell("Item"),

                      tableCell("Qty"),

                      tableCell("Rate"),

                      tableCell("Amount"),
                    ],
                  ),

                  // ITEM ROWS
                  ...items.map((item) {
                    return pw.TableRow(
                      children: [
                        tableCell(item.item),

                        tableCell(item.qty.toString()),

                        tableCell(item.rate.toStringAsFixed(2)),

                        tableCell(item.amount.toStringAsFixed(2)),
                      ],
                    );
                  }).toList(),
                ],
              ),

              pw.Container(height: 20),

              // TOTAL
              pw.Align(
                alignment: pw.Alignment.centerRight,

                child: pw.Text(
                  "TOTAL: Rs. ${total.toStringAsFixed(2)}",

                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Spacer(),

              // FOOTER
              pw.Center(
                child: pw.Text(
                  "Thank You For Your Purchase!",

                  style: const pw.TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );

    // APP DOCUMENT DIRECTORY
    final dir = await getApplicationDocumentsDirectory();

    // FILE NAME
    final file = File(
      "${dir.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );

    // SAVE PDF
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // TABLE CELL
  static pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),

      child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
    );
  }
}
