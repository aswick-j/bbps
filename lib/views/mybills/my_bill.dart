import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../bloc/mybill/mybill_cubit.dart';
import '../../model/chart_model.dart';
import '../../model/saved_billers_model.dart';
import '../../model/upcoming_dues_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/myBills_shimmer.dart';
import '../../widgets/shimmerCell.dart';

class MyBillScreen extends StatefulWidget {
  const MyBillScreen({Key? key}) : super(key: key);

  @override
  State<MyBillScreen> createState() => _MyBillScreenState();
}

class _MyBillScreenState extends State<MyBillScreen> {
  List<ChartData>? chartdata = [];
  List<SavedBillersData>? billerData = [];
  List<UpcomingDuesData>? upcomingDuesData = [];
  bool isLoading = true;
  @override
  void initState() {
    BlocProvider.of<MybillCubit>(context).getAllUpcomingDues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBodyColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: primaryColor,
          title: appText(
            data: "My Bills",
            size: width(context) * 0.06,
            weight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        body:
            BlocConsumer<MybillCubit, MybillState>(listener: (context, state) {
          if (state is MybillChartSuccess) {
            chartdata = state.chartModel!.data ?? [];

            billerData = state.chartModel!.billerData ?? [];
            log(jsonEncode(billerData), name: "im needed value");
            // var successCustomerBillIds = [];

            // for (var tempData in chartdata!) {
            //   if (tempData.tRANSACTIONSTATUS == "success" &&
            //       tempData.cUSTOMERBILLID != null &&
            //       !(successCustomerBillIds.contains(tempData.cUSTOMERBILLID))) {
            //     successCustomerBillIds.add(tempData.cUSTOMERBILLID);

            //     // log(tempData.cUSTOMERBILLID.toString(),
            //     //     name: "TEMPDATA 2:: cUSTOMERBILLID");
            //     // log(tempData.tRANSACTIONSTATUS.toString(),
            //     //     name: "TEMPDATA 2:: tRANSACTIONSTATUS");
            //   }
            // }

            // for (var tempData in billerData!) {
            //   if (successCustomerBillIds.contains(tempData.cUSTOMERBILLID)) {
            //     tempData.tRANSACTIONSTATUS = "success";
            //   }
            // }

            // log(successCustomerBillIds.toString(), name: "TEMPDATA 3::");
            // log(jsonEncode(billerData).toString(), name: "BILLER DATA:::");
            isLoading = false;
          } else if (state is MybillChartLoading) {
          } else if (state is MybillChartFailed) {
            isLoading = false;
            showSnackBar(state.message, context);
          } else if (state is MybillChartError) {
            isLoading = false;
            goToUntil(context, splashRoute);
          }
          if (state is UpcomingDueLoading) {
          } else if (state is UpcomingDueSuccess) {
            BlocProvider.of<MybillCubit>(context).getCharts();

            upcomingDuesData = state.upcomingDuesData;
            log(upcomingDuesData!.length.toString(),
                name: "upcomingDuesData LENGTH ::: ");
          } else if (state is UpcomingDueFailed) {
            isLoading = false;
            showSnackBar(state.message, context);
          } else if (state is UpcomingDueError) {
            isLoading = false;
            goToUntil(context, splashRoute);
          }
        }, builder: (context, state) {
          return !isLoading
              ? Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: height(context) / 1.6,
                      left: 0,
                      child: Container(
                        width: width(context),
                        color: primaryColor,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalSpacer(height(context) * 0.05),
                            ]),
                      ),
                    ),
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    top: width(context) * 0.040,
                                    left: width(context) * 0.040,
                                    right: width(context) * 0.040),
                                padding: EdgeInsets.all(width(context) * 0.040),
                                height: chartdata!.isNotEmpty
                                    ? height(context) / 1.2
                                    : height(context) / 3,
                                width: width(context),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: chartdata!.isNotEmpty &&
                                        isLoading == false
                                    ? TransactionScreenUI(
                                        data: chartdata,
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                            SvgPicture.asset(iconMyBillSvg,
                                                height: height(context) / 8),
                                            appText(
                                                data:
                                                    'You have No Transactions',
                                                size: width(context) * 0.044,
                                                weight: FontWeight.w500,
                                                color: txtPrimaryColor)
                                          ])),
                            SizedBox(
                              height: height(context) / 1.7,
                              width: width(context),
                              child: MyBillScreenUI(
                                  billerData: billerData,
                                  billDueData: upcomingDuesData,
                                  chartdata: chartdata),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : myBillsShimmer();
        }));
  }
}

class MyBillScreenUI extends StatefulWidget {
  List<SavedBillersData>? billerData;
  List<UpcomingDuesData>? billDueData;
  List<ChartData>? chartdata = [];

  MyBillScreenUI({Key? key, this.billerData, this.billDueData, this.chartdata})
      : super(key: key);

  @override
  State<MyBillScreenUI> createState() => _MyBillScreenUIState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _MyBillScreenUIState extends State<MyBillScreenUI> {
  getdueDate(index) {
    // log(index.toString(), name: "getduedate2 :::");
    // log(jsonEncode(widget.billerData![index]).toString(),
    //     name: "getduedate2 ::: widget.billerData![index]:::");
    if (index != null) {
      try {
        List<UpcomingDuesData>? find = widget.billDueData!
            .where((items) =>
                items.customerBillID ==
                widget.billerData![index].cUSTOMERBILLID)
            .toList();
        // print(find.toString());
        // log(jsonEncode(find).toString(), name: "getduedate2 :::");

        return (find.isNotEmpty ? find[0].dueDate : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  getdueAmount(index) {
    if (index != null) {
      try {
        List<UpcomingDuesData>? find = widget.billDueData!
            .where((items) =>
                items.customerBillID ==
                widget.billerData![index].cUSTOMERBILLID)
            .toList();
        // log(jsonEncode(find).toString(), name: "getdueAmount :::");
        return (find.isNotEmpty ? find[0].dueAmount : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  Widget showAutoPay(SavedBillersData savedBillerData) {
    // log(savedBillerData.cUSTOMERBILLID.toString(), name: "cUSTOMERBILLID :: ");
    // log(savedBillerData.aUTOPAYID.toString(), name: "aUTOPAYID :: ");

    // log(savedBillerData.tRANSACTIONSTATUS.toString(),
    //     name: "tRANSACTIONSTATUS ::");

    // log(savedBillerData.bILLERACCEPTSADHOC.toString(),
    //     name: "bILLERACCEPTSADHOC :: ");
    log(jsonEncode(savedBillerData).toString(), name: "SELECTED");
    /*

    {BILLER_ID: OTOE00005XXZ43, CUSTOMER_BILL_ID: 2153, BILLER_NAME: OTOE, BILLER_COVERAGE: IND, BILLER_ICON: OTOE, BILLER_EFFECTIVE_FROM: null, BILLER_EFFECTIVE_TO: null, PAYMENT_EXACTNESS: Exact, BILLER_ACCEPTS_ADHOC: N, FETCH_BILL_ALLOWED: null, VALIDATE_BILL_ALLOWED: N, FETCH_REQUIREMENT: OPTIONAL, SUPPORT_BILL_VALIDATION: NOT_SUPPORTED, CHANGE_IN_AMOUNT: null, QUICK_PAY_ALLOWED: null, PAYMENT_DATE: null, AUTOPAY_ID: null, PARAMETER_NAME: a b c d e, PARAMETER_VALUE: 111, TRANSACTION_STATUS: null, COMPLETION_DATE: null, BILL_AMOUNT: null, CATEGORY_NAME: Electricity, BILL_NAME: testtest, LAST_PAID_DATE: 2023-02-02T10:06:09.000Z, LAST_BILL_AMOUNT: 1000, PARAMETERS: [{PARAMETER_NAME: a b c d e, PARAMETER_VALUE: 111}, {PARAMETER_NAME: a b c d, PARAMETER_VALUE: 222}, {PARAMETER_NAME: a b c, PARAMETER_VALUE: 444}, {PARAMETER_NAME: a, PARAMETER_VALUE: 333}, {PARAMETER_NAME: a b, PARAMETER_VALUE: 777}]}


if (widget.historyData![widget.index].aUTOPAYID == null &&
              widget.historyData![widget.index].cUSTOMERBILLID != null &&
              widget.historyData![widget.index].tRANSACTIONSTATUS ==
                  "success" &&
              widget.historyData![widget.index].bILLERACCEPTSADHOC == "N")
    */

    if (savedBillerData.aUTOPAYID == null &&
        savedBillerData.lASTPAIDDATE != null &&
        savedBillerData.bILLERACCEPTSADHOC == "N") {
      return Container(
        height: height(context) * 0.038,
        decoration: BoxDecoration(
          color: txtPrimaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextButton(
          onPressed: () {
            // log(savedBillerData.cUSTOMERBILLID.toString(),
            //     name: "cUSTOMERBILLID :: ");
            // log(savedBillerData.aUTOPAYID.toString(), name: "aUTOPAYID :: ");

            // log(savedBillerData.tRANSACTIONSTATUS.toString(),
            //     name: "tRANSACTIONSTATUS ::");

            // log(savedBillerData.bILLERACCEPTSADHOC.toString(),
            //     name: "bILLERACCEPTSADHOC :: ");
            // log(jsonEncode(savedBillerData).toString(), name: "SELECTED");
            goToData(context, setupAutoPayRoute, {
              "customerBillID": savedBillerData.cUSTOMERBILLID.toString(),
              "paidAmount": savedBillerData.lASTBILLAMOUNT.toString(),
              "inputSignatures": savedBillerData.pARAMETERS,
              "billname": savedBillerData.bILLNAME,
              "billername": savedBillerData.bILLERNAME,
              "limit": "0"
            });
          },
          child: Text(
            "Eligible for Autopay",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: height(context) * 0.001,
              color: Colors.white,
              fontSize: width(context) * 0.04,
              fontFamily: appFont,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
      // return Container(
      //   // margin: EdgeInsets.symmetric(
      //   //     horizontal: width(context) * 0.14),
      //   height: height(context) * 0.038,
      //   decoration: BoxDecoration(
      //     color: txtPrimaryColor,
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   child: Text(
      //     "Eligible for Autopay",
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       height: height(context) * 0.002,
      //       color: Colors.white,
      //       fontSize: width(context) * 0.04,
      //       fontFamily: appFont,
      //       fontWeight: FontWeight.normal,
      //     ),
      //   ),
      // );
    } else {
      return Container(
        // margin: EdgeInsets.symmetric(
        //     horizontal: width(context) * 0.14),
        height: height(context) * 0.038,
        decoration: BoxDecoration(
          color: const Color(0x172ECC70),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "Autopay Enabled",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: height(context) * 0.002,
            color: alertSuccessColor,
            fontSize: width(context) * 0.04,
            fontFamily: appFont,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      margin: EdgeInsets.symmetric(
          horizontal: width(context) * 0.040, vertical: width(context) * 0.012),
      decoration: BoxDecoration(
        color: txtColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(width(context) * 0.02),
        child: Column(
          children: [
            SizedBox(
              height: height(context) / 10.2,
              width: width(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.016),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                          data: "My Billers",
                          size: width(context) * 0.05,
                          color: primaryColor,
                          weight: FontWeight.bold,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: width(context) * 0.016,
                                ),
                                child: appText(
                                  data: "Autopay",
                                  size: width(context) * 0.04,
                                  color: txtSecondaryColor,
                                ),
                              ),
                              Tooltip(
                                textStyle: TextStyle(
                                    fontFamily: appFont, color: Colors.white),
                                decoration:
                                    BoxDecoration(color: primaryColorDark),
                                triggerMode: TooltipTriggerMode.tap,
                                padding: EdgeInsets.all(width(context) * 0.02),
                                margin: EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.06),
                                message:
                                    "Auto pay facility is supported only for select billers and is enabled after you pay a bill atleast once for a saved biller",
                                child: Icon(
                                  Icons.info_outline,
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (() => goTo(context, billerSearchRoute)),
                        child: Container(
                            width: width(context) / 1.55,
                            padding: EdgeInsets.all(width(context) * 0.03),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: primaryColor),
                            child: Align(
                              alignment: Alignment.center,
                              child: appText(
                                  textAlign: TextAlign.center,
                                  data: "Add New Biller",
                                  size: width(context) * 0.04,
                                  weight: FontWeight.bold),
                            )),
                      ),
                      GestureDetector(
                        onTap: (() => goTo(context, billerSearchRoute)),
                        child: Container(
                          width: width(context) * 0.11,
                          padding: EdgeInsets.all(width(context) * 0.024),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: divideColor.withOpacity(0.8)),
                          child: Icon(Icons.search, color: txtAmountColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: width(context) * 0.040,
              ),
              height: height(context) / 2.3,
              width: width(context),
              decoration: BoxDecoration(
                color: primaryBodyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.billerData!.isNotEmpty
                  ? ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        padding:
                            EdgeInsets.only(bottom: height(context) * 0.03),
                        itemCount: widget.billerData!.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            log(widget.billerData![index].toJson().toString(),
                                name: "widget.billerData![index] ::");

                            if (widget.billerData![index].cATEGORYNAME
                                .toString()
                                .toLowerCase()
                                .contains("mobile prepaid")) {
                              isSavedBillFrom = true;
                              isMobilePrepaidFrom = true;
                              if (baseUrl
                                  .toString()
                                  .toLowerCase()
                                  .contains("digiservicesuat")) {
                                goToData(context, prepaidAddBillerRoute, {
                                  "id": "",
                                  "name": widget.billerData![index].cATEGORYNAME
                                      .toString(),
                                  "savedBillersData": widget.billerData![index],
                                  "isSavedBill": true
                                });
                              } else {
                                customDialog(
                                    context: context,
                                    message: "This is an upcoming feature.",
                                    message2: "",
                                    message3: "",
                                    title: "Alert!",
                                    buttonName: "Okay",
                                    dialogHeight: height(context) / 2.5,
                                    buttonAction: () {
                                      Navigator.pop(context, true);
                                    },
                                    iconSvg: alertSvg);
                              }
                            } else {
                              isSavedBillFrom = true;
                              isMobilePrepaidFrom = false;
                              goToData(context, confirmPaymentRoute, {
                                "billID":
                                    widget.billerData![index].cUSTOMERBILLID,
                                "name": widget.billerData![index].bILLERNAME,
                                "number":
                                    widget.billerData![index].pARAMETERVALUE,
                                "billerID": widget.billerData![index].bILLERID,
                                "savedBillersData": widget.billerData![index],
                                "isSavedBill": true
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: txtColor),
                            margin: EdgeInsets.only(
                              top: width(context) * 0.008,
                              right: width(context) * 0.008,
                              left: width(context) * 0.008,
                            ),
                            // height: height(context) / 5.8,
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.016,
                                    vertical: width(context) * 0.008,
                                  ),
                                  // leading: SvgPicture.asset(
                                  //   airtelLogo,
                                  // ),
                                  leading: Image.asset(
                                    bNeumonic,
                                    height: height(context) * 0.07,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: width(context) * 0.008),
                                    child: appText(
                                      data:
                                          widget.billerData![index].bILLERNAME,
                                      size: width(context) * 0.04,
                                      color: txtSecondaryColor,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(
                                        top: width(context) * 0.016),
                                    child: appText(
                                      data: widget.billerData![index].bILLNAME,
                                      size: width(context) * 0.04,
                                      color: txtPrimaryColor,
                                      maxline: 1,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: iconColor,
                                    ),
                                    tooltip: "Menu",
                                    onSelected: (value) {
                                      if (value == 0) {
                                        goToData(context, editBill, {
                                          "data": widget.billerData![index],
                                        });
                                      } else if (value == 1) {
                                        customDialog(
                                            context: context,
                                            message: widget.billerData![index]
                                                        .cATEGORYNAME ==
                                                    "Mobile Prepaid"
                                                ? "You will no longer receive any notifications about the biller in future"
                                                : "You will no longer receive any notifications about the biller in future and all auto pay setups would be disabled effectively from the next cycle",
                                            message2: "",
                                            message3: "",
                                            title: "Alert!",
                                            buttonName: "Delete",
                                            isMultiBTN: true,
                                            dialogHeight: height(context) / 2.5,
                                            buttonAction: () {
                                              Navigator.pop(context, true);
                                              goToData(context, otpRoute, {
                                                "from": myBillRoute,
                                                "templateName":
                                                    "delete-biller-otp",
                                                "data": {
                                                  "bILLERNAME": widget
                                                      .billerData![index]
                                                      .bILLERNAME,
                                                  "cbid": widget
                                                      .billerData![index]
                                                      .cUSTOMERBILLID
                                                      .toString()
                                                }
                                              });
                                            },
                                            iconSvg: alertSvg);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 0,
                                        onTap: () => {},
                                        child: const Text('View'),
                                      ),
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () => {},
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  indent: 8.0,
                                  endIndent: 8.0,
                                  color: divideColor,
                                ),
                                if ((widget.billerData![index].aUTOPAYID !=
                                        null) ||
                                    (widget.billerData![index].aUTOPAYID ==
                                            null &&
                                        widget.billerData![index]
                                                .cUSTOMERBILLID !=
                                            null &&
                                        widget.billerData![index]
                                                .lASTPAIDDATE !=
                                            null &&
                                        widget.billerData![index]
                                                .bILLERACCEPTSADHOC ==
                                            "N"))
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: IgnorePointer(
                                      ignoring: (widget.billerData![index]
                                                      .cHANGE_IN_AMOUNT ==
                                                  null &&
                                              widget.billerData![index]
                                                      .lASTBILLAMOUNT ==
                                                  null &&
                                              widget.billerData![index]
                                                      .lASTPAIDDATE ==
                                                  null &&
                                              getdueAmount(index) == "" &&
                                              getdueDate(index) == "")
                                          ? true
                                          : false,
                                      child: ExpansionTile(
                                        trailing: (widget.billerData![index]
                                                        .cHANGE_IN_AMOUNT ==
                                                    null &&
                                                widget.billerData![index]
                                                        .lASTBILLAMOUNT ==
                                                    null &&
                                                widget.billerData![index]
                                                        .lASTPAIDDATE ==
                                                    null &&
                                                getdueAmount(index) == "" &&
                                                getdueDate(index) == "")
                                            ? const SizedBox()
                                            : null,
                                        childrenPadding: EdgeInsets.symmetric(
                                            vertical: width(context) * 0.02,
                                            horizontal: width(context) * 0.04),
                                        title: showAutoPay(
                                            widget.billerData![index]),
                                        children: [
                                          if (widget.billerData![index]
                                                  .cHANGE_IN_AMOUNT !=
                                              null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    data: 'Change In Amount',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor),
                                                appText(
                                                    data: widget
                                                        .billerData![index]
                                                        .cHANGE_IN_AMOUNT,
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor)
                                              ],
                                            ),
                                          if (widget.billerData![index]
                                                  .lASTBILLAMOUNT !=
                                              null)
                                            verticalSpacer(
                                                width(context) * 0.02),
                                          if (widget.billerData![index]
                                                  .lASTBILLAMOUNT !=
                                              null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    data: 'Last Bill Amount',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor),
                                                appText(
                                                    data:
                                                        '$rupee ${widget.billerData![index].lASTBILLAMOUNT}',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor)
                                              ],
                                            ),
                                          if (widget.billerData![index]
                                                  .lASTPAIDDATE !=
                                              null)
                                            verticalSpacer(
                                                width(context) * 0.02),
                                          if (widget.billerData![index]
                                                  .lASTPAIDDATE !=
                                              null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    data: 'Last Paid On',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor),
                                                appText(
                                                    data: widget
                                                                .billerData![
                                                                    index]
                                                                .lASTPAIDDATE !=
                                                            null
                                                        ? DateFormat(
                                                                'dd/MM/yyyy')
                                                            .format(DateTime.parse(widget
                                                                    .billerData![
                                                                        index]
                                                                    .lASTPAIDDATE
                                                                    .toString())
                                                                .toLocal())
                                                            .toString()
                                                        : "",
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor)
                                              ],
                                            ),
                                          if (getdueAmount(index) != "")
                                            verticalSpacer(
                                                width(context) * 0.02),
                                          if (getdueAmount(index) != "")
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    data: 'Bill Due',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor),
                                                appText(
                                                    data:
                                                        "$rupee ${getdueAmount(index)}",
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor)
                                              ],
                                            ),
                                          if (getdueDate(index) != "")
                                            verticalSpacer(
                                                width(context) * 0.02),
                                          if (getdueDate(index) != "")
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    data: 'Due Date',
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor),
                                                appText(
                                                    data: getdueDate(index) !=
                                                            null
                                                        ? DateFormat(
                                                                'dd/MM/yyyy')
                                                            .format(DateTime.parse(
                                                                    getdueDate(
                                                                        index))
                                                                .add(Duration(
                                                                    days: 1)))
                                                        : "-",
                                                    size:
                                                        width(context) * 0.035,
                                                    color: txtSecondaryColor)
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                // else if (widget
                                //             .billerData![index].aUTOPAYID ==
                                //         null &&
                                //     widget.billerData![index].cUSTOMERBILLID !=
                                //         null &&
                                //     widget.billerData![index]
                                //             .tRANSACTIONSTATUS ==
                                //         "success" &&
                                //     widget.billerData![index]
                                //             .bILLERACCEPTSADHOC ==
                                //         "N")
                                //   showAutoPay(widget.billerData![index])
                                else
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width(context) * 0.016,
                                        right: width(context) * 0.032,
                                        top: width(context) * 0.016,
                                        bottom: width(context) * 0.016),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        appText(
                                            data: widget.billerData![index]
                                                .cATEGORYNAME,
                                            size: width(context) * 0.035,
                                            color: txtSecondaryColor),
                                        appText(
                                          data: widget.billerData![index]
                                                  .cATEGORYNAME
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains("mobile prepaid")
                                              ? widget.billerData![index]
                                                  .pARAMETERS!
                                                  .firstWhere(
                                                    (param) =>
                                                        param.pARAMETERNAME
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'mobile number',
                                                  )
                                                  .pARAMETERVALUE
                                              : widget.billerData![index]
                                                  .pARAMETERVALUE,
                                          size: width(context) * 0.035,
                                          color: txtAmountColor,
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          iconAppHomeSvg,
                          height: height(context) * 0.10,
                        ),
                        verticalSpacer(width(context) * 0.04),
                        appText(
                            data: "You have No Saved Biller",
                            size: 16.6,
                            color: txtPrimaryColor)
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionScreenUI extends StatefulWidget {
  List<ChartData>? data;

  TransactionScreenUI({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<TransactionScreenUI> createState() => _TransactionScreenUIState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  String x;
  double y;
}

String formatISOTime(DateTime date) {
  //converts date into the following format:
// or 2019-06-04T12:08:56.235-0700
  var duration = date.timeZoneOffset;
  if (duration.isNegative)
    return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
        "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  else
    return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
        "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
}

class _TransactionScreenUIState extends State<TransactionScreenUI> {
  List<ChartData>? allChartData = [];
  List<_ChartData>? tnxData = [];
  int successCount = 0;
  int failedCount = 0;
  List<double> amount = [];
  late TooltipBehavior _tooltip;
  double totalSpend = 0.0;

  String selectedOption = "";
  List<Map<String, dynamic>> optionsList = [
    {"label": "All Past Months", "value": 0, "month": 0, "year": 0000}
  ];
  int dpYear = 2000;
  int dpMonth = 1;
  int dpDay = 1;
  int dYear = 2090;
  int dMonth = 1;
  int dDay = 1;
  @override
  void initState() {
    allChartData = widget.data;
    selectedOption = optionsList[0]['value'].toString();
    // log(widget.data![0].tRANSACTIONSTATUS.toString(), name: "status::::::");
    var dpch = DateTime.parse(
        allChartData![allChartData!.length - 1].cOMPLETIONDATE.toString());

    log(jsonEncode(widget.data).toString(), name: "status::::::");
    // List<dynamic> filteredData = widget.data!
    //     .where((item) => DateTime.parse(item.cOMPLETIONDATE.toString())
    //         .isAfter(DateTime(dpch.year as int, dpch.month as int, 1)))
    //     .toList();
    log(widget.data!.length.toString(), name: "widget.data!::");
    List<dynamic> filteredData = widget.data!
        .where((item) =>
            DateTime.parse(item.cOMPLETIONDATE.toString())
                .isAfter(DateTime(dpYear, dpMonth, 1)) &&
            DateTime.parse(item.cOMPLETIONDATE.toString())
                .isBefore(DateTime(2090, 1, 1)))
        .toList();
    log(filteredData.length.toString(), name: "widget.data!:: 2");

    var failedCountTemp = 0;
    var successCountTemp = 0;
    var tempArr = [];
    // log(DateTime.now().month.toString(), name: "NOW:::");
    var dateList = [];
    var currentDate = DateFormat('y M MMMM').format(DateTime.now());
    for (var tnxItem in filteredData) {
      dateList.add(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(tnxItem.cOMPLETIONDATE.toString())));
      /*
      var formattedCompletionDate = DateFormat('y M MMMM')
          .format(DateTime.parse(tnxItem.cOMPLETIONDATE.toString()));

      // log(formattedCompletionDate, name: "formattedCompletionDate");
      var isContain = tempArr.indexOf(formattedCompletionDate);
      var isCurrent = currentDate == formattedCompletionDate ? true : false;

      // var isContain = tempArr.indexOf(
      //     "${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).year.toString()} ${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).month.toString()}");
      if (isContain == -1 && !isCurrent) {
        tempArr.add(formattedCompletionDate);
        // tempArr.add(
        //     "${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).year.toString()} ${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).month.toString()}");
      }

      // log(DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).month.toString(),
      //     name: "EACH MONTH");
*/
      if (!(tnxItem.tRANSACTIONSTATUS.toString().toLowerCase() == "success")) {
        failedCountTemp += 1;
      } else {
        successCountTemp += 1;
      }

      // log(tnxItem.cOMPLETIONDATE.toString());
      // print(tnxItem.cOMPLETIONDATE.toString() != formatISOTime(DateTime.now()));
      // print(filteredData);

      if (tnxItem.tRANSACTIONSTATUS
          .toString()
          .toLowerCase()
          .contains("success")) {
        if (!doesItContainKey(tnxItem.cATEGORYNAME)) {
          tnxData!.add(_ChartData(tnxItem.cATEGORYNAME.toString(),
              double.parse(tnxItem.bILLAMOUNT.toString())));
        } else {
          tnxData![tnxData!.indexWhere((cat) =>
                  cat.x.toLowerCase() == tnxItem.cATEGORYNAME!.toLowerCase())]
              .y += tnxItem.bILLAMOUNT;
        }

        totalSpend += tnxItem.bILLAMOUNT;
        // successCount++;
      }

      // } else {
      //   if (!doesItContainKey(tnxItem.cATEGORYNAME)) {
      //     tnxData!.add(_ChartData(tnxItem.cATEGORYNAME.toString(),
      //         double.parse(tnxItem.bILLAMOUNT.toString())));
      //   } else {
      //     tnxData![tnxData!.indexWhere((cat) =>
      //             cat.x.toLowerCase() == tnxItem.cATEGORYNAME!.toLowerCase())]
      //         .y += tnxItem.bILLAMOUNT;
      //   }
      //   print('total === ${tnxData!.length.toString()}');
      //   totalSpend += tnxItem.bILLAMOUNT;
      //   successCount++;
      // }
    }
    // log(tempArr.toString(), name: "FINAL ARRAY");

    dateList = dateList.toSet().toList();
    // log(dateList.toString(), name: "dateList: before sorting ::");
    dateList.sort(((a, b) {
      return a.compareTo(b);
    }));
    // log(dateList.toString(), name: "dateList: after sorting ::");

    for (var eachDate in dateList) {
      var formattedCompletionDate =
          DateFormat('y M MMMM').format(DateTime.parse(eachDate.toString()));

      // log(formattedCompletionDate, name: "formattedCompletionDate");
      var isContain = tempArr.indexOf(formattedCompletionDate);
      var isCurrent = currentDate == formattedCompletionDate ? true : false;
      if (isContain == -1 && !isCurrent) {
        tempArr.add(formattedCompletionDate);
        // tempArr.add(
        //     "${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).year.toString()} ${DateTime.parse(tnxItem.cOMPLETIONDATE.toString()).month.toString()}");
      }
    }
    tempArr = tempArr.reversed.toList();
    log(tempArr.toString(), name: "FINAL ARRAY");

    for (int i = 0; i < tempArr.length; i++) {
      var eachArr = tempArr[i].split(" ");
      // log(eachArr.toString(), name: "eachArr::::");
      optionsList.add({
        "label": "${eachArr[2]} ${eachArr[0]}",
        "value": i + 1,
        "month": int.parse(eachArr[1]),
        "year": int.parse(eachArr[0])
      });
    }

    // log(optionsList.toString(), name: "optionsList::::");
    setState(() {
      failedCount = failedCountTemp;
      successCount = successCountTemp;
    });
    // for (var eachData in tnxData!) {
    //   print("*****");
    //   print(eachData.x);
    //   print(eachData.y);
    // }
    // log(tnxData!.length.toString(), name: "BEFORE ALTERED THE MAIN DATA :::");
    // print(tnxData);
    // getMonthlist();

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  fetchItems() {
    setState(() {
      successCount = 0;
      failedCount = 0;
      totalSpend = 0;
    });

    var successCountTemp = 0;
    var failedCountTemp = 0;
    num totalSpendTemp = 0;
    allChartData = widget.data;
    // selectedOption = optionsList[0]['value'].toString();
    var dpch = DateTime.parse(
        allChartData![allChartData!.length - 1].cOMPLETIONDATE.toString());

    // log(widget.data.toString(), name: "status::::::");
    // List<dynamic> filteredData = widget.data!
    //     .where((item) => DateTime.parse(item.cOMPLETIONDATE.toString())
    //         .isAfter(DateTime(dpch.year as int, dpch.month as int, 1)))
    //     .toList();
    // log(optionsList.toString(), name: "CURRETN OPTIONSLIST");
    log(optionsList[int.parse(selectedOption)]['month'].toString(),
        name: "SELECTED MONTH");

    // var formattedCompletionDate = DateFormat('y M')
    //     .format(DateTime.parse(item.cOMPLETIONDATE.toString()));

    var selectedDate =
        "${optionsList[int.parse(selectedOption)]['year']} ${optionsList[int.parse(selectedOption)]['month']}";
    log(selectedDate, name: "selectedDate::");
    List<dynamic> filteredData = widget.data!;
    if (selectedDate != "0 0") {
      filteredData = widget.data!
          .where((item) =>
              selectedDate.toLowerCase() ==
              (DateFormat('y M')
                  .format(DateTime.parse(item.cOMPLETIONDATE.toString()))))
          .toList();
    }
    // log(jsonEncode(filteredData).toString(), name: "after altering");
    log(selectedOption.toString(), name: "SELECTED OPTION");

    for (var tnxItem in filteredData) {
      if (!(tnxItem.tRANSACTIONSTATUS.toString().toLowerCase() == "success")) {
        failedCountTemp += 1;
      } else {
        successCountTemp += 1;
      }

      // log(tnxItem.cOMPLETIONDATE.toString());
      if (tnxItem.tRANSACTIONSTATUS
          .toString()
          .toLowerCase()
          .contains("success")) {
        if (!doesItContainKey(tnxItem.cATEGORYNAME)) {
          tnxData!.add(_ChartData(tnxItem.cATEGORYNAME.toString(),
              double.parse(tnxItem.bILLAMOUNT.toString())));
        } else {
          tnxData![tnxData!.indexWhere((cat) =>
                  cat.x.toLowerCase() == tnxItem.cATEGORYNAME!.toLowerCase())]
              .y += tnxItem.bILLAMOUNT;
        }

        totalSpendTemp += tnxItem.bILLAMOUNT;
        // successCountTemp++;
      }
    }
    setState(() {
      successCount = successCountTemp;
      totalSpend = double.parse(totalSpendTemp.toString());

      failedCount = failedCountTemp;
    });
    for (var eachData in tnxData!) {
      print("*****");
      print(eachData.x);
      print(eachData.y);
    }
  }

  bool doesItContainKey(var key) {
    return tnxData!.any((element) => element.x.contains(key));
  }

  // @override
  // void didUpdateWidget(TransactionScreenUI oldWidget) {
  //   debugPrint('State didUpdateWidget');
  //   super.didUpdateWidget(oldWidget);
  // }

  onOptionFilter(int index) {
    // List<ChartData> alereed = allChartData!.where((element) {
    //   log(selectedOption.toString(), name: "selectedOption:::");
    //   log(DateTime.parse(element.cOMPLETIONDATE!).month.toString(),
    //       name: "INSIDE OPTIONFILER()");
    //   return true;
    // }).toList();
    // print(optionsList[index.toInt()]);
    var curDateTime = DateTime.now();
    int curMonth = curDateTime.month;
    var thisMonthFirstDay = DateTime(curDateTime.year, curDateTime.month, 1);

    DateTime lastMonthlastDay = thisMonthFirstDay.subtract(Duration(days: 1));
    int curMonthYear = thisMonthFirstDay.year;
    int previousMonthYear = lastMonthlastDay.year;
    if (index == 1) {
      setState(() {
        dpYear = optionsList[index.toInt()]['year'] as int;
        dpMonth = optionsList[index.toInt()]['month'] as int;
        dYear = 2023;
        dMonth = 3;
      });
    } else if (index == 2) {
      setState(() {
        dpYear = optionsList[index.toInt()]['year'] as int;
        dpMonth = optionsList[index.toInt()]['month'] as int;
        dYear = previousMonthYear;
        dMonth = curMonth;
      });
    } else {
      setState(() {
        dpYear = 2000;
        dpMonth = 1;
        dYear = 2090;
        dMonth = 1;
      });
    }

    List<ChartData> altered = allChartData!
        .where((element) =>
            int.parse(optionsList[index]['month'].toString()) ==
                int.parse(
                    DateTime.parse(element.cOMPLETIONDATE!).month.toString()) &&
            int.parse(optionsList[index]['year'].toString()) ==
                int.parse(
                    DateTime.parse(element.cOMPLETIONDATE!).year.toString()))
        .toList();
    List<_ChartData>? temptnxData = [];
    if (altered.isNotEmpty) {
      tnxData = temptnxData;
      for (var element in altered) {
        if (element.tRANSACTIONSTATUS
            .toString()
            .toLowerCase()
            .contains("success")) {
          if (!doesItContainKey(element.cATEGORYNAME)) {
            tnxData!.add(_ChartData(element.cATEGORYNAME.toString(),
                double.parse(element.bILLAMOUNT.toString())));
          } else {
            tnxData![tnxData!.indexWhere((cat) =>
                    cat.x.toLowerCase() == element.cATEGORYNAME!.toLowerCase())]
                .y += element.bILLAMOUNT;
          }
        }
      }
    } else if (altered.isEmpty && optionsList[index]['month'] != 0) {
    } else {
      tnxData!.clear();
      for (var element in widget.data!) {
        if (element.tRANSACTIONSTATUS
            .toString()
            .toLowerCase()
            .contains("success")) {
          if (!doesItContainKey(element.cATEGORYNAME)) {
            tnxData!.add(_ChartData(element.cATEGORYNAME.toString(),
                double.parse(element.bILLAMOUNT.toString())));
          } else {
            tnxData![tnxData!.indexWhere((cat) =>
                    cat.x.toLowerCase() == element.cATEGORYNAME!.toLowerCase())]
                .y += element.bILLAMOUNT;
          }
        }
      }
    }

    // log(tnxData.toString(), name: "tnxData :::: ");
  }

  getMonthlist() {
    int dataLength = allChartData!.length;
    var lastPaidOn =
        DateTime.parse(allChartData![dataLength - 1].cOMPLETIONDATE.toString());

    optionsList.add({
      "label": "${calendarMonths[lastPaidOn.month - 1]} ${lastPaidOn.year}",
      "value": lastPaidOn.month,
      "month": lastPaidOn.month,
      "year": lastPaidOn.year
    });

    if (lastPaidOn.month != 1) {
      optionsList.add({
        "label": "${calendarMonths[lastPaidOn.month - 2]} ${lastPaidOn.year}",
        "value": lastPaidOn.month - 1,
        "month": lastPaidOn.month - 1,
        "year": lastPaidOn.year
      });
    } else {
      optionsList.add({
        "label": "${calendarMonths.last} ${lastPaidOn.year - 1}",
        "value": 12,
        "month": 12,
        "year": (lastPaidOn.year - 1)
      });
      print("_--------------------" + (lastPaidOn.year - 1).toString());
    }

    log(optionsList.toString(), name: "OPTIONSLIST");
  }

  final LinearGradient _linearGradient = LinearGradient(
    colors: <Color>[
      Colors.purpleAccent.shade700,
      Colors.purpleAccent.shade100,
    ],
    stops: const <double>[
      0.2,
      1.0,
    ],
    transform: const GradientRotation((135 * (3.8 / 180))),
    end: Alignment.topRight,
  );

  countText(icon, iconColor, word, number, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            appText(
              data: word,
              size: width(context) * 0.035,
              color: txtSecondaryColor,
            )
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        appText(
          data: number,
          size: width(context) * 0.04,
          color: primaryColor,
          weight: FontWeight.bold,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      width: width(context),
      decoration: BoxDecoration(
        color: txtColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: width(context) * 0.040),
            child: Align(
              alignment: Alignment.topLeft,
              child: appText(
                  data: "Transaction Detail",
                  size: width(context) * 0.045,
                  weight: FontWeight.bold,
                  color: txtPrimaryColor),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryBodyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                //Amount
                Container(
                  // height: height(context) / 8,
                  margin: EdgeInsets.only(
                      top: width(context) * 0.008,
                      right: width(context) * 0.008,
                      left: width(context) * 0.008),
                  decoration: BoxDecoration(
                    color: txtColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: width(context) * 0.040),
                    child: Row(
                      children: [
                        SvgPicture.asset(rupeeSvg),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width(context) * 0.040,
                            top: width(context) * 0.040,
                            bottom: width(context) * 0.040,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              appText(
                                data: "Total Paid Amount",
                                size: width(context) * 0.035,
                                color: txtSecondaryColor,
                              ),
                              appText(
                                data:
                                    "$rupee ${NumberFormat('#,##,##0.00').format(double.parse(totalSpend.toStringAsFixed(2)))}",
                                // data: "$rupee ${totalSpend.toStringAsFixed(2)}",
                                size: width(context) * 0.04,
                                color: primaryColor,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Success & Failure
                Container(
                  height: height(context) / 9.5,
                  margin: EdgeInsets.only(
                    top: width(context) * 0.008,
                    right: width(context) * 0.008,
                    left: width(context) * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: txtColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: width(context) * 0.040,
                      left: width(context) * 0.016,
                      top: width(context) * 0.040,
                      bottom: width(context) * 0.040,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        countText(
                          Icons.check,
                          alertSuccessColor,
                          "  Success",
                          successCount.toString(),
                          context,
                        ),
                        VerticalDivider(
                          color: dashColor,
                          indent: 2,
                          endIndent: 2,
                          thickness: 1,
                        ),
                        countText(
                          Icons.close_rounded,
                          alertFailedColor,
                          "  Failed",
                          failedCount.toString(),
                          context,
                        ),
                      ],
                    ),
                  ),
                ),
                //Date & Graph
                Container(
                    margin: EdgeInsets.only(
                      top: width(context) * 0.008,
                      left: width(context) * 0.008,
                      right: width(context) * 0.008,
                    ),
                    height: height(context) / 2,
                    width: width(context),
                    decoration: BoxDecoration(
                      color: txtColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width(context) * 0.040),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(spreadRadius: 1, color: divideColor)
                                ],
                                color: txtColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width(context) * 0.040,
                                  right: width(context) * 0.040),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: selectedOption,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: 16,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: txtPrimaryColor),
                                  // underline: Container(
                                  //   height: 2,
                                  //   color: Colors.deepPurpleAccent,
                                  // ),
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  onChanged: (String? value) {
                                    int findOpt = optionsList.indexWhere((e) =>
                                        e["value"].toString() ==
                                        value.toString());

                                    // print("---------------$findOpt");
                                    log(value.toString(), name: "value ::::");

                                    log(findOpt.toString(),
                                        name: "findOpt :::::");

                                    onOptionFilter(findOpt);
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                    fetchItems();
                                  },
                                  items: optionsList.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item["value"].toString(),
                                      child: Text(item["label"]),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // chart widget

                        tnxData!.isNotEmpty
                            ? SfCartesianChart(
                                onTooltipRender: (TooltipArgs args) {
                                  //Tooltip with X and Y positions of data points
                                  args.header = '';
                                  // args.text =
                                  //     '${args.locationX!.floor()} : ${args.locationY!.floor()}';
                                },
                                enableAxisAnimation: true,
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                  numberFormat: NumberFormat.compactCurrency(
                                    locale: 'en_UK',
                                    symbol: "₹",
                                  ),
                                  rangePadding: ChartRangePadding.normal,
                                ),
                                tooltipBehavior: _tooltip,
                                series: <ChartSeries<_ChartData, String>>[
                                    ColumnSeries<_ChartData, String>(
                                      gradient: _linearGradient,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(33),
                                          topRight: Radius.circular(33)),
                                      width: tnxData!.length < 2 ? 0.1 : 0.21,
                                      dataSource: tnxData!,

                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,

                                      // name: tnxData[],
                                      // color: Color.fromRGBO(8, 142, 255, 1),
                                    )
                                  ])
                            : SizedBox(
                                height: height(context) / 3.5,
                                child: Center(
                                  child: Column(
                                    children: [
                                      verticalSpacer(width(context) * 0.13),
                                      SvgPicture.asset(
                                        NodataFoundSvg,
                                        height: height(context) * 0.15,
                                      ),
                                      verticalSpacer(width(context) * 0.07),
                                      appText(
                                          data: "No Data Available",
                                          size: 14.6,
                                          color: primaryColor)
                                    ],
                                  ),
                                )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
