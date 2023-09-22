import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../bloc/autopay/autopay_cubit.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class UpCommingScheduleScreen extends StatefulWidget {
  const UpCommingScheduleScreen({Key? key}) : super(key: key);

  @override
  State<UpCommingScheduleScreen> createState() =>
      _UpCommingScheduleScreenState();
}

class _UpCommingScheduleScreenState extends State<UpCommingScheduleScreen> {
  AutoSchedulePayModel? model = AutoSchedulePayModel();
  List<UpcomingPayments>? upcomingPaymentList = [];
  @override
  void initState() {
    BlocProvider.of<AutopayCubit>(context).getUpcomingPay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AutopayCubit, AutopayState>(
        listener: (context, state) {
          if (state is AutopayUpcomingLoading) {
            if (!Loader.isShown) {
              showLoader(context);
            }
          } else if (state is AutopayUpcomingSuccess) {
            if (Loader.isShown) {
              Loader.hide();
            } // log(state.autoSchedulePayModel!.data!.upcomingPayments!.first.data!.first.bILLERNAME.toString(),name: "Upcoming : ");
            model = state.autoSchedulePayModel;
            upcomingPaymentList = model!.data!.upcomingPayments!;
          } else if (state is AutopayUpcomingFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            showSnackBar(state.message, context);
          } else if (state is AutopayUpcomingError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          if (state is AutopayUpcomingLoading) {
            return Center(
              child: Image.asset(
                "assets/images/loader.gif",
                height: height(context) * 0.07,
                width: height(context) * 0.07,
              ),
            );
          }
          return UpCommingScheduleScreenUI(
            upcomingPaymentList: upcomingPaymentList,
            model: model,
          );
        },
      ),
    );
  }
}

class UpCommingScheduleScreenUI extends StatefulWidget {
  final AutoSchedulePayModel? model;
  List<UpcomingPayments>? upcomingPaymentList;
  UpCommingScheduleScreenUI(
      {Key? key, @required this.model, @required this.upcomingPaymentList})
      : super(key: key);

  @override
  State<UpCommingScheduleScreenUI> createState() =>
      _UpCommingScheduleScreenUIState();
}

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

class _UpCommingScheduleScreenUIState extends State<UpCommingScheduleScreenUI> {
  // bool toggle = false;
  final DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      body: widget.upcomingPaymentList!.isNotEmpty
          ? ListView.builder(
              itemCount: widget.upcomingPaymentList!.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.upcomingPaymentList![index].data!.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: txtColor),
                        margin: EdgeInsets.all(width(context) * 0.044),
                        // height: height(context) / 3.5,
                        width: width(context) / 1.25,
                        padding: EdgeInsets.only(
                          top: width(context) * 0.016,
                          right: width(context) * 0.016,
                          left: width(context) * 0.016,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width(context) * 0.016),
                              leading: Image.asset(
                                bNeumonic,
                                height: height(context) * 0.07,
                              ),
                              title: widget.upcomingPaymentList![index].data![i]
                                          .pAYMENTDATE ==
                                      todaysDate
                                  ? UnconstrainedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 3,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: pillColor),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Today',
                                                style: TextStyle(
                                                  color: txtAmountColor,
                                                  fontSize:
                                                      width(context) * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : UnconstrainedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 3,
                                        padding: EdgeInsets.all(2.3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: pillColor),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: widget
                                                    .upcomingPaymentList![index]
                                                    .data![i]
                                                    .pAYMENTDATE,
                                                style: TextStyle(
                                                  color: txtAmountColor,
                                                  fontSize:
                                                      width(context) * 0.035,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Transform.translate(
                                                  offset: const Offset(1, -6),
                                                  child: Text(
                                                    "${getDayOfMonthSuffix(int.parse(widget.upcomingPaymentList![index].data![i].pAYMENTDATE.toString()))}",
                                                    //superscript is usually smaller in size
                                                    textScaleFactor: 0.8,
                                                    style: TextStyle(
                                                        color: txtAmountColor,
                                                        fontSize:
                                                            width(context) *
                                                                0.035),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  of This Month',
                                                style: TextStyle(
                                                  color: txtAmountColor,
                                                  fontSize:
                                                      width(context) * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(
                                    top: width(context) * 0.015),
                                child: RichText(
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  text: TextSpan(
                                    text: widget.upcomingPaymentList![index]
                                        .data![i].bILLNAME,
                                    style: TextStyle(
                                      color: txtPrimaryColor,
                                      fontSize: width(context) * 0.03,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appFont,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                            color: txtPrimaryColor,
                                            fontSize: width(context) * 0.03,
                                          )),
                                      TextSpan(
                                          text: widget
                                              .upcomingPaymentList![index]
                                              .data![i]
                                              .bILLERNAME,
                                          style: TextStyle(
                                            color: txtPrimaryColor,
                                            fontSize: width(context) * 0.03,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFont,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              trailing: SizedBox(
                                  height: height(context) * 0.03,
                                  child:
                                      widget.upcomingPaymentList![index]
                                                  .data![i].pAYMENTDATE ==
                                              now.day.toString()
                                          ? null
                                          : CupertinoSwitch(
                                              value: widget.upcomingPaymentList![index].data![i].iSACTIVE == 1
                                                  ? true
                                                  : false,
                                              onChanged:
                                                  (newValue) =>
                                                      widget
                                                                  .upcomingPaymentList![
                                                                      index]
                                                                  .data![i]
                                                                  .pAYMENTDATE ==
                                                              now.day.toString()
                                                          ? showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  elevation: 16,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            11.2),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    height:
                                                                        height(context) /
                                                                            4,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          appText(
                                                                            data:
                                                                                "Alert!",
                                                                            size:
                                                                                width(context) * 0.05,
                                                                            color:
                                                                                txtPrimaryColor,
                                                                            weight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 16, bottom: 16),
                                                                            child: appText(
                                                                                data: "Completed auto payments will be reflected in History section",
                                                                                // "Biller cannot be deleted as auto pay date is set for today",
                                                                                maxline: 6,
                                                                                align: TextAlign.justify,
                                                                                size: width(context) * 0.03,
                                                                                color: txtSecondaryColor,
                                                                                weight: FontWeight.w500),
                                                                          ),
                                                                          myAppButton(
                                                                            context:
                                                                                context,
                                                                            buttonName:
                                                                                "Okay",
                                                                            margin:
                                                                                const EdgeInsets.only(
                                                                              right: 40,
                                                                              left: 40,
                                                                              top: 0,
                                                                            ),
                                                                            onpress: () =>
                                                                                goBack(context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                          : customDialog(
                                                              context: context,
                                                              message: widget.upcomingPaymentList![index].data![i].iSACTIVE == 1
                                                                  ? "You are stopping the currently scheduled payment and this is a one time thing. If you want to permanently disable auto pay for this bill, delete it from the list of billers configured for auto payment. You can resume this payment anytime before the date of payment."
                                                                  : "Please confirm you want to allow the payment scheduled for auto pay.",
                                                              message2: "",
                                                              message3: "",
                                                              title: widget.upcomingPaymentList![index].data![i].iSACTIVE ==
                                                                      1
                                                                  ? "Stop Autopay"
                                                                  : "Enable Autopay",
                                                              buttonName:
                                                                  "Confirm",
                                                              isMultiBTN: true,
                                                              dialogHeight: widget
                                                                          .upcomingPaymentList![
                                                                              index]
                                                                          .data![
                                                                              i]
                                                                          .iSACTIVE ==
                                                                      1
                                                                  ? height(context) /
                                                                      2.3
                                                                  : height(context) /
                                                                      2.6,
                                                              buttonAction: () {
                                                                Navigator.pop(
                                                                    context);
                                                                goToData(
                                                                    context,
                                                                    otpRoute,
                                                                    {
                                                                      "from":
                                                                          fromUpcomingDisable,
                                                                      "templateName": widget.upcomingPaymentList![index].data![i].iSACTIVE ==
                                                                              1
                                                                          ? "enable-auto-pay"
                                                                          : "disable-auto-pay",
                                                                      "data": {
                                                                        "id": widget
                                                                            .upcomingPaymentList![index]
                                                                            .data![i]
                                                                            .iD,
                                                                        "status": widget.upcomingPaymentList![index].data![i].iSACTIVE ==
                                                                                1
                                                                            ? "0"
                                                                            : "1",
                                                                        "billerName": widget
                                                                            .upcomingPaymentList![index]
                                                                            .data![i]
                                                                            .bILLERNAME
                                                                      }
                                                                    });
                                                              },
                                                              iconSvg:
                                                                  alertSvg))),
                            ),
                            Divider(
                              thickness: 1,
                              indent: 8.0,
                              endIndent: 8.0,
                              color: divideColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width(context) * 0.016,
                                  right: width(context) * 0.044,
                                  top: width(context) * 0.016,
                                  bottom: width(context) * 0.016),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'From AC',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data: widget.upcomingPaymentList![index]
                                          .data![i].aCCOUNTNUMBER,
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              indent: 8.0,
                              endIndent: 8.0,
                              color: divideColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width(context) * 0.016,
                                  right: width(context) * 0.044,
                                  top: width(context) * 0.016,
                                  bottom: width(context) * 0.016),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Amount',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data:
                                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.upcomingPaymentList![index].data![i].mAXIMUMAMOUNT.toString()))}",
                                      size: width(context) * 0.04,
                                      weight: FontWeight.w500,
                                      color: txtAmountColor),
                                ],
                              ),
                            ),
                            if (widget.upcomingPaymentList![index].data![i]
                                    .pAYMENTDATE ==
                                now.day.toString())
                              Divider(
                                thickness: 1,
                                indent: 8.0,
                                endIndent: 8.0,
                                color: divideColor,
                              ),
                            if (widget.upcomingPaymentList![index].data![i]
                                    .pAYMENTDATE ==
                                now.day.toString())
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: width(context) * 0.025),
                                child: appText(
                                    data:
                                        "Completed auto payments will be reflected in History section",
                                    size: width(context) * 0.028,
                                    color: alertWaitingColor),
                              )
                          ],
                        ),
                      );
                    });
              })
          : Center(
              child: appText(
                  data: "No payments are scheduled right now!",
                  size: width(context) * 0.04,
                  color: txtPrimaryColor,
                  weight: FontWeight.w600),
            ),
    );
  }
}
