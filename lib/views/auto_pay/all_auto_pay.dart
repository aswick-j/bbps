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

class AllAutoPayScreen extends StatefulWidget {
  const AllAutoPayScreen({Key? key}) : super(key: key);

  @override
  State<AllAutoPayScreen> createState() => _AllAutoPayScreenState();
}

class _AllAutoPayScreenState extends State<AllAutoPayScreen> {
  AutoSchedulePayModel? autoSchedulePayData = AutoSchedulePayModel();
  List<AllConfigurations>? autoPaymentList = [];
  @override
  void initState() {
    BlocProvider.of<AutopayCubit>(context).getAutopay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AutopayCubit, AutopayState>(
        listener: (context, state) {
          if (state is AutopayLoading) {
            if (!Loader.isShown) {
              showLoader(context);
            }
          } else if (state is AutopaySuccess) {
            autoSchedulePayData = state.autoSchedulePayData;
            autoPaymentList = autoSchedulePayData!.data!.allConfigurations!;
            if (Loader.isShown) {
              Loader.hide();
            }
          } else if (state is AutopayFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            showSnackBar(state.message, context);
          } else if (state is AutopayError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          if (state is AutopayLoading) {
            return Center(
              child: Image.asset(
                "assets/images/loader.gif",
                height: height(context) * 0.07,
                width: height(context) * 0.07,
              ),
            );
          }
          return AllAutoPayScreenUI(
            autoSchedulePayData: autoSchedulePayData,
            allAutoPaymentList: autoPaymentList,
          );
        },
      ),
    );
  }
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

class AllAutoPayScreenUI extends StatefulWidget {
  final AutoSchedulePayModel? autoSchedulePayData;
  List<AllConfigurations>? allAutoPaymentList;
  AllAutoPayScreenUI(
      {Key? key, this.autoSchedulePayData, @required this.allAutoPaymentList})
      : super(key: key);

  @override
  State<AllAutoPayScreenUI> createState() => _AllAutoPayScreenUIState();
}

class _AllAutoPayScreenUIState extends State<AllAutoPayScreenUI> {
  // bool toggle = false;
  // bool isAutopayEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      body: widget.allAutoPaymentList!.isNotEmpty
          ? ListView.builder(
              itemCount: widget.allAutoPaymentList!.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.allAutoPaymentList![index].data!.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: txtColor),
                        margin: EdgeInsets.only(
                          top: width(context) * 0.044,
                          right: width(context) * 0.044,
                          left: width(context) * 0.044,
                        ),
                        // height: height(context) / 4.7,
                        width: width(context) / 1.25,
                        padding: EdgeInsets.only(
                          top: width(context) * 0.004,
                          right: width(context) * 0.004,
                          left: width(context) * 0.004,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width(context) * 0.016),
                                  leading: Image.asset(
                                    bNeumonic,
                                    height: height(context) * 0.07,
                                  ),
                                  title: UnconstrainedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      alignment: Alignment.center,
                                      // width: width(context) * 0.3,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: pillColor),
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: widget
                                                        .allAutoPaymentList![
                                                            index]
                                                        .data![i]
                                                        .aCTIVATESFROM !=
                                                    null
                                                ? "  Enables in ${widget.allAutoPaymentList![index].data![i].aCTIVATESFROM}  "
                                                : "  ${widget.allAutoPaymentList![index].data![i].pAYMENTDATE}  ",
                                            style: TextStyle(
                                              color: txtAmountColor,
                                              fontSize: width(context) * 0.035,
                                            ),
                                          ),
                                          if (widget.allAutoPaymentList![index]
                                                  .data![i].aCTIVATESFROM ==
                                              null)
                                            WidgetSpan(
                                              child: Transform.translate(
                                                offset: const Offset(1, -6),
                                                child: Text(
                                                  getDayOfMonthSuffix(int.parse(
                                                      widget
                                                          .allAutoPaymentList![
                                                              index]
                                                          .data![i]
                                                          .pAYMENTDATE
                                                          .toString())),
                                                  //superscript is usually smaller in size
                                                  textScaleFactor: 0.8,
                                                  style: TextStyle(
                                                      color: txtAmountColor,
                                                      fontSize: width(context) *
                                                          0.035),
                                                ),
                                              ),
                                            ),
                                          if (widget.allAutoPaymentList![index]
                                                  .data![i].aCTIVATESFROM ==
                                              null)
                                            TextSpan(
                                                text: ' of Every Month',
                                                style: TextStyle(
                                                  color: txtAmountColor,
                                                  fontSize:
                                                      width(context) * 0.035,
                                                )),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(
                                        top: width(context) * 0.017),
                                    child: RichText(
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                      text: TextSpan(
                                        text: widget.allAutoPaymentList![index]
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
                                                  .allAutoPaymentList![index]
                                                  .data![i]
                                                  .bILLERNAME,
                                              style: TextStyle(
                                                color: txtPrimaryColor,
                                                fontSize: width(context) * 0.03,
                                                fontFamily: appFont,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: iconColor,
                                    ),
                                    tooltip: "Menu",
                                    onSelected: (value) {
                                      if (value == 1) {
                                        customDialog(
                                            context: context,
                                            message:
                                                "Are you sure you want to delete your bill set up for Auto Pay? Your bill will no longer be paid by us and you will have to pay them manually.",
                                            message2: "",
                                            message3: "",
                                            title: "Alert!",
                                            buttonName: "Delete",
                                            isMultiBTN: true,
                                            dialogHeight: height(context) / 2.5,
                                            buttonAction: () {
                                              Navigator.pop(context, true);
                                              goToData(context, otpRoute, {
                                                "from": fromAutoPayDelete,
                                                "templateName":
                                                    "delete-auto-pay",
                                                "data": widget
                                                    .allAutoPaymentList![index]
                                                    .data![i]
                                              });
                                            },
                                            iconSvg: alertSvg);
                                      } else if (value == 0) {
                                        goToData(context, autoPayEditRoute, {
                                          "customerBillID": widget
                                              .allAutoPaymentList![index]
                                              .data![i]
                                              .cUSTOMERBILLID
                                              .toString(),
                                          "autoPayData": widget
                                              .allAutoPaymentList![index]
                                              .data![i],
                                          "billername": widget
                                              .allAutoPaymentList![index]
                                              .data![i]
                                              .bILLERNAME,
                                          "limit": widget.autoSchedulePayData!
                                              .data!.maxAllowedAmount
                                              .toString()
                                        });
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      if (widget.allAutoPaymentList![index]
                                              .data![i].iSACTIVE ==
                                          1)
                                        const PopupMenuItem(
                                          value: 0,
                                          child: Text('Edit'),
                                        ),
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              indent: 8.0,
                              endIndent: 8.0,
                              color: divideColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width(context) * 0.032,
                                  right: width(context) * 0.032,
                                  top: width(context) * 0.016,
                                  bottom: width(context) * 0.016),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Auto Debit Account',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data: widget.allAutoPaymentList![index]
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
                                  left: width(context) * 0.032,
                                  right: width(context) * 0.032,
                                  top: width(context) * 0.016,
                                  bottom: width(context) * 0.016),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Maximum Bill Limit',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data:
                                          '$rupee ${NumberFormat('#,##,##0.00').format(double.parse(widget.allAutoPaymentList![index].data![i].mAXIMUMAMOUNT.toString()))}',
                                      size: width(context) * 0.035,
                                      color: txtAmountColor),
                                ],
                              ),
                            ),
                            if (widget.allAutoPaymentList![index].data![i]
                                    .iSACTIVE ==
                                0)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width(context) * 0.032,
                                    right: width(context) * 0.032,
                                    top: width(context) * 0.016,
                                    bottom: width(context) * 0.016),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: appText(
                                      data:
                                          "Edit Disabled till Auto Pay enables",
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                ),
                              ),
                          ],
                        ),
                      );
                    });
              })
          : Center(
              child: appText(
                data: "No Auto Payments",
                size: width(context) * 0.04,
                color: txtPrimaryColor,
                weight: FontWeight.w600,
              ),
            ),
    );
  }
}
