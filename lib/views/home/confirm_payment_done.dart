import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/biller_model.dart';
import '../../model/confirm_done_model.dart';
import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class ConfirmPaymentDone extends StatefulWidget {
  dynamic tnxData;
  ConfirmPaymentDone({
    Key? key,
    required this.tnxData,
  }) : super(key: key);

  @override
  _ConfirmPaymentDoneState createState() => _ConfirmPaymentDoneState();
}

class _ConfirmPaymentDoneState extends State<ConfirmPaymentDone> {
  confirmDoneData? tnxResponse;
  bool isMobilePrepaid = false;
  SavedBillersData? savedBillerData;
  Map<String, dynamic>? billerTypeResult;
  Map<String, dynamic>? paymentDetails;
  BillersData? billerData;
  String dlTime = "";
  var billData;
  //Temporary Path for testing
  Directory dir = Directory("/storage/emulated/0/Download");
  bool? permissionGranted;
  List<dynamic> decodedTokenAccounts = [];
  String accountMobileNumber = "";
  NumberFormat rupeeFormat = NumberFormat.currency(locale: "en_IN", name: '');
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
  //       "${dir.path}/${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf");
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

  iosPdfGenerate() {
    final _dltime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      dlTime = _dltime.toString();
    });
    Map<String, dynamic> transactionReceiptData = {
      "pdf_file_name":
          "${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf",
      "biller_name": isSavedBillFrom
          ? savedBillerData!.bILLERNAME
          : billerData!.bILLERNAME,
      "biller_id":
          isSavedBillFrom ? savedBillerData!.bILLERID : billerData!.bILLERID,
      "mobile_number": accountMobileNumber ?? "-",
      "bill_number": isSavedBillFrom && !isMobilePrepaid
          ? savedBillerData!.pARAMETERS![0].pARAMETERVALUE.toString()
          : isSavedBillFrom && isMobilePrepaid
              // ? savedBillerData!.pARAMETERS!
              //     .firstWhere(
              //       (param) =>
              //           param.pARAMETERNAME.toString().toLowerCase() ==
              //           'mobile number',
              //     )
              //     .pARAMETERVALUE
              ? "-"
              : !isSavedBillFrom && isMobilePrepaid
                  // ? widget.tnxData['inputSignature']!
                  //     .firstWhere(
                  //       (param) =>
                  //           param.pARAMETERNAME.toString().toLowerCase() ==
                  //           'mobile number',
                  //     )
                  //     .pARAMETERVALUE
                  ? "-"
                  : widget.tnxData['inputSignature'][0].pARAMETERVALUE,
      "transaction_reference_id":
          tnxResponse!.paymentDetails?.toJson().length != null
              ? paymentDetails!['txnReferenceId'].toString()
              : "-",
      "cbs_transaction_ref_number":
          tnxResponse!.paymentDetails?.toJson().length != null
              ? paymentDetails!['cbsTransactionReferenceId'].toString()
              : "-",
      "registered_mobile_number":
          tnxResponse!.paymentDetails?.toJson().length != null
              ? paymentDetails!['mobileNumber'].toString()
              : "-",
      "payment_mode": tnxResponse!.paymentDetails?.toJson().length != null
          ? paymentDetails!['paymentMode']
          : '-',
      "payment_channel": tnxResponse!.paymentDetails?.toJson().length != null
          ? paymentDetails!['paymentChannel'] == "MB"
              ? paymentDetails!['paymentChannel']
              : "MB"
          : '-',
      "amount_debited_from": widget.tnxData['acNo'].toString(),
      "bill_amount":
          rupeeFormat.format(double.parse(widget.tnxData['billAmount'])),
      "customer_convenience_fee":
          tnxResponse!.paymentDetails?.toJson().length != null
              ? paymentDetails!['fee'] == 0
                  ? 0
                  : rupeeFormat.format(paymentDetails!['fee'])
              : "-",
      "total_amount":
          rupeeFormat.format(double.parse(widget.tnxData['billAmount'])),
      "transaction_date_and_time":
          tnxResponse!.paymentDetails?.toJson().length != null
              ? DateFormat("EEEE, d MMMM, y h:mm a")
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(paymentDetails!['paymentDate'])))
                  .toString()
              : DateFormat("EEEE, d MMMM, y h:mm a")
                  .format(DateTime.now())
                  .toString(),
      "status": tnxResponse!.paymentDetails?.toJson().length != null
          ? paymentDetails!['success']
              ? "SUCCESS"
              : paymentDetails!['bbpsTimeout']
                  ? "Pending"
                  : "FAILURE"
          : "FAILURE",
    };
    goToData(context, pdfPreviewPageRoute, {"data": transactionReceiptData});
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

  @override
  void initState() {
    tnxResponse = confirmDoneData.fromJson(widget.tnxData['res']);
    billData = jsonDecode(tnxResponse!.paymentDetails!.tran!.bill.toString());
    // inspect(jsonEncode(widget.tnxData['savedBiller']));
    print("Confrim payment done ==========>");
    inspect(widget.tnxData);
    inspect(tnxResponse);
    if (widget.tnxData['isMobilePrepaid'] == null ||
        widget.tnxData['isMobilePrepaid'] == false) {
      setState(() {
        isMobilePrepaid = false;
      });
    } else {
      setState(() {
        isMobilePrepaid = true;
      });
    }
    if (isSavedBillFrom) {
      log("isSavedBillFrom :: TRUE");
      savedBillerData = widget.tnxData['billerData'];
      billerTypeResult = getBillerType(
          savedBillerData!.fETCHREQUIREMENT,
          savedBillerData!.bILLERACCEPTSADHOC,
          savedBillerData!.sUPPORTBILLVALIDATION,
          savedBillerData!.pAYMENTEXACTNESS);
    } else {
      log("isSavedBillFrom :: FALSE");

      billerData = widget.tnxData['billerData'];
      billerTypeResult = getBillerType(
          billerData!.fETCHREQUIREMENT,
          billerData!.bILLERACCEPTSADHOC,
          billerData!.sUPPORTBILLVALIDATION,
          billerData!.pAYMENTEXACTNESS);
    }

    paymentDetails = getBillPaymentDetails(tnxResponse!.paymentDetails,
        billerTypeResult!['isAdhoc'], tnxResponse!.equitasTransactionId);
    helperFunc();

    super.initState();

    // initialseNotifications();
    if (paymentDetails!['success'] && isSavedBillFrom && !isMobilePrepaidFrom)
      deleteUpcomingDue();
  }

  helperFunc() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    log(decodedToken.toString(), name: "at helperFunc :: TRANSACTION_DETAILS");

    setState(() {
      accountMobileNumber = decodedToken['mobileNumber'];
      decodedTokenAccounts = decodedToken['accounts'];
    });
    log(accountMobileNumber.toString(),
        name: "HERERE  accountMobileNumber *******");

    log(decodedTokenAccounts.toString(),
        name: "HERERE decodedTokenAccounts *******");
  }

  @override
  void dispose() {
    isSavedBillFrom = true;
    isMobilePrepaidFrom = false;
    super.dispose();
  }

  void deleteUpcomingDue() {
    BlocProvider.of<HomeCubit>(context)
        .deleteUpcomingDue(savedBillerData!.cUSTOMERBILLID);
  }

  final iconImage = Image.asset(bbSvg);
  List<AllConfigurations>? autoPayData = [];
  AllConfigurationsData? _autoPaydata;
  Future writeOnPdf() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/be_assured_logo.png');
    Uint8List byteList = bytes.buffer.asUint8List();
    final pdf = pw.Document();
    inspect(pdf);
    print("DOCUMENT GENERATED");
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
                      isSavedBillFrom
                          ? savedBillerData!.bILLERNAME
                          : billerData!.bILLERNAME,
                    ],
                    [
                      'Biller Id',
                      isSavedBillFrom
                          ? savedBillerData!.bILLERID
                          : billerData!.bILLERID,
                    ],
                    [
                      'Mobile Number',
                      // paymentDetails!['mobileNumber'].toString(),
                      accountMobileNumber ?? "-"
                    ],
                    [
                      'Bill Number',
                      // billData['data']['BillerResponse']['billNumber']
                      //     .toString(),
                      /* isSavedBillFrom
                          ? savedBillerData!.pARAMETERS![0].pARAMETERVALUE
                              .toString()
                          : isMobilePrepaid
                              ? widget
                                  .tnxData['inputSignature'][0].pARAMETERVALUE
                              : widget.tnxData['inputSignature'][0]
                                  ['PARAMETER_VALUE'], */

                      isSavedBillFrom && !isMobilePrepaid
                          ? savedBillerData!.pARAMETERS![0].pARAMETERVALUE
                              .toString()
                          : isSavedBillFrom && isMobilePrepaid
                              // ? savedBillerData!.pARAMETERS!
                              //     .firstWhere(
                              //       (param) =>
                              //           param.pARAMETERNAME
                              //               .toString()
                              //               .toLowerCase() ==
                              //           'mobile number',
                              //     )
                              //     .pARAMETERVALUE
                              ? "-"
                              : !isSavedBillFrom && isMobilePrepaid
                                  // ? widget.tnxData['inputSignature']!
                                  //     .firstWhere(
                                  //       (param) =>
                                  //           param.pARAMETERNAME
                                  //               .toString()
                                  //               .toLowerCase() ==
                                  //           'mobile number',
                                  //     )
                                  //     .pARAMETERVALUE
                                  ? "-"
                                  : widget.tnxData['inputSignature'][0]
                                      .pARAMETERVALUE,
                    ],
                    [
                      'Transaction Reference Id',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['txnReferenceId'].toString()
                          : "-",
                    ],
                    [
                      'CBS Transaction Ref Number',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['cbsTransactionReferenceId']
                              .toString()
                          : "-",
                    ],
                    [
                      'Registered Mobile Number',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['mobileNumber'].toString()
                          : "-",
                    ],
                    [
                      'Payment Mode',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['paymentMode']
                          : '-'
                      // paymentDetails!['paymentMode'].toString(),
                    ],
                    [
                      'Payment Channel ',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['paymentChannel'] == "MB"
                              ? paymentDetails!['paymentChannel']
                              : "MB"
                          : '-'
                      // paymentDetails!['paymentChannel'].toString(),
                    ],
                    [
                      'Amount Debited From',
                      widget.tnxData['acNo'].toString(),
                    ],
                    [
                      'Bill Amount',
                      rupeeFormat
                          .format(double.parse(widget.tnxData['billAmount']))
                      // double.parse(widget.tnxData['billAmount'])
                      //     .toStringAsFixed(2)
                      //     .toString()
                    ],
                    [
                      'Customer Convenience Fee ',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['fee'] == 0
                              ? 0
                              : rupeeFormat.format(paymentDetails!['fee'])
                          : "-"
                    ],
                    [
                      'Total Amount',
                      rupeeFormat
                          .format(double.parse(widget.tnxData['billAmount']))
                      // double.parse(widget.tnxData['billAmount'])
                      //     .toStringAsFixed(2)
                      //     .toString()
                    ],
                    [
                      'Transaction Date and Time',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? DateFormat("EEEE, d MMMM, y h:mm a")
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(paymentDetails!['paymentDate'])))
                              .toString()
                          : DateFormat("EEEE, d MMMM, y h:mm a")
                              .format(DateTime.now())
                              .toString(),
                      // paymentDetails!['success']
                      //     ?
                      // ? DateFormat.yMMMd()
                      //     .add_jm()
                      //     .format(DateTime.now())
                      //     .toString()
                      // : DateFormat.yMMMd()
                      //     .add_jm()
                      //     .format(DateTime.parse(
                      //         paymentDetails!['paymentDate']))
                      //     .toString(),
                    ],
                    [
                      // 'Status',
                      // paymentDetails!['success']
                      //     ? " Successfully Paid"
                      //     : paymentDetails!['bbpsTimeout']
                      //         ? "Transaction initiated. Please check status after some time."
                      //         : "Transaction Failed",

                      'Status',
                      tnxResponse!.paymentDetails?.toJson().length != null
                          ? paymentDetails!['success']
                              ? "SUCCESS"
                              : paymentDetails!['bbpsTimeout']
                                  ? "Pending"
                                  : "FAILURE"
                          : "FAILURE",
                    ],
                  ]),
            ],
          ); // Center
        }));

    final file = File(
        "${dir.path}/${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf");
    // file.writeAsBytesSync(await pdf.save());

    print("DOCUMENT SAVED");
    file.writeAsBytes(await pdf.save(), mode: FileMode.append);
  }

  amtText(text, size, colour) {
    return Text(
      text,
      style: TextStyle(
        color: colour,
        fontFamily: 'Rubik-Regular',
        fontSize: size,
      ),
    );
  }

  columnText(context, text1, text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width(context) / 1.6,
          child: Text(
            text1 ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: width(context) * 0.04,
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Rubik-Regular',
            ),
          ),
        ),
        SizedBox(
          width: width(context) / 1.6,
          child: Text(
            text2 ?? '-',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryColor,
              fontFamily: 'Rubik-Regular',
              fontSize: width(context) * 0.036,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: primaryBodyColor,
          body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
            if (state is AutoPayLoading) {
              if (!Loader.isShown) {
                showLoader(context);
              }
            } else if (state is AutopaySuccess) {
              autoPayData = state.autoScheduleData!.allConfigurations;
              inspect(autoPayData);
              if (Loader.isShown) {
                Loader.hide();
              }
              for (var i = 0; i < autoPayData!.length; i++) {
                _autoPaydata = autoPayData![i]
                    .data!
                    .where((element) =>
                        element.cUSTOMERBILLID ==
                        savedBillerData!.cUSTOMERBILLID)
                    .first;
                print(i.toString() + autoPayData!.length.toString());
                if (i + 1 == autoPayData!.length) {
                  print("_autoPaydata ====> ${jsonEncode(_autoPaydata)}");

                  if (_autoPaydata != null) {
                    goToData(context, autoPayEditRoute, {
                      "customerBillID": savedBillerData!.cUSTOMERBILLID,
                      "paidAmount": widget.tnxData['billAmount'],
                      "inputSignatures": widget.tnxData['inputSignature'],
                      "billName": _autoPaydata!.bILLNAME,
                      "billerName": _autoPaydata!.bILLERNAME,
                      "limit": "0"
                    });
                  }
                }
              }
            } else if (state is AutopayFailed) {
              showSnackBar(state.message, context);
            }
          }, builder: (context, state) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: paymentDetails!['success']
                          ? Image.asset("assets/images/clrpappers.png")
                          : Image.asset("assets/images//clrpappersfail.png"),
                    ),
                    Positioned(
                      top: height(context) * 0.025,
                      left: width(context) * 0.35,
                      child: paymentDetails!['success']
                          ? Image.asset("assets/images/tickmark.png")
                          : Image.asset("assets/images/icon_failur_png.png"),
                    ),
                    Positioned(
                      top: height(context) * 0.2,
                      // left: width(context) * 0.35,
                      child: Row(
                        children: [
                          amtText(
                            "$rupee ${double.parse(widget.tnxData['billAmount']).toStringAsFixed(2).toString()}",
                            width(context) * 0.12,
                            primaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height(context) * 0.05,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      paymentDetails!['success']
                          ? " Successfully Paid"
                          : paymentDetails!['bbpsTimeout']
                              ? "Transaction initiated. Please check status after some time."
                              : "Transaction Failed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: txtHintColor,
                        fontFamily: 'Rubik-Regular',
                        fontSize: width(context) * 0.055,
                      ),
                    ),
                  ),
                ),
                divideLine(),
                Padding(
                  padding: EdgeInsets.only(
                    left: width(context) * 0.04,
                    bottom: width(context) * 0.04,
                    top: width(context) * 0.02,
                  ),
                  child: Text(
                    "Paid to",
                    style: TextStyle(
                      fontFamily: 'Rubik-Regular',
                      fontSize: width(context) * 0.045,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: width(context) * 0.04,
                    right: width(context) * 0.04,
                  ),
                  padding: EdgeInsets.all(width(context) * 0.02),
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffE1E2F2),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: width(context) * 0.04,
                              left: width(context) * 0.02,
                            ),
                            child: CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              radius: width(context) * 0.08,
                              child: Image.asset(bNeumonic,
                                  height: height(context) * 0.06),
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.05,
                            child: columnText(
                                context,
                                isSavedBillFrom
                                    ? savedBillerData!.bILLERNAME
                                    : billerData!.bILLERNAME,
                                isSavedBillFrom
                                    ? savedBillerData!.bILLNAME
                                    : isMobilePrepaid &&
                                            widget.tnxData['billName'] ==
                                                "CHANGE_HERE"
                                        ? ""
                                        : widget.tnxData['billName']),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width(context) * 0.016, bottom: 0.0),
                        child: DottedLine(
                          dashColor: dashColor,
                        ),
                      ),
                      verticalSpacer(width(context) * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // BlocBuilder<HomeCubit, HomeState>(
                            //     builder: (context, state) {
                            //   if (state is AutoPayLoading) {
                            //     appText(
                            //         data: "Loading Autopay..",
                            //         size: width(context) * 0.04,
                            //         weight: FontWeight.bold,
                            //         color: Colors.white);
                            //   } else if (state is AutopaySuccess) {
                            //     autoPayData =
                            //         state.autoScheduleData!.allConfigurations;
                            //     inspect(autoPayData);

                            //     for (var i = 0; i < autoPayData!.length; i++) {
                            //       _autoPaydata = autoPayData![i]
                            //           .data!
                            //           .where((element) =>
                            //               element.cUSTOMERBILLID ==
                            //               savedBillerData!.cUSTOMERBILLID)
                            //           .first;
                            //     }
                            //     print("_autoPaydata ====>" +
                            //         jsonEncode(_autoPaydata));
                            //   }
                            //   return paymentDetails!['success']
                            //       ?

                            isSavedBillFrom && !isMobilePrepaidFrom
                                ? GestureDetector(
                                    onTap: !paymentDetails!['success']
                                        ? null
                                        : () {
                                            inspect(savedBillerData);

                                            goToData(
                                                context, setupAutoPayRoute, {
                                              "customerBillID": savedBillerData!
                                                  .cUSTOMERBILLID
                                                  .toString(),
                                              "paidAmount":
                                                  widget.tnxData['billAmount'],
                                              "inputSignatures":
                                                  savedBillerData!.pARAMETERS,
                                              "billname":
                                                  savedBillerData!.bILLNAME,
                                              "billername":
                                                  savedBillerData!.bILLERNAME,
                                              "limit": "0"
                                            });
                                            // BlocProvider.of<HomeCubit>(context)
                                            //     .getAutopay();
                                          },
                                    child: Container(
                                      width: width(context) / 2.3,
                                      padding: EdgeInsets.all(
                                          width(context) * 0.024),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: paymentDetails!['success']
                                              ? const Color(0xFFFF7F50)
                                              : const Color(0xFF9A9A9A)),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: appText(
                                            textAlign: TextAlign.center,
                                            data: "Setup Auto - Payment",
                                            size: width(context) * 0.033,
                                            weight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : !isSavedBillFrom && isMobilePrepaidFrom
                                    ? InkWell(
                                        onTap: () {
                                          goToData(context, addNewBill, {
                                            "billerData": billerDataTemp,
                                            "inputSignatureData":
                                                inputSignaturesModelTemp
                                          });
                                        },
                                        child: Text(
                                          'Save Biller for Future Payments',
                                          style: TextStyle(
                                            color: txtAmountColor,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (Platform.isIOS) {
                                            iosPdfGenerate();
                                          } else {
                                            checkPermissionAndFolder()
                                                .then((value) async {
                                              final _dltime = DateTime.now()
                                                  .millisecondsSinceEpoch;
                                              setState(() {
                                                dlTime = _dltime.toString();
                                              });
                                              if (value == true) {
                                                File file = File(
                                                    '${dir.path}/${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf"');

                                                if (!await file.exists()) {
                                                  await writeOnPdf();
                                                  // await savePdf();
                                                  await OpenFile.open(
                                                      "${dir.path}/${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                                  // sendNotification("Download Completed",
                                                  //     "${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                                } else {
                                                  print("already exist");
                                                }
                                                // if (await File(
                                                //         "${dir.path}/${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf")
                                                //     .exists()) {
                                                //   print("already exist");
                                                //   OpenFile.open(
                                                //       "${dir.path}/${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf");
                                                // } else {
                                                //   await writeOnPdf();
                                                //   // await savePdf();
                                                //   print("file created");
                                                //   sendNotification("Download Completed",
                                                //       "${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf");
                                                // }
                                              }
                                            });

                                            // if (permissionGranted == true) {
                                            //   File file = File(
                                            //       '${dir}/"${savedBillerData!.bILLERNAME}-${dlTime.toString()}.pdf"');

                                            //   if (!await file.exists()) {
                                            //     await writeOnPdf();
                                            //     // await savePdf();
                                            //     sendNotification("Download Completed",
                                            //         "${savedBillerData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                            //   } else {
                                            //     print("already exist");
                                            //   }
                                            // } else {
                                            //   customDialog(
                                            //       context: context,
                                            //       dialogHeight: height(context) / 3.2,
                                            //       iconHeight: height(context) * 0.1,
                                            //       message: "",
                                            //       message2: "",
                                            //       message3: "",
                                            //       title: "Storage Permission Not Granted",
                                            //       buttonName: "Okay",
                                            //       buttonAction: () {
                                            //         Navigator.pop(context);
                                            //       },
                                            //       iconSvg: alertSvg);
                                            // }
                                          }
                                        },
                                        child: Container(
                                          width: width(context) / 2.3,
                                          padding: EdgeInsets.all(
                                              width(context) * 0.024),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: const Color(0xFFFF7F50)),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: appText(
                                                textAlign: TextAlign.center,
                                                data: "Download Receipt",
                                                size: width(context) * 0.033,
                                                weight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                            IconButton(
                                onPressed: () async {
                                  if (Platform.isIOS) {
                                    iosPdfGenerate();
                                  } else {
                                    checkPermissionAndFolder()
                                        .then((value) async {
                                      final _dltime =
                                          DateTime.now().millisecondsSinceEpoch;
                                      setState(() {
                                        dlTime = _dltime.toString();
                                      });
                                      if (value == true) {
                                        File file = File(
                                            '${dir.path}/${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf"');

                                        if (!await file.exists()) {
                                          await writeOnPdf();
                                          // await savePdf();
                                          await OpenFile.open(
                                              "${dir.path}/${isSavedBillFrom ? savedBillerData!.bILLERNAME : billerData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                          // sendNotification("Download Completed",
                                          //     "${widget.historyData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                        } else {
                                          print("already exist");
                                        }
                                        // if (await File(
                                        //         "${dir.path}/${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf")
                                        //     .exists()) {
                                        //   print("already exist");
                                        //   OpenFile.open(
                                        //       "${dir.path}/${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf");
                                        // } else {
                                        //   await writeOnPdf();
                                        //   // await savePdf();
                                        //   print("file created");
                                        //   sendNotification("Download Completed",
                                        //       "${savedBillerData!.bILLERNAME}-${savedBillerData!.cOMPLETIONDATE.toString()}.pdf");
                                        // }
                                      }
                                    });

                                    // if (permissionGranted == true) {
                                    //   File file = File(
                                    //       '${dir}/"${savedBillerData!.bILLERNAME}-${dlTime.toString()}.pdf"');

                                    //   if (!await file.exists()) {
                                    //     await writeOnPdf();
                                    //     // await savePdf();
                                    //     sendNotification("Download Completed",
                                    //         "${savedBillerData!.bILLERNAME}-${dlTime.toString()}.pdf");
                                    //   } else {
                                    //     print("already exist");
                                    //   }
                                    // } else {
                                    //   customDialog(
                                    //       context: context,
                                    //       dialogHeight: height(context) / 3.2,
                                    //       iconHeight: height(context) * 0.1,
                                    //       message: "",
                                    //       message2: "",
                                    //       message3: "",
                                    //       title: "Storage Permission Not Granted",
                                    //       buttonName: "Okay",
                                    //       buttonAction: () {
                                    //         Navigator.pop(context);
                                    //       },
                                    //       iconSvg: alertSvg);
                                    // }
                                  }
                                },
                                icon: Image.asset(
                                    'assets/images/iconDownload.png'))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width(context) * 0.04,
                    bottom: width(context) * 0.04,
                    top: width(context) * 0.04,
                  ),
                  child: Text(
                    "Payment Details",
                    style: TextStyle(
                      fontFamily: 'Rubik-Regular',
                      fontSize: width(context) * 0.045,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: width(context) * 0.04,
                    left: width(context) * 0.04,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffE1E2F2),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(maxHeight: double.infinity),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                            height: height(context) * 0.05,
                            width: width(context),
                            child: columnText(
                                context,
                                "Paid to",
                                isSavedBillFrom
                                    ? savedBillerData!.bILLERNAME
                                    : billerData!.bILLERNAME)),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(
                            context,
                            "Bill Number",
                            isSavedBillFrom && !isMobilePrepaid
                                ? savedBillerData!.pARAMETERS![0].pARAMETERVALUE
                                    .toString()
                                : isSavedBillFrom && isMobilePrepaid
                                    // ? savedBillerData!.pARAMETERS!
                                    //     .firstWhere(
                                    //       (param) =>
                                    //           param.pARAMETERNAME
                                    //               .toString()
                                    //               .toLowerCase() ==
                                    //           'mobile number',
                                    //     )
                                    //     .pARAMETERVALUE
                                    ? "-"
                                    : !isSavedBillFrom && isMobilePrepaid
                                        // ? widget.tnxData['inputSignature']!
                                        //     .firstWhere(
                                        //       (param) =>
                                        //           param.pARAMETERNAME
                                        //               .toString()
                                        //               .toLowerCase() ==
                                        //           'mobile number',
                                        //     )
                                        //     .pARAMETERVALUE
                                        ? "-"
                                        : widget.tnxData['inputSignature'][0]
                                            .pARAMETERVALUE,
                            /* isSavedBillFrom
                                  ? savedBillerData!
                                      .pARAMETERS![0].pARAMETERVALUE
                                      .toString()
                                  : isMobilePrepaid
                                      ? widget.tnxData['inputSignature'][0]
                                          .pARAMETERVALUE
                                      : widget.tnxData['inputSignature'][0]
                                          ['PARAMETER_VALUE'], */
                          ),
                        ),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(
                              context,
                              "Date",
                              DateFormat("EEEE, d MMMM, y h:mm a")
                                  .format(DateTime.now())
                                  .toString()),
                        ),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(context, "Transaction ID",
                              paymentDetails!['txnReferenceId'].toString()),
                        ),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(context, "Approval Refrence Number",
                              paymentDetails!['approvalRefNum'].toString()),
                        ),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(
                            context, "Payment Mode", "Mobile Banking",
                            // paymentDetails!['paymentMode'].toString()
                          ),
                        ),
                      ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(context, "Payment Channel", "MB"
                              // paymentDetails!['paymentChannel'].toString()
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width(context) * 0.04,
                    bottom: width(context) * 0.04,
                    top: width(context) * 0.04,
                  ),
                  child: Text(
                    "Debited from",
                    style: TextStyle(
                      fontFamily: 'Rubik-Regular',
                      fontSize: width(context) * 0.045,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: width(context) * 0.04,
                    left: width(context) * 0.04,
                  ),
                  height: height(context) / 2.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffE1E2F2),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(context, "Account Number",
                              widget.tnxData['acNo'].toString()),
                        ),
                      ),
                      if (paymentDetails!['customerName'] != null) divideLine(),
                      if (paymentDetails!['customerName'] != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width(context) * 0.04,
                            vertical: width(context) * 0.02,
                          ),
                          child: SizedBox(
                            height: height(context) * 0.05,
                            width: width(context),
                            child: columnText(context, "Consumer Name",
                                paymentDetails!['customerName'].toString()),
                          ),
                        ),
                      divideLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: width(context) * 0.02,
                        ),
                        child: SizedBox(
                          height: height(context) * 0.05,
                          width: width(context),
                          child: columnText(context, "Mobile Number",
                              paymentDetails!['mobileNumber'].toString()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/be_assured_logo.png",
                          height: height(context) * 0.07,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: appText(
                            data:
                                'All billing details are verified by Bharat Billpay',
                            size: width(context) * 0.03,
                            color: txtSecondaryColor,
                            maxline: 1,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width(context) * 0.04,
                    bottom: width(context) * 0.04,
                    top: width(context) * 0.04,
                  ),
                  child: Text(
                    "Transaction",
                    style: TextStyle(
                      fontFamily: 'Rubik-Regular',
                      fontSize: width(context) * 0.045,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: width(context) * 0.04,
                    right: width(context) * 0.04,
                  ),
                  padding: EdgeInsets.all(width(context) * 0.02),
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffE1E2F2),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            backgroundColor: primaryBodyColor,
                            useMaterial3: true),
                        child: ExpansionTile(
                          backgroundColor: primaryBodyColor,
                          collapsedIconColor: primaryColor,
                          iconColor: primaryColor,
                          childrenPadding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.043,
                              vertical: width(context) * 0.01),
                          collapsedBackgroundColor: primaryBodyColor,
                          initiallyExpanded: true,
                          title: Row(children: [
                            paymentDetails!['success']
                                ? const Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.green)
                                : const Icon(Icons.cancel_rounded,
                                    color: Colors.red),
                            horizondalSpacer(width(context) * 0.03),
                            appText(
                                data: paymentDetails!['success']
                                    ? "Transaction Completed"
                                    : "Transaction Failed",
                                color: primaryColor,
                                weight: FontWeight.bold,
                                size: width(context) * 0.045)
                          ]),
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListView.builder(
                                      itemCount:
                                          tnxResponse!.transactionSteps!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child:
                                                            tnxResponse!
                                                                        .transactionSteps![
                                                                            index]
                                                                        .flag ==
                                                                    true
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_circle_outline_outlined,
                                                                    color: Colors
                                                                        .green)
                                                                : const Icon(
                                                                    Icons
                                                                        .cancel_rounded,
                                                                    color: Colors
                                                                        .red),
                                                      ),
                                                      horizondalSpacer(10),
                                                      appText(
                                                          data: tnxResponse!
                                                              .transactionSteps![
                                                                  index]
                                                              .description
                                                              .toString(),
                                                          size: width(context) *
                                                              0.035,
                                                          color:
                                                              txtPrimaryColor,
                                                          maxline: 1),
                                                    ],
                                                  ),
                                                  verticalSpacer(15)
                                                ],
                                              ))),
                                ])
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width(context) * 0.048,
                            right: width(context) * 0.016,
                            top: width(context) * 0.002,
                            bottom: width(context) * 0.016),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 2,
                              color: txtSecondaryDarkColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Payments done may take upto'),
                              TextSpan(
                                text: ' 3 working days',
                                style: TextStyle(
                                    color: txtAmountColor,
                                    decoration: TextDecoration.none),
                              ),
                              TextSpan(text: ' to reflect')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                myAppButton(
                    context: context,
                    buttonName: "Done",
                    onpress: () {
                      goToUntil(context, homeRoute);
                    },
                    margin: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.04,
                        vertical: width(context) * 0.04)),
              ],
            );
          })),
    );
  }
}
