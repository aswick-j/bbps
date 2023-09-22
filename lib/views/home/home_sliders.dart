import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../bloc/home/home_cubit.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/chart_model.dart';
import '../../model/saved_billers_model.dart';
import '../../model/upcoming_dues_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../widgets/slider_shimmer.dart';

class HomeSliders extends StatefulWidget {
  const HomeSliders({super.key});

  @override
  State<HomeSliders> createState() => _HomeSliders();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _HomeSliders extends State<HomeSliders> {
  final listViewController = PageController(initialPage: 0);

  List<UpcomingDuesData>? upcomingDuesData = [];
  List<UpcomingPaymentsData>? upcomingPaymentsData = [];
  bool isLoading = true;
  List<Map<String, dynamic>> allSliderData = [];

  // List<SavedBillersData>? billerData;
  List<ChartData>? chartdata = [];
  List<SavedBillersData>? billerData = [];

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllUpcomingDues();
    BlocProvider.of<HomeCubit>(context).getAutopay();
    BlocProvider.of<HomeCubit>(context).getCharts();
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

  void generateSliderData() {
    allSliderData = [];
    if (upcomingDuesData!.isNotEmpty) {
      upcomingDuesData?.forEach((element) {
        final newObj = {
          "itemType": "upcomingDue",
          "typeName": "Upcoming Due",
          "billName": element.billName ?? "",
          "billerName": element.billerName ?? "",
          "dueAmount": element.dueAmount ?? "",
          "dueDate": element.dueDate ?? "",
          "paymentDate": "",
          "customerBillId": element.customerBillID
        };
        allSliderData.add(newObj);
      });
    } else {
      final newObj = {"itemType": "no_upcoming_due"};
      allSliderData.add(newObj);
    }

    log(allSliderData.toString(), name: "AFTER LOOP 1");

    if (upcomingPaymentsData!.length > 0) {
      upcomingPaymentsData?.forEach((element) {
        final newObj = {
          "itemType": "upcomingPayments",
          "typeName": "Upcoming Auto Payment",
          "billName": element.bILLNAME ?? "",
          "billerName": element.bILLERNAME ?? "",
          "dueAmount": element.dUEAMOUNT ?? "",
          "dueDate": element.dUEDATE ?? "",
          "paymentDate": element.pAYMENTDATE ?? ""
        };

        allSliderData.add(newObj);
      });
    } else {
      final newObj = {"itemType": "no_upcoming_payments"};
      allSliderData.add(newObj);
    }

    log(allSliderData.toString(), name: "AFTER LOOP 2");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is SliderLoading) {
          isLoading = true;
        } else if (state is UpcomingDuesLoading) {
          if (!Loader.isShown) {
            showLoader(context);
          }
        } else if (state is AutoPayLoading) {
          if (!Loader.isShown) {
            showLoader(context);
          }
        } else if (state is UpcomingDuesSuccess) {
          if (Loader.isShown) {
            Loader.hide();
          }
          upcomingDuesData = state.upcomingDuesData;
          log(upcomingDuesData!.length.toString(),
              name: "upcomingDuesData LENGTH ::: ");
          generateSliderData();
        } else if (state is UpcomingDuesFailed) {
          if (Loader.isShown) {
            Loader.hide();
          }
          showSnackBar(state.message, context);
        } else if (state is UpcomingDuesError) {
          if (Loader.isShown) {
            Loader.hide();
          }
          goToUntil(context, splashRoute);
        } else if (state is AutopaySuccess) {
          if (Loader.isShown) {
            Loader.hide();
          }
          if (state.autoScheduleData!.upcomingPayments!.isNotEmpty) {
            upcomingPaymentsData =
                state.autoScheduleData!.upcomingPayments![0].data;
          }

          log(upcomingPaymentsData!.length.toString(),
              name: "upcomingPaymentsData LENGTH ::: ");
          generateSliderData();
        } else if (state is MybillChartSuccess) {
          chartdata = state.chartModel!.data ?? [];

          billerData = state.chartModel!.billerData ?? [];
          log(jsonEncode(billerData), name: "im needed value");

          isLoading = false;
        } else if (state is MybillChartLoading) {
        } else if (state is MybillChartFailed) {
          isLoading = false;
          showSnackBar(state.message, context);
        } else if (state is MybillChartError) {
          isLoading = false;
          goToUntil(context, splashRoute);
        }
      },
      builder: (context, state) {
        return !isLoading
            ? Column(
                children: [
                  SizedBox(
                    height: height(context) * 0.22,
                    width: width(context),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: PageView.builder(
                        controller: listViewController,
                        itemCount: allSliderData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: allSliderData[index]['itemType'] ==
                                  "upcomingDue"
                              ? () {
                                  SavedBillersData savedBillersData;
                                  List<SavedBillersData>? billerDataTemp = [];

                                  billerDataTemp = billerData!
                                      .where((element) =>
                                          element.cUSTOMERBILLID
                                              .toString()
                                              .toLowerCase() ==
                                          allSliderData[index]["customerBillId"]
                                              .toString()
                                              .toLowerCase())
                                      .toList();
                                  if (billerDataTemp.isNotEmpty) {
                                    savedBillersData = billerDataTemp[0];
                                    isSavedBillFrom = true;
                                    isMobilePrepaidFrom = false;
                                    goToData(context, confirmPaymentRoute, {
                                      "billID": savedBillersData.cUSTOMERBILLID,
                                      "name": savedBillersData.bILLERNAME,
                                      "number": savedBillersData.pARAMETERVALUE,
                                      "savedBillersData": savedBillersData,
                                      "isSavedBill": true
                                    });
                                  }
                                }
                              : null,
                          child: Container(
                            width: width(context) / 1.17,
                            margin: EdgeInsets.only(
                              right: width(context) * 0.040,
                            ),
                            decoration: BoxDecoration(
                              color: txtColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                if (allSliderData[index]['itemType'] ==
                                        "upcomingPayments" ||
                                    allSliderData[index]['itemType'] ==
                                        "upcomingDue")
                                  Container(
                                    margin:
                                        EdgeInsets.all(width(context) * 0.040),
                                    height: height(context) * 0.12,
                                    child: Row(
                                      children: [
                                        // SvgPicture.asset(
                                        //   cardItem[index]["imageurl"]!,
                                        //   height: height(context) * 0.08,
                                        // ),
                                        Image.asset(
                                          BLogo,
                                          height: height(context) * 0.08,
                                        ),

                                        SizedBox(
                                          // color: Colors.yellow,
                                          width: width(context) * 0.5,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: width(context) * 0.040,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                appText(
                                                  data: allSliderData[index]
                                                      ["typeName"]!,
                                                  size: width(context) * 0.03,
                                                  color: txtSecondaryColor,
                                                ),
                                                appText(
                                                  data: allSliderData[index]
                                                      ["billName"]!,
                                                  size: width(context) * 0.045,
                                                  color: txtPrimaryColor,
                                                  weight: FontWeight.bold,
                                                ),
                                                appText(
                                                  data: allSliderData[index]
                                                      ["billerName"]!,
                                                  size: width(context) * 0.04,
                                                  color: txtSecondaryDarkColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (allSliderData[index]['itemType'] ==
                                        "upcomingPayments" ||
                                    allSliderData[index]['itemType'] ==
                                        "upcomingDue")
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: width(context) * 0.040,
                                      left: width(context) * 0.040,
                                    ),
                                    child: DottedLine(
                                      dashColor: dashColor,
                                    ),
                                  ),
                                if (allSliderData[index]['itemType'] ==
                                        "upcomingPayments" ||
                                    allSliderData[index]['itemType'] ==
                                        "upcomingDue")
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: width(context) * 0.040,
                                        left: width(context) * 0.040,
                                        top: width(context) * 0.016),
                                    height: height(context) * 0.04,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        allSliderData[index]["paymentDate"]
                                                    .length >
                                                0
                                            ? RichText(
                                                text: TextSpan(children: [
                                                TextSpan(
                                                  text: allSliderData[index]
                                                      ["paymentDate"],
                                                  style: TextStyle(
                                                    color:
                                                        txtSecondaryDarkColor,
                                                    fontSize:
                                                        width(context) * 0.035,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: Transform.translate(
                                                    offset: const Offset(1, -6),
                                                    child: Text(
                                                      getDayOfMonthSuffix(int
                                                          .parse(allSliderData[
                                                                  index][
                                                              "paymentDate"]!)),
                                                      textScaleFactor: 0.8,
                                                      style: TextStyle(
                                                          color:
                                                              txtSecondaryDarkColor,
                                                          fontSize:
                                                              width(context) *
                                                                  0.035),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '  of This Month',
                                                  style: TextStyle(
                                                    color:
                                                        txtSecondaryDarkColor,
                                                    fontSize:
                                                        width(context) * 0.035,
                                                  ),
                                                ),
                                              ]))
                                            : appText(
                                                data: allSliderData[index]
                                                            ["dueDate"] !=
                                                        ""
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                                allSliderData[index]
                                                                        [
                                                                        "dueDate"]!
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10))
                                                            .toLocal()
                                                            .add(const Duration(
                                                                days: 1)))
                                                    : "-",
                                                size: width(context) * 0.04,
                                                color: txtSecondaryDarkColor,
                                              ),
                                        appText(
                                            data:
                                                "₹ ${NumberFormat('#,##,##0.00').format(double.parse(allSliderData[index]["dueAmount"]!.toString()))}",
                                            size: width(context) * 0.04,
                                            color: txtAmountColor,
                                            weight: FontWeight.bold),
                                      ],
                                    ),
                                  ),
                                if (allSliderData[index]['itemType'] ==
                                        "no_upcoming_payments" ||
                                    allSliderData[index]['itemType'] ==
                                        "no_upcoming_due")
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height(context) * 0.015,
                                        horizontal: width(context) * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                  width: width(context) / 2.1,
                                                  child: appText(
                                                    data: allSliderData[index]
                                                                ['itemType'] !=
                                                            "no_upcoming_payments"
                                                        ? userName
                                                        : "Hurray !",
                                                    size: width(context) * 0.04,
                                                    maxline: 2,
                                                    weight: FontWeight.bold,
                                                    color: txtPrimaryColor,
                                                  )),
                                              verticalSpacer(
                                                  height(context) * 0.005),
                                              appText(
                                                  data: allSliderData[index]
                                                              ['itemType'] ==
                                                          "no_upcoming_payments"
                                                      ? "You are upto date.\nNo auto payments\nand upcoming dues\nare present."
                                                      : "Kindly register \nauto pay to enable\nauto payments.",
                                                  //  "You are up to date.\nNo upcoming dues\nare present",
                                                  size: width(context) * 0.033,
                                                  color: txtSecondaryColor,
                                                  lineHeight:
                                                      height(context) * 0.002,
                                                  maxline: 4),
                                              verticalSpacer(
                                                  height(context) * 0.005),
                                              if (allSliderData[index]
                                                      ['itemType'] !=
                                                  "no_upcoming_payments")
                                                GestureDetector(
                                                  onTap: (() => goTo(context,
                                                      billerSearchRoute)),
                                                  child: Container(
                                                      width:
                                                          width(context) / 3.3,
                                                      padding: EdgeInsets.all(
                                                          width(context) *
                                                              0.024),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: primaryColor),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: appText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            data: "Add Payment",
                                                            size:
                                                                width(context) *
                                                                    0.033,
                                                            weight: FontWeight
                                                                .bold),
                                                      )),
                                                )
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                equitaspngLogo,
                                                height: height(context) * 0.03,
                                              ),
                                              SvgPicture.asset(
                                                allSliderData[index]
                                                            ['itemType'] ==
                                                        "no_upcoming_payments"
                                                    ? noUpcomingPayment
                                                    : noUpcomingDues,
                                                height: height(context) * 0.15,
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width(context) * 0.020),
                    child: SmoothPageIndicator(
                      controller: listViewController,
                      count: allSliderData.length,
                      effect: ScrollingDotsEffect(
                        dotColor: smoothPageIndicatorColor,
                        activeDotColor: txtAmountColor,
                        dotHeight: height(context) * 0.01,
                        dotWidth: width(context) * 0.02,
                      ),
                    ),
                  ),
                ],
              )
            : const sliderShimmer();
      },
    );
  }
}
