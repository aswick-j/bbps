import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/prepaid_fetch_plans_model.dart';
import 'package:bbps/utils/commen.dart';
import 'package:bbps/utils/const.dart';
import 'package:bbps/utils/utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class PrepaidPlanItem extends StatefulWidget {
  String? categoryType;

  List<PrepaidPlansData>? prepaidPlansData = [];
  dynamic updateSelectedPlan;
  PrepaidPlanItem(
      {Key? key,
      this.categoryType,
      this.prepaidPlansData,
      this.updateSelectedPlan});

  @override
  State<PrepaidPlanItem> createState() => _PrepaidPlanItemState();
}

class _PrepaidPlanItemState extends State<PrepaidPlanItem> {
  List<PrepaidPlansData> prepaidPlansData = [];

  @override
  void didUpdateWidget(covariant PrepaidPlanItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getDatta();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatta();
  }

  getDatta() {
    List<PrepaidPlansData>? tempList = widget.prepaidPlansData;

    if (widget.categoryType.toString().toLowerCase() != "all") {
      tempList = widget.prepaidPlansData!
          .where((element) => element.categoryType == widget.categoryType)
          .toList();
    }
    setState(() {
      prepaidPlansData = tempList!;
    });

    //logConsole(prepaidPlansData.length.toString(), name: "prepaidPlansData lengths::");

    logConsole(jsonEncode(prepaidPlansData).toString(), "prepaidPlansData::");
  }

  NumberFormat rupeeFormatWithSymbol =
      NumberFormat.currency(locale: "en_IN", symbol: '₹', name: '');
  rupeeCov(numb) {
    dynamic data;
    data = rupeeFormatWithSymbol.format(numb);
    var rupee = data.split('.');
    return rupee[0];
  }

  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var item in prepaidPlansData)
          InkWell(
            onTap: () {
              widget.updateSelectedPlan!(item);
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: width(context) * 0.02,
                right: width(context) * 0.02,
                left: width(context) * 0.02,
              ),
              // height: height(context) / 4.7,
              // width: width(context) / 1.25,
              padding: EdgeInsets.only(
                right: width(context) * 0.02,
                left: width(context) * 0.02,
                bottom: width(context) * 0.02,
              ),
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  if (widget.categoryType!.toString().toLowerCase() == "all" &&
                      item.categoryType!.toString().toLowerCase() ==
                          "unlimited" &&
                      item.amount! <= 600 &&
                      item.amount! >= 200)
                    Positioned(
                      top: 0,
                      right: 2,
                      child: Container(
                        height: height(context) * 0.022,
                        width: width(context) * 0.18,
                        decoration: BoxDecoration(
                            color: txtCheckBalanceColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: Text("Popular",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontSize: width(context) * 0.03,
                              fontFamily: appFont,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ),
                  /*  if (widget.categoryType!.toString().toLowerCase() == "all" &&
                      item.categoryType!.toString().toLowerCase() ==
                          "int_roaming")
                    Positioned(
                      top: 0,
                      right: 2,
                      child: Container(
                        height: height(context) * 0.022,
                        width: width(context) * 0.18,
                        decoration: BoxDecoration(
                            color: alertSuccessColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: Text("Roaming",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontSize: width(context) * 0.03,
                              fontFamily: appFont,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ),
                  if (widget.categoryType!.toString().toLowerCase() == "all" &&
                      item.categoryType!.toString().toLowerCase() == "recharge")
                    Positioned(
                      top: 0,
                      right: 2,
                      child: Container(
                        height: height(context) * 0.022,
                        width: width(context) * 0.18,
                        decoration: BoxDecoration(
                            color: alertPendingColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: Text("New",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontSize: width(context) * 0.03,
                              fontFamily: appFont,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ), */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          tilePadding: EdgeInsets.symmetric(horizontal: 0),
                          title: InkWell(
                            onTap: () {
                              widget.updateSelectedPlan!(item);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                appText(
                                    data: rupeeCov(item.amount),
                                    size: width(context) * 0.05,
                                    weight: FontWeight.w600,
                                    color: txtCheckBalanceColor),
                                Expanded(
                                  child: ListTile(
                                    dense: true,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    title: appText(
                                        data: 'Data',
                                        size: width(context) * 0.032,
                                        color: txtSecondaryColor,
                                        weight: FontWeight.w400),
                                    subtitle: appText(
                                        data: item.planAdditionalInfo!.data,
                                        flowType: TextOverflow.visible,
                                        size: width(context) * 0.032,
                                        color: txtPrimaryColor,
                                        maxline: 1,
                                        weight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    dense: true,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    title: appText(
                                        data: 'Talktime',
                                        size: width(context) * 0.032,
                                        color: txtSecondaryColor,
                                        weight: FontWeight.w400),
                                    subtitle: appText(
                                        data: item.planAdditionalInfo!.talktime,
                                        size: width(context) * 0.032,
                                        color: txtPrimaryColor,
                                        maxline: 1,
                                        weight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    dense: true,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    title: appText(
                                        data: 'Validity',
                                        size: width(context) * 0.032,
                                        color: txtSecondaryColor,
                                        weight: FontWeight.w400),
                                    subtitle: appText(
                                        data: item.planAdditionalInfo!.validity,
                                        flowType: TextOverflow.visible,
                                        size: width(context) * 0.032,
                                        color: txtPrimaryColor,
                                        maxline: 1,
                                        weight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: appText(
                                    data: item.planDesc,
                                    size: width(context) * 0.031,
                                    color: txtSecondaryColor,
                                    maxline: 5,
                                    weight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (item.planAdditionalInfo!.additionalBenefits != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedLine(
                            dashColor: dashColor,
                            dashLength: 15,
                          ),
                        ),
                      if (item.planAdditionalInfo!.additionalBenefits != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: appText(
                            data: 'Additional Benefits:',
                            size: width(context) * 0.035,
                            color: txtPrimaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      if (item.planAdditionalInfo!.additionalBenefits != null)
                        appText(
                          data: item.planAdditionalInfo!.additionalBenefits,
                          maxline: isReadMore ? 10 : 2,
                          size: width(context) * 0.035,
                          flowType: TextOverflow.ellipsis,
                          color: txtPrimaryColor,
                          weight: FontWeight.w500,
                        ),
                      if (item.planAdditionalInfo!.additionalBenefits != null)
                        InkWell(
                          onTap: () {
                            setState(() {
                              isReadMore = !isReadMore;
                            });
                          },
                          child: Text(
                            isReadMore ? "Read less" : "Read more",
                            style: TextStyle(
                                color: txtAmountColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width(context) * 0.035),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
