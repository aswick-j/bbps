import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(Map<String, dynamic> pdfData) async {
  final ByteData bytes =
      await rootBundle.load('assets/images/be_assured_logo.png');
  Uint8List byteList = bytes.buffer.asUint8List();
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Image(pw.MemoryImage(byteList), height: 70, width: 70),
              ],
            ),
            pw.Row(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: pw.Text(
                    'BBPS - Payment Confirmation',
                    style: pw.TextStyle(
                      fontSize: 17.0,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("5519bb"),
                    ),
                  ),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 20.0),
                  child: pw.Text(
                    'Thank you. We have received your payment. Please quote your\nTransaction Reference ID for any queries for the below payment',
                    style: pw.TextStyle(
                      fontSize: 12.0,
                      color: PdfColor.fromHex("5519bb"),
                    ),
                  ),
                ),
              ],
            ),
            pw.Table.fromTextArray(
                context: context,
                headers: <dynamic>['Transaction Details'],
                rowDecoration:
                    pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),
                data: <List>[
                  [
                    'Name of the Biller',
                    pdfData['biller_name'],
                  ],
                  [
                    'Biller Id',
                    pdfData['biller_id'],
                  ],
                  // [
                  //   'Mobile Number',
                  //   widget.historyData!.mOBILENUMBER == null
                  //       ? "n/a"
                  //       : widget.historyData!.mOBILENUMBER.toString(),
                  // ],
                  [
                    'Mobile Number',
                    pdfData['mobile_number'],
                  ],
                  ['Bill Number', pdfData['bill_number']],
                  [
                    'Transaction Reference Id',
                    pdfData['transaction_reference_id']
                  ],
                  [
                    'CBS Transaction Ref Number',
                    pdfData['cbs_transaction_ref_number']
                  ],
                  [
                    'Registered Mobile Number',
                    pdfData['registered_mobile_number']
                  ],
                  [
                    'Payment Mode',
                    pdfData['payment_mode'],
                  ],
                  [
                    'Payment Channel ',
                    pdfData['payment_channel'],
                  ],
                  [
                    'Amount Debited From',
                    pdfData['amount_debited_from'],
                  ],
                  [
                    'Bill Amount',
                    pdfData['bill_amount'],
                  ],
                  [
                    'Customer Convenience Fee',
                    pdfData['customer_convenience_fee'],
                  ],
                  [
                    'Total Amount',
                    pdfData['total_amount'],
                  ],
                  [
                    'Transaction Date and Time',
                    pdfData['transaction_date_and_time'],
                  ],
                  [
                    'Status',
                    pdfData['status'],
                  ],
                ]),
          ],
        ); // Center
      }));

  return pdf.save();
}
