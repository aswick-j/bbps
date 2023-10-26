import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../model/history_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

// ignore: must_be_immutable
class TransactionDetails extends StatelessWidget {
  HistoryData? historyData;
  TransactionDetails({super.key, required this.historyData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TransactionDetailsUI(
      historyData: historyData,
    ));
  }
}

class TransactionDetailsUI extends StatefulWidget {
  HistoryData? historyData;
  TransactionDetailsUI({super.key, required this.historyData});

  @override
  State<TransactionDetailsUI> createState() => _TransactionDetailsUIState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _TransactionDetailsUIState extends State<TransactionDetailsUI> {
  String dlTime = "";
  //Temporary Path for testing
  List<dynamic> decodedTokenAccounts = [];
  String accountMobileNumber = "";

  Directory dir = Directory("/storage/emulated/0/Download");
  bool? permissionGranted;
  NumberFormat rupeeFormat = NumberFormat.currency(locale: "en_IN", name: '');
  NumberFormat rupeeFormatWithSymbol =
      NumberFormat.currency(locale: "en_IN", symbol: '₹', name: '');

  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // final AndroidInitializationSettings _androidInitializationSettings =
  //     const AndroidInitializationSettings('mipmap/ic_launcher');

  // void initialseNotifications() async {
  //   InitializationSettings initializationSettings =
  //       InitializationSettings(android: _androidInitializationSettings);
  //   await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse: openFile);
  // }

  // openFile(NotificationResponse notificationResponse) async {
  //   await OpenFile.open(
  //       "${dir.path}/${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
  // }

  // void sendNotification(String title, String body) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //       const AndroidNotificationDetails('channelId', 'channelName',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           ticker: 'ticker');

  //   NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );

  //   await _flutterLocalNotificationsPlugin.show(
  //       0, title, body, notificationDetails);
  // }

  helperFunc() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    logConsole(decodedToken.toString(), "at helperFunc :: TRANSACTION_DETAILS");

    setState(() {
      accountMobileNumber = decodedToken['mobileNumber'];
      decodedTokenAccounts = decodedToken['accounts'];
    });
    logConsole(
        accountMobileNumber.toString(), "HERERE  accountMobileNumber *******");

    logConsole(
        decodedTokenAccounts.toString(), "HERERE decodedTokenAccounts *******");
  }

  @override
  void initState() {
    logConsole(
        jsonEncode(widget.historyData).toString(), "TRANSACTION_DETAILS PAGE");
    helperFunc();
    logConsole(jsonEncode(myAccounts).toString(), "AT TRANSACTION_DETAILS");
    super.initState();
    // askPermission();

    // initialseNotifications();
  }

  Future<bool?> checkPermissionAndFolder() async {
    // if (Platform.isAndroid) {
    //   dir = Directory('/storage/emulated/0/$_folder');
    // } else {}

    if (Platform.isAndroid) {
      if ((await dir.exists())) {
        // return dir.path;
      } else {
        dir.create();
        // return dir.path;
      }
    }
    if (Platform.isIOS) {
      Directory path = await getApplicationDocumentsDirectory();
      dir = path;
    }

    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
    return permissionGranted;
  }

  // askPermission() async {
  //   directory = await getExternalStorageDirectory();

  //   Map<Permission, PermissionStatus> permissionStatus = await [
  //     Permission.storage,
  //   ].request();
  // }

  detail(context, title, content) {
    return SizedBox(
      height: height(context) * 0.07,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
              data: title,
              size: width(context) * 0.04,
              color: txtSecondaryColor),
          appText(
              data: content,
              size: width(context) * 0.04,
              color: txtPrimaryColor,
              weight: FontWeight.w600),
        ],
      ),
    );
  }

  final iconImage = Image.asset(bbSvg);

  iosPdfGenerate() {
    final _dltime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      dlTime = _dltime.toString();
    });
    var billAmount = double.parse(widget.historyData!.bILLAMOUNT == null
        ? "0"
        : widget.historyData!.bILLAMOUNT.toString());
    var feeAmount = double.parse(widget.historyData!.fEE == null
        ? "0"
        : widget.historyData!.fEE.toString());

    var totalAmount = billAmount + feeAmount;

    Map<String, dynamic> transactionReceiptData = {
      "pdf_file_name":
          "${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf",
      "bill_amount_calculated": billAmount,
      "fee_amount": feeAmount,
      "total_amount_calculated": totalAmount,
      "biller_name": widget.historyData!.bILLERNAME.toString(),
      "biller_id": widget.historyData!.bILLERID.toString(),
      "mobile_number": accountMobileNumber ?? "-",
      "bill_number": widget.historyData!.bILLNUMBER == null ||
              widget.historyData!.cATEGORYNAME == "Mobile Prepaid"
          ? "-"
          : widget.historyData!.bILLNUMBER.toString(),
      "transaction_reference_id":
          widget.historyData!.tRANSACTIONREFERENCEID == null
              ? "-"
              : widget.historyData!.tRANSACTIONREFERENCEID.toString(),
      "cbs_transaction_ref_number":
          widget.historyData!.eQUITASTRANSACTIONID == null
              ? "-"
              : widget.historyData!.eQUITASTRANSACTIONID.toString(),
      "registered_mobile_number": widget.historyData!.mOBILENUMBER == null
          ? "-"
          : widget.historyData!.mOBILENUMBER.toString(),
      "payment_mode": widget.historyData!.pAYMENTMODE == null
          ? "-"
          : widget.historyData!.pAYMENTMODE.toString(),
      "payment_channel": widget.historyData!.pAYMENTCHANNEL.toString(),
      "amount_debited_from": widget.historyData!.aCCOUNTNUMBER.toString(),
      "bill_amount": rupeeFormat
          .format(double.parse(widget.historyData!.bILLAMOUNT.toString())),
      "customer_convenience_fee": widget.historyData?.fEE != null
          ? widget.historyData!.fEE!.toString() == "0"
              ? 0
              : rupeeFormat
                  .format(double.parse(widget.historyData!.fEE.toString()))
          : "-",
      "total_amount": rupeeFormat
          .format(double.parse(widget.historyData!.bILLAMOUNT.toString())),
      "transaction_date_and_time": DateFormat("EEEE, d MMMM, y h:mm a")
          .format(DateTime.parse(widget.historyData!.cOMPLETIONDATE.toString())
              .toLocal())
          .toString(),
      "status": widget.historyData!.tRANSACTIONSTATUS!
                  .toLowerCase()
                  .contains("bbps-timeout") ||
              widget.historyData!.tRANSACTIONSTATUS!
                  .toLowerCase()
                  .contains("bbps-in-progress")
          ? "PENDING"
          : widget.historyData!.tRANSACTIONSTATUS!
                  .toString()
                  .toLowerCase()
                  .contains("success")
              ? "SUCCESS"
              : "FAILURE",
      "reason": getTransactionReason(
          widget.historyData!.tRANSACTIONSTATUS!.toString()),
      "categotyName": widget.historyData!.cATEGORYNAME
    };
    goToData(context, pdfPreviewPageRoute, {"data": transactionReceiptData});
  }

  Future writeOnPdf() async {
    final ByteData bytes = await rootBundle.load(bbpsAssuredLogo);
    Uint8List byteList = bytes.buffer.asUint8List();
    final pdf = pw.Document();
    inspect(pdf);

    var billAmount = double.parse(widget.historyData!.bILLAMOUNT == null
        ? "0"
        : widget.historyData!.bILLAMOUNT.toString());
    var feeAmount = double.parse(widget.historyData!.fEE == null
        ? "0"
        : widget.historyData!.fEE.toString());

    var totalAmount = billAmount + feeAmount;

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
                      widget.historyData!.bILLERNAME.toString(),
                    ],
                    [
                      'Biller Id',
                      widget.historyData!.bILLERID.toString(),
                    ],
                    // [
                    //   'Mobile Number',
                    //   widget.historyData!.mOBILENUMBER == null
                    //       ? "n/a"
                    //       : widget.historyData!.mOBILENUMBER.toString(),
                    // ],
                    ['Mobile Number', accountMobileNumber ?? "-"],
                    [
                      'Bill Number',
                      widget.historyData!.bILLNUMBER == null ||
                              widget.historyData!.cATEGORYNAME ==
                                  "Mobile Prepaid"
                          ? "-"
                          : widget.historyData!.bILLNUMBER.toString(),
                    ],
                    [
                      'Transaction Reference Id',
                      widget.historyData!.tRANSACTIONREFERENCEID == null
                          ? "-"
                          : widget.historyData!.tRANSACTIONREFERENCEID
                              .toString(),
                    ],
                    [
                      'CBS Transaction Ref Number',
                      widget.historyData!.eQUITASTRANSACTIONID == null
                          ? "-"
                          : widget.historyData!.eQUITASTRANSACTIONID.toString(),
                    ],
                    [
                      'Registered Mobile Number',
                      widget.historyData!.mOBILENUMBER == null
                          ? "-"
                          : widget.historyData!.mOBILENUMBER.toString(),
                    ],
                    [
                      'Payment Mode',
                      widget.historyData!.pAYMENTMODE == null
                          ? "-"
                          : widget.historyData!.pAYMENTMODE.toString(),
                    ],
                    [
                      'Payment Channel ',
                      widget.historyData!.pAYMENTCHANNEL.toString(),
                    ],
                    [
                      'Amount Debited From',
                      widget.historyData!.aCCOUNTNUMBER.toString(),
                    ],
                    [
                      'Bill Amount',
                      rupeeFormat.format(double.parse(
                          widget.historyData!.bILLAMOUNT.toString()))
                    ],
                    [
                      'Customer Convenience Fee',
                      // double.parse(widget.historyData!.fEE!
                      //             .toLowerCase()
                      //             .toString()) ==
                      //         0
                      //     ? "-"
                      //     : NumberFormat('#,##,##0.00').format(
                      //         double.parse(widget.historyData!.fEE.toString())),

                      widget.historyData?.fEE != null
                          ? widget.historyData!.fEE!.toString() == "0"
                              ? 0
                              : rupeeFormat.format(double.parse(
                                  widget.historyData!.fEE.toString()))
                          : "-",
                    ],
                    [
                      'Total Amount',
                      rupeeFormat.format(double.parse(
                          widget.historyData!.bILLAMOUNT.toString())),
                    ],
                    [
                      'Transaction Date and Time',
                      DateFormat("EEEE, d MMMM, y h:mm a")
                          .format(DateTime.parse(
                                  widget.historyData!.cOMPLETIONDATE.toString())
                              .toLocal())
                          .toString()
                      // DateFormat('dd MMM yyyy - h:mm a').format(DateTime.parse(
                      //         widget.historyData!.cOMPLETIONDATE.toString())
                      //     .toLocal()),
                    ],
                    [
                      'Status',
                      widget.historyData!.tRANSACTIONSTATUS!
                              .toLowerCase()
                              .contains("bbps-timeout")
                          ? "PENDING"
                          : widget.historyData!.tRANSACTIONSTATUS!
                                  .toString()
                                  .toLowerCase()
                                  .contains("success")
                              ? "SUCCESS"
                              : "FAILURE",
                    ],
                    if (widget.historyData!.tRANSACTIONSTATUS!
                            .toString()
                            .toLowerCase() !=
                        "success")
                      [
                        'Reason',
                        getTransactionReason(
                            widget.historyData!.tRANSACTIONSTATUS!.toString())
                      ]
                  ]),
            ],
          ); // Center
        }));

    final file = File(
        "${dir.path}/${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
    // file.writeAsBytesSync(await pdf.save());

    debugPrint("DOCUMENT SAVED");
    file.writeAsBytes(await pdf.save(), mode: FileMode.append);

    logConsole(
        "${dir.path}/${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf",
        "FILE PATH ::");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: myAppBar(
        context: context,
        backgroundColor: primaryColor,
        title: 'Transaction Details',
        bottom: PreferredSize(
          preferredSize: Size(width(context), 8.0),
          child: Container(
            width: width(context),
            color: primaryBodyColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: primaryColor,
            height: height(context) * 0.10,
          ),
          Column(
            children: [
              Container(
                height: height(context) / 1.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: txtColor,
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.040,
                    vertical: width(context) * 0.020),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width(context) * 0.040),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detail(
                                context,
                                "Bill Amount",
                                rupeeFormatWithSymbol.format(double.parse(
                                    widget.historyData!.bILLAMOUNT.toString()))
                                // "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData!.bILLAMOUNT.toString()))}",
                                ),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Biller Name",
                                widget.historyData!.bILLERNAME),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Biller ID",
                                widget.historyData!.bILLERID.toString()),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(
                                context,
                                "Bill Number",
                                widget.historyData!.bILLNUMBER == null ||
                                        widget.historyData!.cATEGORYNAME ==
                                            "Mobile Prepaid"
                                    ? "-"
                                    : widget.historyData!.bILLNUMBER
                                        .toString()),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(
                                context,
                                "Date",
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                        widget.historyData!.cOMPLETIONDATE
                                            .toString())
                                    .toLocal())),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(
                                context,
                                "Transaction Reference ID",
                                widget.historyData!.tRANSACTIONREFERENCEID ??
                                    "n/a"),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Debited From",
                                widget.historyData!.aCCOUNTNUMBER.toString()),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(
                                context,
                                "Payment Mode",
                                widget.historyData!.pAYMENTMODE == null
                                    ? "n/a"
                                    : widget.historyData!.pAYMENTMODE
                                        .toString()),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Payment Channel",
                                widget.historyData!.pAYMENTCHANNEL.toString()),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            SizedBox(
                              height: height(context) * 0.07,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                      data: "Status",
                                      size: width(context) * 0.04,
                                      color: txtSecondaryColor),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 2.2),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: widget.historyData!
                                                  .tRANSACTIONSTATUS ==
                                              'success'
                                          ? alertSuccessColor.withOpacity(0.1)
                                          : alertFailedColor.withOpacity(0.1),
                                    ),
                                    child: appText(
                                        data: widget.historyData!
                                                    .tRANSACTIONSTATUS ==
                                                'success'
                                            ? "Successful"
                                            : widget.historyData!
                                                        .tRANSACTIONSTATUS ==
                                                    'bbps-timeout'
                                                ? "Pending"
                                                : "Failed",
                                        size: width(context) * 0.04,
                                        color: widget.historyData!
                                                    .tRANSACTIONSTATUS ==
                                                'success'
                                            ? alertSuccessColor
                                            : widget.historyData!
                                                        .tRANSACTIONSTATUS ==
                                                    'bbps-timeout'
                                                ? alertPendingColor
                                                : alertFailedColor,
                                        weight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.historyData!.tRANSACTIONSTATUS!
                                    .toString()
                                    .toLowerCase() !=
                                "success")
                              Divider(
                                thickness: 1,
                                color: divideColor,
                              ),
                            if (widget.historyData!.tRANSACTIONSTATUS!
                                    .toString()
                                    .toLowerCase() !=
                                "success")
                              SizedBox(
                                height: height(context) * 0.07,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(
                                        data: "Reason",
                                        size: width(context) * 0.04,
                                        color: txtSecondaryColor),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 11, vertical: 2.2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        color: widget.historyData!
                                                        .tRANSACTIONSTATUS ==
                                                    'bbps-timeout' ||
                                                widget.historyData!
                                                        .tRANSACTIONSTATUS ==
                                                    'bbps-in-progress'
                                            ? alertPendingColor.withOpacity(0.1)
                                            : alertFailedColor.withOpacity(0.1),
                                      ),
                                      child: appText(
                                          data: getTransactionReason(widget
                                              .historyData!.tRANSACTIONSTATUS!
                                              .toString()),
                                          color: widget.historyData!
                                                          .tRANSACTIONSTATUS ==
                                                      'bbps-timeout' ||
                                                  widget.historyData!
                                                          .tRANSACTIONSTATUS ==
                                                      'bbps-in-progress'
                                              ? alertPendingColor
                                              : alertFailedColor,
                                          weight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(top: height(context) * 0.03, bottom: 16),
                  child: myAppButton(
                    context: context,
                    buttonName: "Download",
                    onpress: () async {
                      {
                        if (Platform.isIOS) {
                          iosPdfGenerate();
                        } else {
                          checkPermissionAndFolder().then((value) async {
                            final _dltime =
                                DateTime.now().millisecondsSinceEpoch;
                            setState(() {
                              dlTime = _dltime.toString();
                            });
                            if (value == true) {
                              File file = File(
                                  '${dir.path}/${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf"');

                              if (!await file.exists()) {
                                await writeOnPdf();
                                // await savePdf();
                                await OpenFile.open(
                                    "${dir.path}/${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                // sendNotification("Download Completed",
                                //     "${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
                              } else {
                                debugPrint("already exist");
                              }
                            }
                          });
                        }
                      }
                    },
                    margin: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.044,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
