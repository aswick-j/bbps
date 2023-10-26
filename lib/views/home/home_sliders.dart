import 'dart:convert';

import 'package:bbps/bloc/home/home_cubit.dart';
import 'package:bbps/model/auto_schedule_pay_model.dart';
import 'package:bbps/model/chart_model.dart';
import 'package:bbps/model/upcoming_dues_model.dart';
import 'package:bbps/widgets/slider_shimmer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

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

  bool isDataExist(List list, int? value) {
    var data = list.where((row) => (row["customerBillId"] == value));
    if (data.length >= 1) {
      return true;
    } else {
      return false;
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
          "customerBillId": element.customerBillID ?? "-",
          "categoryName": element.categoryName,
          "iSACTIVE": ""
        };

        if (!isDataExist(
            allSliderData, int.parse(element.customerBillID.toString()))) {
          allSliderData.add(newObj);
        }
      });
    } else {
      final newObj = {"itemType": "no_upcoming_due"};
      allSliderData.add(newObj);
    }

    // log(allSliderData.toString(), name: "AFTER LOOP 1");

    if (upcomingPaymentsData!.length > 0) {
      upcomingPaymentsData?.forEach((element) {
        final newObj = {
          "itemType": "upcomingPayments",
          "typeName": "Upcoming Auto Payment",
          "billName": element.bILLNAME ?? "",
          "billerName": element.bILLERNAME ?? "",
          "dueAmount": element.dUEAMOUNT ?? "",
          "dueDate": element.dUEDATE ?? "",
          "paymentDate": element.pAYMENTDATE ?? "",
          "categoryName": element.cATEGORYNAME ?? "",
          "iSACTIVE": element.iSACTIVE ?? "",
          "customerBillId": element.cUSTOMERBILLID ?? "",
        };

        if (isDataExist(
            allSliderData, int.parse(element.cUSTOMERBILLID.toString()))) {
          allSliderData.removeWhere(
              (item) => item["customerBillId"] == element.cUSTOMERBILLID);
        }
        allSliderData.add(newObj);
      });
    } else {
      final newObj = {"itemType": "no_upcoming_payments"};
      allSliderData.add(newObj);
    }

    // log(allSliderData.toString(), name: "AFTER LOOP 2");
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
          logInfo(jsonEncode(upcomingDuesData));
          logConsole(upcomingDuesData!.length.toString(),
              "upcomingDuesData LENGTH ::: ");
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

          logConsole(upcomingPaymentsData!.length.toString(),
              "upcomingPaymentsData LENGTH ::: ");
          generateSliderData();
        } else if (state is MybillChartSuccess) {
          chartdata = state.chartModel!.data ?? [];

          billerData = state.chartModel!.billerData ?? [];
          // log(jsonEncode(billerData), name: "im needed value");

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
                          child: Stack(children: [
                            Container(
                              width: width(context) / 1.1,
                              margin: EdgeInsets.only(
                                left: width(context) * 0.022,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                color: txtColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  if (allSliderData[index]['itemType'] ==
                                          "upcomingPayments" ||
                                      allSliderData[index]['itemType'] ==
                                          "upcomingDue")
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(
                                              width(context) * 0.040),
                                          height: height(context) * 0.12,
                                          child: Row(
                                            children: [
                                              // SvgPicture.asset(
                                              //   cardItem[index]["imageurl"]!,
                                              //   height: height(context) * 0.08,
                                              // ),
                                              // Image.asset(
                                              //   BLogo,
                                              //   height: height(context) * 0.08,
                                              // ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: height(context) *
                                                        0.032),
                                                width: width(context) * 0.13,
                                                height: height(context) * 0.06,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .bottomRight,
                                                        stops: [
                                                          0.1,
                                                          0.9
                                                        ],
                                                        colors: [
                                                          Colors.deepPurple
                                                              .withOpacity(.16),
                                                          Colors.grey
                                                              .withOpacity(.08)
                                                        ])),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                      BillerLogo(
                                                          allSliderData[index]
                                                                  ["billerName"]
                                                              .toString(),
                                                          allSliderData[index][
                                                                  "categoryName"]
                                                              .toString())),
                                                ),
                                              ),

                                              SizedBox(
                                                // color: Colors.yellow,

                                                width: width(context) * 0.63,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top:
                                                        height(context) * 0.035,
                                                    left:
                                                        width(context) * 0.040,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      // appText(
                                                      //     data: allSliderData[
                                                      //             index]
                                                      //         ["typeName"]!,
                                                      //     size: width(context) *
                                                      //         0.03,
                                                      //     color: Colors
                                                      //         .red.shade600,
                                                      //     weight:
                                                      //         FontWeight.bold),
                                                      appText(
                                                        data:
                                                            allSliderData[index]
                                                                ["billName"]!,
                                                        size: width(context) *
                                                            0.045,
                                                        color: txtPrimaryColor,
                                                        weight: FontWeight.bold,
                                                      ),
                                                      appText(
                                                          data: allSliderData[
                                                                  index]
                                                              ["billerName"]!,
                                                          size: width(context) *
                                                              0.04,
                                                          color:
                                                              txtSecondaryDarkColor,
                                                          maxline: 1),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // if (allSliderData[index]['itemType'] ==
                                        //     "upcomingDue")
                                        //   PhysicalModel(
                                        //     color: Colors.white,
                                        //     elevation: 3,
                                        //     shadowColor: Colors.black,
                                        //     borderRadius:
                                        //         BorderRadius.circular(20),
                                        //     child: Container(
                                        //       // height: 30,
                                        //       width: width(context) * 0.25,

                                        //       decoration: BoxDecoration(
                                        //           border: Border.all(
                                        //             width: 1.5,
                                        //             color: Colors.orange.shade600,
                                        //           ),
                                        //           borderRadius:
                                        //               BorderRadius.circular(25)),
                                        //       child: Padding(
                                        //         padding:
                                        //             const EdgeInsets.all(8.0),
                                        //         child: Shimmer.fromColors(
                                        //           baseColor: Colors.red,
                                        //           highlightColor: Colors.yellow,
                                        //           child: Text(
                                        //             'Pay Now',
                                        //             textAlign: TextAlign.center,
                                        //             style: TextStyle(
                                        //               fontSize: 15.0,
                                        //               fontWeight: FontWeight.bold,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                      ],
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
                                          appText(
                                              data:
                                                  "₹ ${NumberFormat('#,##,##0.00').format(double.parse(allSliderData[index]["dueAmount"]!.toString()))}",
                                              size: width(context) * 0.04,
                                              color: txtAmountColor,
                                              weight: FontWeight.bold),
                                          (allSliderData[index]['itemType'] ==
                                                  "upcomingDue")
                                              ? GestureDetector(
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.red,
                                                    highlightColor:
                                                        Colors.yellow,
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Pay Now',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .arrow_right_sharp,
                                                            color:
                                                                txtSecondaryColor)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : allSliderData[index]
                                                              ["paymentDate"]
                                                          .length >
                                                      0
                                                  ? RichText(
                                                      text: TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            allSliderData[index]
                                                                ["paymentDate"],
                                                        style: TextStyle(
                                                          color: Colors
                                                              .red.shade600,
                                                          fontSize:
                                                              width(context) *
                                                                  0.04,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                        child:
                                                            Transform.translate(
                                                          offset: const Offset(
                                                              1, -6),
                                                          child: Text(
                                                            getDayOfMonthSuffix(
                                                                int.parse(allSliderData[
                                                                        index][
                                                                    "paymentDate"]!)),
                                                            textScaleFactor:
                                                                0.8,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade600,
                                                                fontSize: width(
                                                                        context) *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '  of This Month',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .red.shade600,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              width(context) *
                                                                  0.035,
                                                        ),
                                                      ),
                                                    ]))
                                                  : appText(
                                                      data: allSliderData[index]
                                                                  ["dueDate"] !=
                                                              ""
                                                          ? DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime.parse(allSliderData[index]
                                                                          ["dueDate"]!
                                                                      .toString()
                                                                      .substring(0, 10))
                                                                  .toLocal()
                                                                  .add(const Duration(days: 1)))
                                                          : "-",
                                                      size: width(context) * 0.04,
                                                      color: Colors.red.shade600,
                                                      weight: FontWeight.w600),
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
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                                  [
                                                                  'itemType'] !=
                                                              "no_upcoming_payments"
                                                          ? userName
                                                          : "Hurray !",
                                                      size:
                                                          width(context) * 0.04,
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
                                                        ? "You are upto date.\nNo Upcoming auto payments \nare present."
                                                        : "Kindly register \nauto pay to enable\nauto payments.",
                                                    //  "You are up to date.\nNo upcoming dues\nare present",
                                                    size:
                                                        width(context) * 0.033,
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
                                                        width: width(context) /
                                                            3.3,
                                                        padding: EdgeInsets.all(
                                                            width(context) *
                                                                0.024),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            color:
                                                                primaryColor),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              data:
                                                                  "Add Payment",
                                                              size: width(
                                                                      context) *
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
                                                  height:
                                                      height(context) * 0.03,
                                                ),
                                                SvgPicture.asset(
                                                  allSliderData[index]
                                                              ['itemType'] ==
                                                          "no_upcoming_payments"
                                                      ? noUpcomingPayment
                                                      : noUpcomingDues,
                                                  height:
                                                      height(context) * 0.15,
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (allSliderData[index]['itemType'] ==
                                "upcomingDue")
                              Positioned(
                                left: 0,
                                top: height(context) * 0.014,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 16.0),
                                        child: ClipPath(
                                          clipper: ArcClipper(),
                                          child: Container(
                                              width: width(context) * 0.35,
                                              height: height(context) * 0.035,
                                              padding: EdgeInsets.all(0.0),
                                              color: Colors.red.shade600,
                                              child: Center(
                                                  child: Text(
                                                allSliderData[index]
                                                    ["typeName"]!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0),
                                              ))),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      child: ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          width: width(context) * 0.024,
                                          height: height(context) * 0.02,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (allSliderData[index]['itemType'] ==
                                "upcomingPayments")
                              Positioned(
                                left: 0,
                                top: height(context) * 0.014,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 16.0),
                                        child: ClipPath(
                                          clipper: ArcClipper(),
                                          child: Container(
                                              width: width(context) * 0.5,
                                              height: height(context) * 0.035,
                                              padding: EdgeInsets.all(0.0),
                                              color: (allSliderData[index]
                                                              ["iSACTIVE"] !=
                                                          "" &&
                                                      allSliderData[index]
                                                              ["iSACTIVE"] ==
                                                          0)
                                                  ? Colors.grey
                                                  : Colors.green.shade700,
                                              child: Center(
                                                  child: Text(
                                                (allSliderData[index]
                                                                ["iSACTIVE"] !=
                                                            "" &&
                                                        allSliderData[index]
                                                                ["iSACTIVE"] ==
                                                            0)
                                                    ? "Autopay Paused"
                                                    : allSliderData[index]
                                                        ["typeName"]!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0),
                                              ))),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      child: ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          width: width(context) * 0.024,
                                          height: height(context) * 0.02,
                                          color: (allSliderData[index]
                                                          ["iSACTIVE"] !=
                                                      "" &&
                                                  allSliderData[index]
                                                          ["iSACTIVE"] ==
                                                      0)
                                              ? Colors.grey
                                              : Colors.green.shade700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (allSliderData[index]['itemType'] ==
                                    "upcomingDue" &&
                                allSliderData[index]["dueDate"] != "")
                              Positioned(
                                  right: width(context) * 0.1,
                                  top: height(context) * 0.012,
                                  child: Container(
                                    //       // height: 30,
                                    width: width(context) * 0.35,

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomRight,
                                            stops: [
                                              0.1,
                                              0.6
                                            ],
                                            colors: [
                                              Colors.deepPurple
                                                  .withOpacity(.08),
                                              Colors.grey.withOpacity(.08)
                                            ])),
                                    child: Center(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset(iconCalender),
                                              // Icon(
                                              //   Icons.calendar_month,
                                              //   size: 20,
                                              //   color: txtPrimaryColor,
                                              // ),
                                              Shimmer.fromColors(
                                                baseColor: txtPrimaryColor,
                                                highlightColor: txtAmountColor,
                                                child: appText(
                                                    data: allSliderData[index]
                                                                ["dueDate"] !=
                                                            ""
                                                        ? DateFormat.yMMMd().format(
                                                            DateTime.parse(allSliderData[
                                                                            index][
                                                                        "dueDate"]!
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10))
                                                                .toLocal()
                                                                .add(const Duration(days: 1)))
                                                        : "-",
                                                    size: width(context) * 0.034,
                                                    color: txtPrimaryColor,
                                                    weight: FontWeight.w600),
                                              )
                                            ],
                                          )),
                                    ),
                                  ))
                          ]),
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

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(15.0, 0.0);

    var firstControlPoint = Offset(7.5, 2.0);
    var firstPoint = Offset(5.0, 5.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(2.0, 7.5);
    var secondPoint = Offset(0.0, 15.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
