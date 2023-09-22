import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';

import '../../bloc/autopay/autopay_cubit.dart';
import '../../model/saved_bill_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/editAutopay_shimmer.dart';

class SetupAutoPay extends StatefulWidget {
  String? billID;
  String? maxAllowedAmount;
  String? billerName;
  String? billName;
  List<dynamic> inputSignatures;
  String? paidAmount;

  SetupAutoPay(
      {Key? key,
      @required this.maxAllowedAmount,
      this.billID,
      this.billerName,
      this.billName,
      required this.inputSignatures,
      this.paidAmount})
      : super(key: key);

  @override
  _SetupAutoPayState createState() => _SetupAutoPayState();
}

class _SetupAutoPayState extends State<SetupAutoPay> {
  bool isLoading = true;
  final txtMaxAmountController = TextEditingController();
  bool isTxtAmountValid = false;

  final txtDateofPaymentController = TextEditingController();
  final txtActivateAutoPaymentController = TextEditingController();

  String? calDate = null;
  String? newDate = '1';
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

  String activatesFrom = "Immediately";
  int? isBimonthly = 0;
  int? isActive = 0;
  int accountNumber = 0;
  bool disableSubmitButton = true;
  String? maxAllowedAmount = "0";
  List<String> optionsList = <String>[
    'Immediately',
    // ...getMonthName2(99)
    getMonthName2(0)[0]!,
    getMonthName2(0)[1]!
    // getMonthName(currentMonth),
    // getMonthName((int.parse(currentMonth) + 1).toString())
  ];

  @override
  void initState() {
    var test1 = getMonthName2(99);
    log(test1.toString(), name: "TEST1 ::");
    var test2 = getMonthName2(0)[0];
    log(test2.toString(), name: "TEST2 ::");
    var test3 = getMonthName2(0)[1];
    log(test3.toString(), name: "TEST2 ::");
    super.initState();
    inspect(widget.inputSignatures);

    assignDecodedTokenAccounts();

    txtDateofPaymentController.text = "1";
    setState(() {
      maxAllowedAmount = widget.maxAllowedAmount;
    });
    if (widget.maxAllowedAmount == "0") {
      BlocProvider.of<AutopayCubit>(context).fetchAutoPayMaxAmount();
    }
    // log(maxAllowedAmount.toString(), name: "SETSTATE maxAllowedAmount:::");
    setState(() {
      // txtMaxAmountController.text = double.parse(widget.paidAmount!) != 0
      //     ? double.parse(widget.paidAmount!).toString()
      //     : "1000";
      txtMaxAmountController.text = "0";
      isTxtAmountValid = false;
      // isTxtAmountValid = (txtMaxAmountController.text.isNotEmpty &&
      //         double.parse(maxAllowedAmount.toString()) >=
      //             double.parse(txtMaxAmountController.text))
      //     ? true
      //     : false;
    });

    calDate = "st of every month";
  }

  List<dynamic> decodedTokenAccounts = [];
  var accountIndex;
  void assignDecodedTokenAccounts() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    setState(() {
      decodedTokenAccounts = decodedToken['accounts'];
    });

    log(decodedTokenAccounts.toString(), name: "HERERE *******");
  }

  disableButton() {
    if (accountNumber == null ||
        txtMaxAmountController.text.isEmpty ||
        double.parse(txtMaxAmountController.text) <= 0 ||
        double.parse(txtMaxAmountController.text) >=
            double.parse(widget.maxAllowedAmount.toString())) {
      setState(() {
        disableSubmitButton = true;
      });
    } else {
      setState(() {
        disableSubmitButton = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: myAppBar(
          context: context,
          title: "Setup AutoPay",
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
          } else if (state is FetchAutoPayMaxAmountLoading) {
            showLoader(context);
          } else if (state is FetchAutoPayMaxAmountSuccess) {
            isLoading = false;

            setState(() {
              maxAllowedAmount =
                  state.fetchAutoPayMaxAmountModel!.data.toString();
              // isTxtAmountValid = (txtMaxAmountController.text.isNotEmpty &&
              //     double.parse(
              //             state.fetchAutoPayMaxAmountModel!.data.toString()) >=
              //         double.parse(txtMaxAmountController.text));
              isTxtAmountValid = false;
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
          return Container(
            height: height(context),
            width: width(context),
            color: primaryBodyColor,
            child: ListView(physics: const BouncingScrollPhysics(), children: [
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
                        data: widget.billName.toString(),
                        size: width(context) * 0.05,
                        weight: FontWeight.bold,
                        color: txtPrimaryColor),
                    subtitle: appText(
                        data: "(${widget.billerName})",
                        size: width(context) * 0.03,
                        color: txtPrimaryColor),
                  ),
                  ListView.builder(
                      itemCount: widget.inputSignatures.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    appText(
                                        data: widget.inputSignatures[index]
                                            .pARAMETERNAME
                                            .toString(),
                                        size: width(context) * 0.035,
                                        color: txtPrimaryColor),
                                    appText(
                                        data: widget.inputSignatures[index]
                                            .pARAMETERVALUE
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
                              "Limit: ₹ ${maxAllowedAmount!.isNotEmpty ? NumberFormat('#,##,##0').format(double.parse(maxAllowedAmount!)) : "40,000"}",
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

                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // DecimalTextInputFormatter(decimalRange: 2),

                      // Allow Decimal Number With Precision of 2 Only
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      if (txtMaxAmountController.text.isNotEmpty &&
                          (double.parse(maxAllowedAmount.toString()) >=
                              double.parse(txtMaxAmountController.text)) &&
                          (double.parse(txtMaxAmountController.text) >=
                              double.parse(widget.paidAmount!))) {
                        setState(() {
                          isTxtAmountValid = true;
                        });
                      } else {
                        setState(() {
                          isTxtAmountValid = false;
                        });
                      }
                      disableButton();
                    },
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: primaryBodyColor,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryBodyColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryBodyColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryBodyColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryBodyColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: "Maximum Amount",
                      hintStyle: TextStyle(color: txtHintColor),
                    ),
                  ),
                  verticalSpacer(width(context) * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                        data:
                            "Amount should be between ₹${double.parse(widget.paidAmount!)} to ₹${double.parse(maxAllowedAmount!)}",
                        size: width(context) * 0.03,
                        color: isTxtAmountValid
                            ? txtPrimaryColor
                            : txtRejectColor),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: width(context) * 0.65,
                                          height: width(context) * 0.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: primaryBodyColor,
                                          ),
                                          child: appText(
                                              data: "Select a Date",
                                              size: width(context) * 0.045,
                                              color: txtAmountColor,
                                              weight: FontWeight.bold),
                                        ),
                                        GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 30,
                                          padding: EdgeInsets.all(
                                              width(context) * 0.002),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                                      newDate = (index + 1)
                                                          .toString();
                                                      txtDateofPaymentController
                                                              .text =
                                                          (index + 1)
                                                              .toString();
                                                      if (myList.contains(
                                                          txtDateofPaymentController
                                                              .text)) {
                                                        calDate =
                                                            "th of every month";
                                                      }
                                                      if (myList2.contains(
                                                          txtDateofPaymentController
                                                              .text)) {
                                                        calDate =
                                                            "st of every month";
                                                      }
                                                      if (myList3.contains(
                                                          txtDateofPaymentController
                                                              .text)) {
                                                        calDate =
                                                            "nd of every month";
                                                      }
                                                      if (myList4.contains(
                                                          txtDateofPaymentController
                                                              .text)) {
                                                        calDate =
                                                            "rd of every month";
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                    disableButton();
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                    '${index + 1}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
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
                                            crossAxisSpacing:
                                                width(context) * 0.02,
                                            mainAxisSpacing:
                                                width(context) * 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        },
                      );
                    }),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width(context) * 0.03),
                        height: height(context) * 0.065,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  color: divideColor.withOpacity(0.4))
                            ],
                            color: txtColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  // ignore: unnecessary_brace_in_string_interps
                                  data: "$newDate $calDate",
                                  size: width(context) * 0.035,
                                  weight: FontWeight.w500,
                                  color: primaryColor),
                              horizondalSpacer(width(context) * 0.016),
                              ImageIcon(
                                const AssetImage(
                                    "assets/images/iconCalender.png"),
                                color: txtCheckBalanceColor,
                              ),
                            ])),
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
                          color: txtCheckBalanceColor,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.all(width(context) * 0.032),
                          border: InputBorder.none),
                      items: optionsList
                          .map<DropdownMenuItem<String>>((String value) {
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
                      setState(() => {isBimonthly = 0});
                      setState(() {
                        activatesFrom = "Immediately";
                      });
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
                      setState(() => {isBimonthly = 1});
                      setState(() {
                        activatesFrom = "Immediately";
                      });
                    },
                    // onChanged: (ind) => setState(() => isBimonthly = ind!),
                    title: appText(
                        data: "Every Two Months",
                        size: width(context) * 0.04,
                        color: txtPrimaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: appText(
                          maxline: 6,
                          data:
                              "You can choose when you want to activate your auto pay setup by selecting an option from the dropdown. Based on your current selections, we will start attempting to pay your bills from ${activatesFrom == "Immediately" ? "the next" : ""} ${numberPrefixSetter(txtDateofPaymentController.text)} ${activatesFrom != "Immediately" ? activatesFrom : ""} and once ${isBimonthly == 0 ? "every month" : "every two months"} after that.",
                          size: width(context) * 0.04,
                          color: txtSecondaryDarkColor),
                    ),
                  ),
                ]),
              ),
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
                        });
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
                        onPressed: () => goToReplace(context, homeRoute),
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
                        onPressed:
                            isTxtAmountValid == false || accountNumber == 0
                                ? null
                                : () async {
                                    await assignDecodedToken(accountNumber);
                                    // ignore: use_build_context_synchronously
                                    goToData(context, otpRoute, {
                                      "from": fromAutoPayCreate,
                                      "templateName": "create-auto-pay",
                                      "id": widget.billerName,
                                      "data": {
                                        "accountNumber": accountIndex,
                                        "maximumAmount":
                                            txtMaxAmountController.text,
                                        "paymentDate":
                                            txtDateofPaymentController.text,
                                        "isBimonthly": isBimonthly,
                                        "activatesFrom":
                                            activatesFrom == "Immediately"
                                                ? null
                                                : activatesFrom.toLowerCase(),
                                        "isActive": isActive,
                                        "billID": widget.billID,
                                        "billerName": widget.billerName
                                      }
                                    });
                                  },
                        child: appText(
                            data: "Create Autopay",
                            size: width(context) * 0.04,
                            weight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          );
        },
      ),
    );
  }
}
