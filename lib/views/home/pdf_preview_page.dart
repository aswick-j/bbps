import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'pdf_generate.dart';

class PdfPreviewPage extends StatefulWidget {
  Map<String, dynamic> transactionReceiptData;
  PdfPreviewPage({Key? key, required this.transactionReceiptData})
      : super(key: key);

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.transactionReceiptData['pdf_file_name'].toString(),
        name: "AT PDF generate :: 2 :::");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: primaryColor,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: txtColor,
          ),
        ),
        title: appText(
          data: "Transaction Receipt",
          size: width(context) * 0.05,
          weight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      body: PdfPreview(
        allowPrinting: true,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: widget.transactionReceiptData['pdf_file_name'],
        initialPageFormat: PdfPageFormat.a4,
        // scrollViewDecoration: BoxDecoration(
        //   // color: primaryColor,
        //   boxShadow: <BoxShadow>[
        //     BoxShadow(
        //       offset: Offset(0, 3),
        //       blurRadius: 5,
        //       color: Colors.red,
        //     ),
        //   ],
        // ),
        // pdfPreviewPageDecoration: BoxDecoration(
        //   color: primaryColor,
        //   boxShadow: <BoxShadow>[
        //     BoxShadow(
        //       offset: Offset(0, 3),
        //       blurRadius: 5,
        //       color: Colors.red,
        //     ),
        //   ],
        // ),
        build: (context) => makePdf(widget.transactionReceiptData),
      ),
    );
  }
}
