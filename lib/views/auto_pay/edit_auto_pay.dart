import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../bloc/autopay/autopay_cubit.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/edit_autopay_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/editAutopay_shimmer.dart';

class EditAutoPayScreen extends StatefulWidget {
  AllConfigurationsData? autoPayData;
  String? id;
  String? maxAllowedAmount;
  String? billerName;
  String? billName;

  EditAutoPayScreen(
      {super.key,
      @required this.autoPayData,
      @required this.maxAllowedAmount,
      this.id,
      this.billerName,
      this.billName});

  @override
  State<EditAutoPayScreen> createState() => _EditAutoPayScreenState();
}

class _EditAutoPayScreenState extends State<EditAutoPayScreen> {
  EditAutoPayData? editAutoPayData;
  bool isLoading = true;
  String? maxAllowedAmount;

  @override
  void initState() {
    // api call edit data
    BlocProvider.of<AutopayCubit>(context).getEditData(widget.id);
    // BlocProvider.of<AutopayCubit>(context);

    setState(() {
      maxAllowedAmount = widget.maxAllowedAmount;
    });

    if (widget.maxAllowedAmount == "0") {
      BlocProvider.of<AutopayCubit>(context).fetchAutoPayMaxAmount();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          context: context,
          title: "AutoPay",
          bottom: PreferredSize(
            preferredSize: Size(width(context), 8.0),
            child: Container(
              width: width(context),
              color: primaryBodyColor,
            ),
          )),
      body: BlocConsumer<AutopayCubit, AutopayState>(
        listener: (context, state) {
          if (state is AutopayEditLoading) {
            if (!Loader.isShown) {
              showLoader(context);
            }
          } else if (state is AutopayEditSuccess) {
            if (Loader.isShown) {
              Loader.hide();
            }
            editAutoPayData = state.editAutoPayData;
            isLoading = false;
          } else if (state is AutopayEditFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            showSnackBar(state.message, context);
          } else if (state is AutopayEditError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          } else if (state is FetchAutoPayMaxAmountLoading) {
            showLoader(context);
          } else if (state is FetchAutoPayMaxAmountSuccess) {
            isLoading = false;
            setState(() {
              maxAllowedAmount =
                  state.fetchAutoPayMaxAmountModel!.data.toString();
            });
            Loader.hide();
          } else if (state is FetchAutoPayMaxAmountFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            showSnackBar(state.message, context);
          } else if (state is FetchAutoPayMaxAmountError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          return isLoading
              ? editAutopayShimmer()
              : EditAutoPayScreenUI(
                  maxAllowedAmount: maxAllowedAmount,
                  editAutoPayData: editAutoPayData,
                  autopayData: widget.autoPayData,
                  billername: widget.billerName);
        },
      ),
    );
  }
}

class EditAutoPayScreenUI extends StatefulWidget {
  AllConfigurationsData? autopayData;
  String? maxAllowedAmount;
  EditAutoPayData? editAutoPayData;
  String? billername;
  EditAutoPayScreenUI(
      {super.key,
      @required this.maxAllowedAmount,
      this.autopayData,
      this.editAutoPayData,
      this.billername});

  @override
  State<EditAutoPayScreenUI> createState() => _EditAutoPayScreenUIState();
}

class _EditAutoPayScreenUIState extends State<EditAutoPayScreenUI> {
  final txtMaxAmountController = TextEditingController();

  final txtDateofPaymentController = TextEditingController();
  String activatesFrom = "";

  final txtActivateAutoPaymentController = TextEditingController();

  // radio
  int? isBimonthly = 0;

  int? isActive = 0;

  // String maximumAmount = "";

  bool disableSubmitButton = true;
  bool amtExceed = false;
  bool autopayActive = false;
  int accountNumber = 0;
  var accountIndex;
  // double maximumAllowedAmount = 0.0;
  List<dynamic> decodedTokenAccounts = [];
  List<String> myList = [
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "24",
    "25",
    '26',
    "27",
    "28",
    "29",
    '30'
  ];
  List<String> myList2 = ["1", "21", '31'];
  List<String> myList3 = ["2", "22"];
  List<String> myList4 = ["3", "23"];

  String? calDate = null;
  String? newDate;

  @override
  void initState() {
    var temp = getMonthName2(99);
    log(temp.toString(), name: "getMonthName2 ::");
    isBimonthly = widget.autopayData?.iSBIMONTHLY;
    newDate = widget.autopayData!.pAYMENTDATE.toString();

    txtMaxAmountController.text = widget.autopayData!.mAXIMUMAMOUNT.toString();
    txtDateofPaymentController.text =
        widget.autopayData!.pAYMENTDATE.toString();

    if (myList.contains(widget.autopayData!.pAYMENTDATE.toString())) {
      calDate = "th of every month";
    }
    if (myList2.contains(widget.autopayData!.pAYMENTDATE.toString())) {
      calDate = "st of every month";
    }
    if (myList3.contains(widget.autopayData!.pAYMENTDATE.toString())) {
      calDate = "nd of every month";
    }
    if (myList4.contains(widget.autopayData!.pAYMENTDATE.toString())) {
      calDate = "rd of every month";
    }
    txtActivateAutoPaymentController.text =
        widget.autopayData!.aCTIVATESFROM.toString().contains("null")
            ? "-"
            : widget.autopayData!.aCTIVATESFROM.toString();
    setState(() {
      activatesFrom = widget.autopayData!.aCTIVATESFROM != null
          ? widget.autopayData!.aCTIVATESFROM![0].toUpperCase() +
              widget.autopayData!.aCTIVATESFROM!.substring(1)
          : "Immediately";
      isActive = widget.autopayData?.iSACTIVE;

      autopayActive = widget.autopayData!.aCTIVATESFROM != null ? false : true;

      accountNumber = int.parse(widget.autopayData!.aCCOUNTNUMBER!);

      // maximumAllowedAmount = widget.autopayData!.mAXIMUMAMOUNT;
    });

    if (widget.autopayData!.mAXIMUMAMOUNT.toString() != "") {
      txtMaxAmountController.text =
          widget.autopayData!.mAXIMUMAMOUNT.toString();
    } else {
      txtMaxAmountController.text = "0.00";
      // maximumAmount = "0.00";
    }

    assignDecodedTokenAccounts();
    assignDecodedToken(accountNumber);
    super.initState();
  }

  void assignDecodedTokenAccounts() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    setState(() {
      decodedTokenAccounts = decodedToken['accounts'];
    });

    log(decodedTokenAccounts.toString(), name: "HERERE *******");
  }

  assignDecodedToken(accNum) async {
    try {
      for (var data in decodedTokenAccounts) {
        var accNumber = data['accountID'];
        if (accNumber.toString() == accNum.toString()) {
          setState(() {
            // accountIndex = decodedModel?.accounts!.indexWhere(
            //     (element) => element.accountID == accNum.toString());
            accountIndex = data['id'];
          });
          log('${data['id']}', name: "array value");
        }
      }

      // log(accountIndex.toString(), name: 'Account Index');
      // // });
      // log('$accountIndex', name: "Account Index assignDecodedToken fn");
    } catch (e) {
      log(e.toString(), name: 'Error at assignDecodedToken fn');
    }
  }

  // dynamic FormValidation() {
  //   log("INSIDE **** ");

  //   if (txtDateofPaymentController.text == todaysDate) {
  //     setState(() {
  //       disableSubmitButton = true;
  //     });
  //   } else {
  //     setState(() {
  //       disableSubmitButton = false;
  //     });
  //   }

  //   if (!(accountNumber.toString() == null)) {
  //     setState(() {
  //       disableSubmitButton = true;
  //     });
  //   } else {
  //     setState(() {
  //       disableSubmitButton = false;
  //     });
  //   }

  //   if (!(txtMaxAmountController.text.toString() != null)) {
  //     log("COND 4 : TRUE");
  //   } else {
  //     log("COND 4 : FALSE");
  //   }

  //   if (!autopayActive) {
  //     log("COND 7 : TRUE");
  //   } else {
  //     log("COND 7 : FALSE");
  //   }

  //   if (txtDateofPaymentController.text == widget.autopayData!.pAYMENTDATE) {
  //     log("COND 8 : TRUE");
  //   } else {
  //     log("COND 8 : FALSE");
  //   }
  // }
  void pickDateDialog(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            txtDateofPaymentController.text =
                                val.day.toString();
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  disableButton() {
    if (widget.autopayData!.pAYMENTDATE == todaysDate ||
        txtDateofPaymentController.text == todaysDate ||
        widget.autopayData!.aCCOUNTNUMBER! == null ||
        txtMaxAmountController.text.isEmpty ||
        double.parse(txtMaxAmountController.text) <= 0 ||
        double.parse(txtMaxAmountController.text) >
            double.parse(widget.maxAllowedAmount.toString()) ||
        !autopayActive ||
        (txtDateofPaymentController.text ==
                widget.autopayData!.pAYMENTDATE.toString() &&
            double.parse(txtMaxAmountController.text) ==
                widget.autopayData!.mAXIMUMAMOUNT &&
            accountNumber == int.parse(widget.autopayData!.aCCOUNTNUMBER!) &&
            isBimonthly == widget.autopayData!.iSBIMONTHLY)) {
      setState(() {
        disableSubmitButton = true;
      });
    } else {
      setState(() {
        disableSubmitButton = false;
      });
    }

//     log(widget.autopayData!.pAYMENTDATE.toString(),
//         name: "widget.autopayData!.pAYMENTDATE ::");
//     log(todaysDate, name: "todaysDate :::");

//     log(txtDateofPaymentController.text,
//         name: "txtDateofPaymentController.text :: ");

//     log(double.parse(txtMaxAmountController.text).toString(),
//         name: "double.parse(txtMaxAmountController.text)::");

//     log(double.parse(widget.maxAllowedAmount.toString()).toString(),
//         name: "double.parse(widget.maxAllowedAmount.toString() :::");

//     log(autopayActive.toString(), name: "autopayActive:::");

// //type 'int' is not a subtype of type 'String
//     log(widget.autopayData!.mAXIMUMAMOUNT.toString(),
//         name: "widget.autopayData!.mAXIMUMAMOUNT :::");

//     log(accountNumber.toString(), name: "accountNumber :::");

//     log(widget.autopayData!.aCCOUNTNUMBER.toString(),
//         name: "widget.autopayData!.aCCOUNTNUMBER :::");

//     log(isBimonthly.toString(), name: "isBimonthly :::");

//     log(widget.autopayData!.iSBIMONTHLY.toString(),
//         name: "widget.autopayData!.iSBIMONTHLY ::");
  }

  List<String> optionsList = <String>[
    'Immediately',
    ...getMonthName2(99)
    // getMonthName(currentMonth)
  ];

  @override
  Widget build(BuildContext context) {
    log(optionsList.toString(), name: "AT EDIT AUTO PAY");
    return Container(
      height: height(context),
      width: width(context),
      color: primaryBodyColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          // first card
          Container(
            width: width(context),
            margin: EdgeInsets.all(width(context) * 0.044),
            padding: EdgeInsets.only(bottom: width(context) * 0.03),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              verticalSpacer(4.0),
              ListTile(
                leading: Image.asset(
                  bNeumonic,
                  height: height(context) * 0.07,
                ),
                title: appText(
                    data: widget.editAutoPayData!.billName![0].bILLNAME
                        .toString(),
                    size: width(context) * 0.05,
                    weight: FontWeight.bold,
                    color: txtPrimaryColor),
                subtitle: appText(
                    data: widget.billername ?? " ",
                    size: width(context) * 0.03,
                    color: txtPrimaryColor),
              ),
              ListView.builder(
                  itemCount: widget.editAutoPayData!.inputSignatures!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                        children: [
                          const Divider(
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: width(context) * 0.01,
                                horizontal: width(context) * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                appText(
                                    data: widget.editAutoPayData!
                                        .inputSignatures![index].pARAMETERNAME
                                        .toString(),
                                    size: width(context) * 0.035,
                                    color: txtPrimaryColor),
                                appText(
                                    data: widget.editAutoPayData!
                                        .inputSignatures![index].pARAMETERVALUE
                                        .toString(),
                                    size: width(context) * 0.035,
                                    color: txtPrimaryColor),
                              ],
                            ),
                          ),
                        ],
                      )),
            ]),
          ),
          // secound card
          Container(
            width: width(context),
            margin: EdgeInsets.all(width(context) * 0.044),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              // max amount
              verticalSpacer(16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                      data: "Maximum Amount",
                      size: width(context) * 0.04,
                      color: txtPrimaryColor),
                  appText(
                      data:
                          "Limit: ₹ ${widget.maxAllowedAmount!.isNotEmpty ? NumberFormat('#,##,##0').format(double.parse(widget.maxAllowedAmount!)) : "40,000"}",
                      size: width(context) * 0.03,
                      weight: FontWeight.w600,
                      color: txtCheckBalanceColor),
                ],
              ),
              verticalSpacer(16.0),
              TextFormField(
                controller: txtMaxAmountController,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // DecimalTextInputFormatter(decimalRange: 2),

                  // Allow Decimal Number With Precision of 2 Only
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  if (value.isEmpty ||
                      double.parse(widget.maxAllowedAmount.toString()) <
                          double.parse(txtMaxAmountController.text)) {
                    setState(() {
                      // disableSubmitButton = true;
                      amtExceed = true;
                    });
                  } else {
                    setState(() {
                      // disableSubmitButton = false;
                      amtExceed = false;
                    });
                  }

                  disableButton();
                },

                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: primaryBodyColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: "Maximum Amount",
                  hintStyle: TextStyle(color: txtHintColor),
                ),
              ),
              // if (!maximumAmount ||
              //     parseFloat(maximumAmount) <= 0 ||
              //     parseFloat(maximumAmount) > maximumAllowedAmount)
              if (txtMaxAmountController.text.isEmpty ||
                  double.parse(txtMaxAmountController.text) <= 0 ||
                  double.parse(txtMaxAmountController.text) >
                      double.parse(widget.maxAllowedAmount.toString()))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                        data:
                            "Maximum amount should be less than or equal to ₹ ${widget.maxAllowedAmount!.isNotEmpty ? NumberFormat('#,##,##0').format(double.parse(widget.maxAllowedAmount!)) : ""}",
                        size: width(context) * 0.04,
                        color: txtRejectColor),
                  ),
                ),
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Date of Payment",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              verticalSpacer(16.0),
              InkWell(
                onTap: (() {
                  // show clendar picker (2nd of every month)
                  // pickDateDialog(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: SizedBox(
                          height: height(context) / 2.3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: width(context) * 0.04,
                                horizontal: width(context) * 0.04),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: width(context) * 0.65,
                                  height: width(context) * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: primaryBodyColor,
                                  ),
                                  child: appText(
                                      data: "Select a Date",
                                      size: width(context) * 0.045,
                                      color: txtAmountColor,
                                      weight: FontWeight.bold),
                                ),
                                // appText(
                                //     data: "Select a Date",
                                //     size: width(context) * 0.06,
                                //     align: TextAlign.center,
                                //     weight: FontWeight.bold,
                                //     color: txtAmountColor),
                                GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 30,
                                  padding:
                                      EdgeInsets.all(width(context) * 0.002),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: int.parse(
                                                    txtDateofPaymentController
                                                        .text) ==
                                                index + 1
                                            ? primaryColor
                                            : primaryBodyColor,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              newDate = (index + 1).toString();
                                              txtDateofPaymentController.text =
                                                  (index + 1).toString();
                                              if (myList.contains(
                                                  txtDateofPaymentController
                                                      .text)) {
                                                calDate = "th of every month";
                                              }
                                              if (myList2.contains(
                                                  txtDateofPaymentController
                                                      .text)) {
                                                calDate = "st of every month";
                                              }
                                              if (myList3.contains(
                                                  txtDateofPaymentController
                                                      .text)) {
                                                calDate = "nd of every month";
                                              }
                                              if (myList4.contains(
                                                  txtDateofPaymentController
                                                      .text)) {
                                                calDate = "rd of every month";
                                              }
                                            });
                                            Navigator.pop(context);

                                            // if (txtDateofPaymentController
                                            //         .text ==
                                            //     widget.autopayData!
                                            //         .pAYMENTDATE
                                            //         .toString()) {
                                            //   setState(() {
                                            //     disableSubmitButton = true;
                                            //   });
                                            // } else {
                                            //   setState(() {
                                            //     disableSubmitButton = false;
                                            //   });
                                            // }

                                            disableButton();
                                          },
                                          child: Center(
                                              child: Text(
                                            '${index + 1}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: width(context) * 0.04,
                                              color: int.parse(
                                                          txtDateofPaymentController
                                                              .text) ==
                                                      index + 1
                                                  ? txtColor
                                                  : txtPrimaryColor,
                                            ),
                                          )),
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: width(context) * 0.02,
                                    mainAxisSpacing: width(context) * 0.02,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: width(context) * 0.03),
                    height: height(context) * 0.065,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          spreadRadius: 2, color: divideColor.withOpacity(0.4))
                    ], color: txtColor, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          appText(
                              data: "${newDate} ${calDate}",
                              size: width(context) * 0.035,
                              weight: FontWeight.w500,
                              color: primaryColor),
                          horizondalSpacer(width(context) * 0.016),
                          ImageIcon(
                            AssetImage("assets/images/iconCalender.png"),
                            color: txtCheckBalanceColor,
                          ),
                        ])),
              ),
              //{data.PAYMENT_DATE === todaysDate || paymentDate === todaysDate

              if (widget.autopayData!.pAYMENTDATE == todaysDate ||
                  txtDateofPaymentController.text == todaysDate)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                        data:
                            "Cannot edit or delete auto payment if selected/set date is today's date",
                        size: width(context) * 0.04,
                        color: txtRejectColor),
                  ),
                ),
              //  date of payment
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Changes to be reflected from",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              verticalSpacer(width(context) * 0.044),
              Container(
                height: height(context) * 0.065,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      spreadRadius: 2, color: divideColor.withOpacity(0.4))
                ], color: txtColor, borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonFormField(
                  value: activatesFrom,
                  icon: const Icon(Icons.expand_more),
                  isDense: false,
                  itemHeight: 60,
                  style: TextStyle(
                      color: txtCheckBalanceColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(width(context) * 0.032),
                      border: InputBorder.none),
                  items:
                      optionsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (String? value) {
                    setState(() {
                      activatesFrom = value!;
                    });

                    if (activatesFrom == "Immediately") {
                      setState(() {
                        isActive = 1;
                        // disableSubmitButton = true;
                      });
                    } else {
                      setState(() {
                        // disableSubmitButton = false;
                        isActive = 0;
                      });
                    }
                  },
                ),
              ),

              //  We Pay Your Bills Once:
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "We Pay Your Bills Once:",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),

              verticalSpacer(8.0),
              RadioListTile(
                value: 0,
                activeColor: txtCheckBalanceColor,
                groupValue: isBimonthly,
                onChanged: (ind) {
                  if (txtMaxAmountController.text.isEmpty ||
                      double.parse(widget.maxAllowedAmount.toString()) <
                          double.parse(txtMaxAmountController.text)) {
                    // disableSubmitButton = true;
                  } else {
                    setState(() {
                      isBimonthly = 0;
                      // disableSubmitButton = false;
                    });
                  }
                  disableButton();
                },
                // onChanged: (value) => setState(() => isBimonthly = value!),
                title: appText(
                    data: "Every Month",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),

              RadioListTile(
                activeColor: txtCheckBalanceColor,
                value: 1,
                groupValue: isBimonthly, //checked={isBimonthly === 1}
                onChanged: (ind) {
                  if (txtMaxAmountController.text.isEmpty ||
                      double.parse(widget.maxAllowedAmount.toString()) <
                          double.parse(txtMaxAmountController.text)) {
                    // disableSubmitButton = true;
                  } else {
                    setState(() {
                      isBimonthly = 1;
                      // disableSubmitButton = false;
                    });
                  }
                  disableButton();
                },
                // onChanged: (ind) => setState(() => isBimonthly = ind!),
                title: appText(
                    data: "Every Two Months",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              if (activatesFrom == getMonthName2(99)[0])
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                        maxline: 6,
                        data:
                            "Your auto pay will stay inactive and we will resume paying your bills only from ${numberPrefixSetter(txtDateofPaymentController.text)} ${getMonthName2(99)[0].split(" ")[0]}, ${getMonthName2(99)[0].split(" ")[1]}. If you want us to pay your bills on the  ${numberPrefixSetter(txtDateofPaymentController.text)} of this (current) month, please select Immediately from the dropdown.",
                        size: width(context) * 0.04,
                        color: txtSecondaryDarkColor),
                  ),
                ),
            ]),
          ),

          // third card
          Container(
            // height: height(context) / 3,
            width: width(context),
            margin: EdgeInsets.all(width(context) * 0.044),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Select Payment Account",
                    size: width(context) * 0.05,
                    weight: FontWeight.bold,
                    color: txtPrimaryColor),
              ),
              for (int i = 0; i < decodedTokenAccounts.length; i++)
                RadioListTile(
                  activeColor: txtCheckBalanceColor,
                  value: int.parse(
                      decodedTokenAccounts[i]['accountID'].toString()),
                  groupValue: accountNumber,
                  onChanged: (value) {
                    setState(() {
                      accountNumber = int.parse(
                          decodedTokenAccounts[i]['accountID'].toString());
                      disableSubmitButton = false;
                    });
                    disableButton();
                  },
                  title: appText(
                      data: decodedTokenAccounts[i]['accountID'].toString(),
                      size: width(context) * 0.04,
                      weight: accountNumber ==
                              int.parse(decodedTokenAccounts[i]['accountID']
                                  .toString())
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: txtPrimaryColor),
                ),
            ]),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.044,
                      vertical: width(context) * 0.016),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: TextButton(
                    onPressed: () => goBack(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: txtPrimaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: appText(
                        data: "Cancel",
                        size: width(context) * 0.04,
                        weight: FontWeight.bold,
                        color: txtPrimaryColor),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.044,
                      vertical: width(context) * 0.016),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: disableSubmitButton
                        ? null
                        : () async {
                            await assignDecodedToken(accountNumber);
                            // ignore: use_build_context_synchronously
                            goToData(context, otpRoute, {
                              "from": fromAutoPayEdit,
                              "templateName": "edit-auto-pay",
                              "id": widget.autopayData!.iD,
                              "data": {
                                "accountNumber": accountIndex,
                                "maximumAmount": txtMaxAmountController.text,
                                "paymentDate": txtDateofPaymentController.text,
                                "isBimonthly": isBimonthly,
                                "activatesFrom": activatesFrom == "Immediately"
                                    ? null
                                    : activatesFrom.toLowerCase(),
                                "isActive": isActive,
                                "billerName": widget.autopayData!.bILLERNAME
                              } //update billerName later;
                            });
                          },
                    child: appText(
                        data: "Update",
                        size: width(context) * 0.04,
                        weight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          verticalSpacer(16.0),
        ],
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    try {
      if (decimalRange != null) {
        String value = newValue.text;

        if (value.contains(".") &&
            value.substring(value.indexOf(".") + 1).length > decimalRange) {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        } else if (value == ".") {
          truncated = "0.";

          newSelection = newValue.selection.copyWith(
            baseOffset: math.min(truncated.length, truncated.length + 1),
            extentOffset: math.min(truncated.length, truncated.length + 1),
          );
        }

        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
    } catch (e) {
      print(e);
    }
    return newValue;
  }
}
