import 'dart:developer';

import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:bbps/model/history_model.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;
import '../../model/complaints_config_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class ComplaintSubmit extends StatefulWidget {
  ComplaintSubmit({Key? key, this.txnData, this.reasonsdata}) : super(key: key);

  List<ComplaintTransactionReasons>? reasonsdata;
  HistoryData? txnData;

  @override
  State<ComplaintSubmit> createState() => _ComplaintSubmitState();
}

class _ComplaintSubmitState extends State<ComplaintSubmit> {
  String? isLoading = '';

  @override
  Widget build(BuildContext context) {
    void hideDialog() {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintSubmitLoading) {
            if (!Loader.isShown) {
              showLoader(context);
            }
          } else if (state is ComplaintSubmitSuccess) {
            if (Loader.isShown) {
              Loader.hide();
            }

            List<Map<String, dynamic>>? customMessage = [
              {"type": "normal", "message": "Your complaint bas been"},
              {"type": "normal", "message": "\nregistered successfully\n\n"},
              {
                "type": "normal",
                "message": "For future detail track complaint ID:\n"
              },
              {"type": "bold", "message": state.data}
            ];
            logConsole(customMessage.toString(), "ComplaintSubmitSuccess");
            customDialogMultiText(
                context: context,
                dialogHeight: height(context) / 2.6,
                message: customMessage,
                title: "Success!",
                buttonName: "Okay",
                buttonAction: () {
                  hideDialog();
                  goToUntil(context, homeRoute);
                },
                iconSvg: iconSuccessSvg);
            // customDialog(
            //     context: context,
            //     dialogHeight: height(context) / 2.9,
            //     iconHeight: height(context) * 0.1,
            //     message: state.message,
            //     message2: "",
            //     message3: "",
            //     title: "Complaint Registered",
            //     buttonName: "Okay",
            //     buttonAction: () {
            //       goToUntil(context, homeRoute);
            //     },
            //     iconSvg: iconSuccessSvg);
          } else if (state is ComplaintSubmitFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            customDialog(
                context: context,
                dialogHeight: height(context) / 2.7,
                iconHeight: height(context) * 0.1,
                message: state.message,
                message2: "",
                message3: "",
                title: "Oops!",
                buttonName: "Okay",
                buttonAction: () {
                  hideDialog();
                  goToUntil(context, homeRoute);
                },
                iconSvg: alertSvg);
          } else if (state is ComplaintSubmitError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          return ComplaintSubmitUI(
              reasonsdata: widget.reasonsdata, txnData: widget.txnData);
        },
      ),
    );
  }
}

class ComplaintSubmitUI extends StatefulWidget {
  ComplaintSubmitUI({Key? key, this.txnData, this.reasonsdata})
      : super(key: key);

  List<ComplaintTransactionReasons>? reasonsdata;
  HistoryData? txnData;

  @override
  State<ComplaintSubmitUI> createState() => _ComplaintSubmitUIState();
}

class _ComplaintSubmitUIState extends State<ComplaintSubmitUI> {
  var compDesc;
  var compReason;
  var compReasonId;
  bool? desField = true;
  var items = ['text 1'];
  final txtOtpController = TextEditingController();

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
          data: "Register Complaint",
          size: width(context) * 0.047,
          weight: FontWeight.w600,
        ),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 13),
            width: width(context) / 4,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                width: width(context) / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(bbpspngLogo),
                  fit: BoxFit.contain,
                ))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: txtColor),
              margin: EdgeInsets.all(width(context) * 0.028),
              padding: EdgeInsets.all(width(context) * 0.044),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: width(context) * 0.044),
                    child: appText(
                        data: 'Transaction details',
                        size: width(context) * 0.05,
                        color: txtPrimaryColor,
                        maxline: 1,
                        weight: FontWeight.bold),
                  ),
                  Container(
                    height: height(context) / 3.3,
                    padding: EdgeInsets.only(
                      top: width(context) * 0.044,
                      right: width(context) * 0.044,
                      left: width(context) * 0.044,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(spreadRadius: 2, color: divideColor)
                      ],
                      color: txtColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              BLogo,
                              height: height(context) * 0.065,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: width(context) * 0.044),
                              child: SizedBox(
                                width: width(context) * 0.58,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: width(context) * 0.016),
                                      child: appText(
                                          data: widget.txnData!.bILLNUMBER,
                                          size: width(context) * 0.03,
                                          color: txtSecondaryColor,
                                          weight: FontWeight.w400),
                                    ),
                                    appText(
                                        data: widget.txnData!.bILLERNAME,
                                        size: width(context) * 0.04,
                                        color: txtPrimaryColor,
                                        weight: FontWeight.w600)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: width(context) * 0.02,
                              bottom: width(context) * 0.02),
                          child: Divider(
                            thickness: 1,
                            color: divideColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appText(
                                data: DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(widget
                                            .txnData!.cOMPLETIONDATE
                                            .toString())
                                        .toLocal()),
                                size: width(context) * 0.045,
                                color: txtSecondaryColor),
                            appText(
                                data:
                                    "$rupee ${NumberFormat('#,##,##0.00').format(double.parse(widget.txnData!.bILLAMOUNT.toString()))}",
                                size: width(context) * 0.045,
                                weight: FontWeight.bold,
                                color: txtAmountColor)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: width(context) * 0.02,
                              bottom: width(context) * 0.02),
                          child: Divider(
                            thickness: 1,
                            color: divideColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appText(
                                data: "Reference ID :",
                                size: width(context) * 0.04,
                                weight: FontWeight.w400,
                                color: txtSecondaryColor),
                            appText(
                                data: widget.txnData!.tRANSACTIONREFERENCEID ??
                                    "N/A",
                                size: width(context) * 0.037,
                                color: txtCheckBalanceColor)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: width(context) * 0.02,
                              bottom: width(context) * 0.02),
                          child: Divider(
                            thickness: 1,
                            color: divideColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appText(
                                data: "Status",
                                size: width(context) * 0.04,
                                weight: FontWeight.w400,
                                color: txtSecondaryColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: width(context) * 0.35,
                                  height: width(context) * 0.06,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: widget
                                                  .txnData!.tRANSACTIONSTATUS ==
                                              'success'
                                          ? alertSuccessColor.withOpacity(0.1)
                                          : alertFailedColor.withOpacity(0.1)),
                                  child: appText(
                                      data: widget.txnData!.tRANSACTIONSTATUS ==
                                              'success'
                                          ? 'Success'
                                          : 'Failed',
                                      size: width(context) * 0.04,
                                      color:
                                          widget.txnData!.tRANSACTIONSTATUS ==
                                                  'success'
                                              ? alertSuccessColor
                                              : alertFailedColor,
                                      weight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width(context) * 0.048,
                        bottom: width(context) * 0.016),
                    child: appText(
                        data: "Reason",
                        size: width(context) * 0.04,
                        color: txtSecondaryDarkColor),
                  ),
                  Container(
                    height: height(context) * 0.08,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(spreadRadius: 2, color: divideColor)
                    ], color: txtColor, borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonFormField(
                      isDense: false,
                      itemHeight: 60,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.all(width(context) * 0.032),
                          border: InputBorder.none),
                      items: widget.reasonsdata!.map<DropdownMenuItem<String>>(
                          (ComplaintTransactionReasons value) {
                        return DropdownMenuItem<String>(
                          value: value.cOMPLAINTREASONSID.toString(),
                          child: Text(value.cOMPLAINTREASON.toString()),
                          onTap: () {
                            setState(() {
                              compReason = value.cOMPLAINTREASON;
                              compReasonId = value.cOMPLAINTREASONSID;
                            });
                          },
                        );
                      }).toList(),
                      isExpanded: true,
                      hint: Padding(
                        padding: EdgeInsets.only(
                          left: width(context) * 0.016,
                        ),
                        child: appText(
                          data: "Select",
                          size: width(context) * 0.04,
                          color: txtPrimaryColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width(context) * 0.048,
                        bottom: width(context) * 0.016),
                    child: appText(
                        data: "Description",
                        size: width(context) * 0.04,
                        color: txtSecondaryDarkColor),
                  ),
                  SizedBox(
                    height: height(context) / 5.6,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-z0-9A-Z ]*'))
                      ],
                      onChanged: (s) {
                        if (s.isEmpty != "") {
                          setState(() {
                            desField = true;
                          });
                        } else {
                          setState(() {
                            desField = false;
                          });
                        }
                      },
                      maxLines: 10,
                      controller: txtOtpController,
                      cursorColor: txtCursorColor,
                      decoration: InputDecoration(
                        fillColor: divideColor,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: divideColor, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: divideColor, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: divideColor, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: divideColor, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Type here...",
                        hintStyle: TextStyle(
                          fontSize: width(context) * 0.04,
                          fontFamily: appFont,
                          color: txtHintColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: myAppButton(
                context: context,
                buttonName: "Submit",
                margin: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.044,
                    vertical: width(context) * 0.044),
                onpress:
                    txtOtpController.text.isNotEmpty && compReasonId != null
                        ? () async {
                            // log('$data', name: "onpress complaint");
                            if (txtOtpController.text.isNotEmpty) {
                              if (await isConnected()) {
                                compDesc = txtOtpController.text;
                                Map<String, dynamic> data = {
                                  "description": compDesc,
                                  "reason": compReason,
                                  "complaintReasonsID": compReasonId,
                                  "type": "transaction",
                                  "transactionID": widget
                                      .txnData!.tRANSACTIONREFERENCEID
                                      .toString()
                                };
                                logConsole('$data', "onpress complaint");
                                BlocProvider.of<ComplaintCubit>(context)
                                    .submitComplaint(data);
                              } else {
                                showSnackBar(noInternetMessage, context);
                              }
                            } else {
                              showSnackBar("All field are required", context);
                            }
                          }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
