import 'dart:convert';

import 'package:bbps/bloc/mybill/mybill_cubit.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/auto_schedule_pay_model.dart';
import '../../model/chart_model.dart';
import '../../model/saved_billers_model.dart';
import '../../model/upcoming_dues_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/helpers.dart';
import '../../utils/utils.dart';

class MyBillScreen extends StatefulWidget {
  const MyBillScreen({Key? key}) : super(key: key);

  @override
  State<MyBillScreen> createState() => _MyBillScreenState();
}

class _MyBillScreenState extends State<MyBillScreen> {
  List<ChartData>? chartdata = [];
  List<SavedBillersData>? cloneData = [];
  List<SavedBillersData>? billerData = [];
  List<UpcomingDuesData>? upcomingDuesData = [];
  List<SavedBillersData>? savedBillerData = [];
  bool showSearch = false;

  bool isBillChartLoading = true;
  bool isUpcomingLoading = true;
  bool isAutopayUpcomingLoading = true;
  AutoSchedulePayModel? model = AutoSchedulePayModel();
  List<UpcomingPaymentsData>? upcomingPaymentList = [];
  List<AllConfigurations>? allautoPaymentList = [];
  @override
  void initState() {
    BlocProvider.of<MybillCubit>(context).getAllUpcomingDues();
    BlocProvider.of<MybillCubit>(context).getUpcomingPay();

    super.initState();
  }

  @override
  void dispose() {
    showSearch = false;

    super.dispose();
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBodyColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: showSearch ? txtColor : primaryColor,
          title: !showSearch
              ? appText(
                  data: "My Billers",
                  size: width(context) * 0.06,
                  weight: FontWeight.w600,
                )
              : TextFormField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (searchTxt) {
                    List<SavedBillersData>? searchData = [];

                    searchData = cloneData!.where((item) {
                      final bILLERNAME =
                          item.bILLERNAME.toString().toLowerCase();
                      final bILLNAME = item.bILLNAME.toString().toLowerCase();
                      final searchLower = searchTxt.toLowerCase();
                      return bILLERNAME.contains(searchLower) ||
                          bILLNAME.contains(searchLower);
                    }).toList();

                    setState(() {
                      billerData = searchData;
                    });
                  },
                  onFieldSubmitted: (_) {},
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-z0-9A-Z. ]*'))
                  ],
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.clear();

                        setState(() {
                          showSearch = false;
                          billerData = cloneData;
                        });
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                    ),
                    hintText: "Search a Biller",
                    hintStyle: TextStyle(color: txtHintColor),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          )),
          elevation: 0,
          toolbarHeight: height(context) * 0.08,
          actions: showSearch
              ? null
              : [
                  IconButton(
                    splashRadius: 25,
                    onPressed: () => setState(() {
                      showSearch = true;
                    }),
                    icon: Icon(
                      Icons.search,
                      color: txtColor,
                    ),
                  ),
                  Tooltip(
                    textStyle:
                        TextStyle(fontFamily: appFont, color: Colors.white),
                    decoration: BoxDecoration(color: primaryColorDark),
                    triggerMode: TooltipTriggerMode.tap,
                    padding: EdgeInsets.all(width(context) * 0.02),
                    margin:
                        EdgeInsets.symmetric(horizontal: width(context) * 0.06),
                    message:
                        "Auto pay facility is supported only for select billers and is enabled after you pay a bill atleast once for a  biller [PRD - 5.0]",
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.info_outline,
                        color: iconColor,
                      ),
                    ),
                  ),
                  //     ],
                  //   ),
                  // )
                ],
        ),
        body:
            BlocConsumer<MybillCubit, MybillState>(listener: (context, state) {
          if (state is MybillChartSuccess) {
            chartdata = state.chartModel!.data ?? [];

            billerData = state.chartModel!.billerData ?? [];
            cloneData = billerData;

            // logInfo(jsonEncode(billerData));
            isBillChartLoading = false;
          } else if (state is MybillChartLoading) {
            isBillChartLoading = true;
          } else if (state is MybillChartFailed) {
            isBillChartLoading = false;
            showSnackBar(state.message, context);
          } else if (state is MybillChartError) {
            isBillChartLoading = false;
            goToUntil(context, splashRoute);
          }
          if (state is UpcomingDueLoading) {
            isUpcomingLoading = true;
          } else if (state is UpcomingDueSuccess) {
            BlocProvider.of<MybillCubit>(context).getCharts();

            upcomingDuesData = state.upcomingDuesData;
            logConsole(upcomingDuesData!.length.toString(),
                "upcomingDuesData LENGTH ::: ");
            isUpcomingLoading = false;
          } else if (state is UpcomingDueFailed) {
            isUpcomingLoading = false;
            showSnackBar(state.message, context);
          } else if (state is UpcomingDueError) {
            isUpcomingLoading = false;
            goToUntil(context, splashRoute);
          }

          if (state is AutopayUpcomingLoading) {
            isAutopayUpcomingLoading = true;
          } else if (state is AutopayUpcomingSuccess) {
            //logConsole(state.autoSchedulePayModel!.data!.upcomingPayments!.first.data!.first.bILLERNAME.toString(),name: "Upcoming : ");
            model = state.autoSchedulePayModel;
            allautoPaymentList = model!.data!.allConfigurations!;
            upcomingPaymentList = model!.data!.upcomingPayments!.isEmpty
                ? []
                : model!.data!.upcomingPayments![0].data;
            isAutopayUpcomingLoading = false;
          } else if (state is AutopayUpcomingFailed) {
            isAutopayUpcomingLoading = false;

            showSnackBar(state.message, context);
          } else if (state is AutopayUpcomingError) {
            isAutopayUpcomingLoading = false;

            goToUntil(context, splashRoute);
          }
        }, builder: (context, state) {
          return (isBillChartLoading ||
                  isUpcomingLoading ||
                  isAutopayUpcomingLoading)
              ?

              // : myBillsShimmer();
              Center(
                  child: Image.asset(
                    LoaderGif,
                    height: height(context) * 0.07,
                    width: height(context) * 0.07,
                  ),
                )
              : Stack(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpacer(height(context) * 0.05),
                        ]),
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: billerData!.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * 0.3),
                                  child: Column(
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
                              )
                            : Column(
                                children: [
                                  MyBillScreenUI(
                                      billerData: billerData,
                                      billDueData: upcomingDuesData,
                                      chartdata: chartdata,
                                      upcomingDuesData: upcomingDuesData,
                                      upcomingPaymentList: upcomingPaymentList,
                                      allautoPaymentList: allautoPaymentList),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
        }));
  }
}

class MyBillScreenUI extends StatefulWidget {
  List<SavedBillersData>? billerData;
  List<UpcomingDuesData>? billDueData;
  List<UpcomingDuesData>? upcomingDuesData;
  List<ChartData>? chartdata = [];
  List<UpcomingPaymentsData>? upcomingPaymentList = [];
  List<AllConfigurations>? allautoPaymentList = [];

  MyBillScreenUI(
      {Key? key,
      this.billerData,
      this.billDueData,
      this.chartdata,
      this.upcomingDuesData,
      this.upcomingPaymentList,
      this.allautoPaymentList})
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

class _MyBillScreenUIState extends State<MyBillScreenUI>
    with TickerProviderStateMixin {
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

  getUpcmoingDueData(customerBILLID) {
    List<UpcomingDuesData>? find = widget.billDueData!
        .where((items) => items.customerBillID == customerBILLID)
        .toList();
    //logConsole(jsonEncode(find).toString(), name: "getUpcmoingDueData :::");

    return (find.isNotEmpty ? find[0] : "");
  }

  getdueDate(index, customerBILLID) {
    if (index != null) {
      try {
        List<UpcomingDuesData>? find = widget.billDueData!
            .where((items) => items.customerBillID == customerBILLID)
            .toList();
        // print(find.toString());
        // logConsole(jsonEncode(find).toString(), "GET DUE DATE :::");
        // logInfo(jsonEncode(find));
        return (find.isNotEmpty
            ? find[0].dueDate != null
                ? find[0].dueDate
                : ""
            : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

//  getbillDate(index, customerBILLID) {
//     //logConsole(index.toString(), name: "getduedate2 :::");
//     //logConsole(jsonEncode(widget.billerData![index]).toString(),
//     //     name: "getduedate2 ::: widget.billerData![index]:::");
//     if (index != null) {
//       try {
//         List<UpcomingDuesData>? find = widget.billDueData!
//             .where((items) => items.customerBillID == customerBILLID)
//             .toList();
//         // print(find.toString());
//        logConsole(jsonEncode(find).toString(), name: "getduedate2 :::");

//         return (find.isNotEmpty ? find[0]. : "");
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       return null;
//     }
//   }

  getupcomingPaymentList(index, customerBILLID) {
    if (index != null) {
      try {
        List<UpcomingPaymentsData>? find = widget.upcomingPaymentList!
            .where((items) => items.cUSTOMERBILLID == customerBILLID)
            .toList();
        // print(find.toString());
        //logConsole(jsonEncode(find).toString(), name: "getUPCOMING :::");

        return (find.isNotEmpty ? find[0] : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  getAllAutopayList(index, customerBILLID) {
    if (index != null) {
      try {
        List<AllConfigurationsData>? CheckData = [];
        for (int i = 0; i < widget.allautoPaymentList!.length; i++) {
          for (int j = 0; j < widget.allautoPaymentList![i].data!.length; j++) {
            CheckData.add(widget.allautoPaymentList![i].data![j]);
          }
        }

        List<AllConfigurationsData>? find =
            CheckData.where((item) => item.cUSTOMERBILLID == customerBILLID)
                .toList();

        // List<AllConfigurations>? find = widget.allautoPaymentList!
        //     .where((items) => items.cUSTOMERBILLID == customerBILLID)
        //     .toList();
        // // print(find.toString());
        //logConsole(jsonEncode(find).toString(), name: "getALLautopay :::");

        return (find.isNotEmpty ? find[0] : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  getdueAmount(index, customerBILLID) {
    if (index != null) {
      try {
        List<UpcomingDuesData>? find = widget.billDueData!
            .where((items) => items.customerBillID == customerBILLID)
            .toList();
        //logConsole(jsonEncode(find).toString(), name: "getdueAmount :::");
        return (find.isNotEmpty ? find[0].dueAmount : "");
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  Widget showAutoPay(SavedBillersData savedBillerData, dueAmount) {
    //logConsole(jsonEncode(savedBillerData).toString(), name: "SELECTED");

    if (savedBillerData.aUTOPAYID == null &&
        (savedBillerData.lASTPAIDDATE != null) &&
        savedBillerData.bILLERACCEPTSADHOC == "N") {
      return GestureDetector(
        onTap: () {
          goToData(context, setupAutoPayRoute, {
            "customerBillID": savedBillerData.cUSTOMERBILLID.toString(),
            "paidAmount": savedBillerData.lASTBILLAMOUNT.toString(),
            "dueAmount": dueAmount,
            "inputSignatures": savedBillerData.pARAMETERS,
            "billname": savedBillerData.bILLNAME,
            "billername": savedBillerData.bILLERNAME,
            "limit": "0"
          });
        },
        child: PhysicalModel(
          color: Colors.white,
          // elevation: 3,
          // shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            // height: 30,
            width: width(context) * 0.25,

            decoration: BoxDecoration(
                color: Color.fromARGB(21, 56, 46, 204),
                // border: Border.all(
                //   width: 1.5,
                //   color: Colors.green.shade200,
                // ),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: txtPrimaryColor,
                highlightColor: Colors.blue.shade600,
                child: Text(
                  'Enable Autopay',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
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

  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUpBillerData(billerResponseData) {
      try {
        List billerData = billerResponseData!;
        List tempUpcomingDuedata;
        List tempBillerData;
        List<UpcomingPaymentsData>? list2 =
            widget.upcomingPaymentList!.reversed.toList();

        List<UpcomingDuesData>? List3 =
            widget.upcomingDuesData!.reversed.toList();

        for (var i = 0; i < List3.length; i++) {
          tempUpcomingDuedata = billerData
              .where((element) =>
                  element.cUSTOMERBILLID == List3[i].customerBillID)
              .toList();

          for (var j = 0; j < tempUpcomingDuedata.length; j++) {
            billerData.remove(tempUpcomingDuedata[j]);
            billerData.insert(0, tempUpcomingDuedata[j]);
          }
        }

        for (var i = 0; i < list2.length; i++) {
          tempBillerData = billerData
              .where((element) =>
                  element.cUSTOMERBILLID == list2[i].cUSTOMERBILLID)
              .toList();
          for (var j = 0; j < tempBillerData.length; j++) {
            billerData.remove(tempBillerData[j]);
            billerData.insert(0, tempBillerData[j]);
          }
        }
        // logInfo(jsonEncode(billerData));

        return billerData;
      } catch (e) {
        print(e);
      }
    }

    showAutopayInfoText(AllBillersDataSaved, index) {
      String _autopayInfoText = "";

      if (AllBillersDataSaved![index].aUTOPAYID != null &&
          (AllBillersDataSaved![index].lASTPAIDDATE != null)) {
        if (getAllAutopayList(
                    index, AllBillersDataSaved![index].cUSTOMERBILLID) !=
                "" &&
            getdueAmount(index, AllBillersDataSaved![index].cUSTOMERBILLID) !=
                "") {
          if (double.parse(getAllAutopayList(
                      index, AllBillersDataSaved![index].cUSTOMERBILLID)
                  .mAXIMUMAMOUNT
                  .toString()) <
              double.parse(getdueAmount(
                      index, AllBillersDataSaved![index].cUSTOMERBILLID)
                  .toString())) {
            _autopayInfoText =
                "Your debit limit [${"₹ ${NumberFormat('#,##,##0.00').format(double.parse(getAllAutopayList(index, AllBillersDataSaved![index].cUSTOMERBILLID).mAXIMUMAMOUNT.toString()))}"} ] is currently lower than the amount due [ ${"$rupee ${getdueAmount(index, AllBillersDataSaved![index].cUSTOMERBILLID)}"}].To Prevent any autopay failures,we kindly ask you to adjust your debit limit before the scheduled payment date.";
          }
        }

        if (getAllAutopayList(
                    index, AllBillersDataSaved![index].cUSTOMERBILLID) !=
                "" &&
            getdueDate(index, AllBillersDataSaved![index].cUSTOMERBILLID) !=
                "") {
          DateTime now = DateTime.now();
          DateTime autopayDate = DateTime(
              now.year,
              now.month,
              int.parse(getAllAutopayList(
                      index, AllBillersDataSaved![index].cUSTOMERBILLID)
                  .pAYMENTDATE
                  .toString()));
          DateTime dueDate = DateTime.parse(
                  getdueDate(index, AllBillersDataSaved![index].cUSTOMERBILLID))
              .add(Duration(days: 1));
          final bool isBeforeDate = autopayDate.isBefore(dueDate);

          if (!isBeforeDate)
          // if (double.parse(getAllAutopayList(
          //             index, AllBillersDataSaved![index].cUSTOMERBILLID)
          //         .pAYMENTDATE
          //         .toString()) <=
          //     double.parse(DateFormat('dd')
          //         .format(DateTime.parse(getdueDate(
          //                 index, AllBillersDataSaved![index].cUSTOMERBILLID))
          //             .add(Duration(days: 1)))
          //         .toString()))
          {
            _autopayInfoText =
                "Your autopay date seems to be mismatched with the due date. To rectify this issue and avoid autopay failures, please review and adjust your autopay date accordingly.";
          }
        }
      }
      return _autopayInfoText.toString().length > 0
          ? AutopayInfoText(text: _autopayInfoText)
          : SizedBox();
    }

    final DateTime now = DateTime.now();

    Widget TabBillers(dynamic? AllBillersDataSaved, bool IsSavedBillers) {
      Widget BillerDetailsUI(dynamic? AllBillersDataSaved, index) {
        return Container(
          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              border: Border.all(
                // width: 0.5,
                color: (getupcomingPaymentList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "" &&
                        getupcomingPaymentList(index,
                                    AllBillersDataSaved![index].cUSTOMERBILLID)
                                .iSACTIVE ==
                            0)
                    ? Colors.grey
                    : getupcomingPaymentList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            ''
                        ? alertSuccessColor
                        : getUpcmoingDueData(AllBillersDataSaved![index]
                                    .cUSTOMERBILLID) !=
                                ''
                            ? Colors.red.shade600
                            : AllBillersDataSaved[index].aUTOPAYID != null
                                ? alertSuccessColor
                                : Colors.white,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getupcomingPaymentList(index,
                                  AllBillersDataSaved![index].cUSTOMERBILLID) !=
                              '' ||
                          getUpcmoingDueData(
                                  AllBillersDataSaved![index].cUSTOMERBILLID) !=
                              ''
                      ? 0
                      : 12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: txtColor),
          margin: EdgeInsets.only(
            // top: width(context) * 0.008,
            // right: width(context) * 0.004,
            // left: width(context) * 0.004,
            bottom: width(context) * 0.028,
          ),
          // height: height(context) / 5.8,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.046,
                  vertical: width(context) * 0.008,
                ),
                leading: Container(
                  width: width(context) * 0.13,
                  height: height(context) * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          stops: [
                            0.1,
                            0.9
                          ],
                          colors: [
                            Colors.deepPurple.withOpacity(.16),
                            Colors.grey.withOpacity(.08)
                          ])),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(BillerLogo(
                              AllBillersDataSaved![index].bILLERNAME.toString(),
                              AllBillersDataSaved![index]
                                  .cATEGORYNAME
                                  .toString())

                          // height: height(context) * 0.07,
                          )),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: width(context) * 0.008),
                  child: appText(
                    data: AllBillersDataSaved![index].bILLNAME,
                    size: width(context) * 0.04,
                    color: txtPrimaryColor,
                    maxline: 1,
                    weight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: width(context) * 0.016),
                  child: appText(
                      data: AllBillersDataSaved![index].bILLERNAME,
                      size: width(context) * 0.04,
                      color: txtSecondaryColor,
                      maxline: 1),
                ),
                trailing: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: iconColor,
                  ),
                  tooltip: "Menu",
                  onSelected: (value) => onSelected(
                      context,
                      AllBillersDataSaved![index],
                      getAllAutopayList(
                          1, AllBillersDataSaved![index].cUSTOMERBILLID),
                      value),
                  itemBuilder: (context) => [
                    if (getupcomingPaymentList(index,
                            AllBillersDataSaved![index].cUSTOMERBILLID) !=
                        '')
                      if (getAllAutopayList(
                                  1, AllBillersDataSaved![index].cUSTOMERBILLID)
                              .pAYMENTDATE !=
                          now.day.toString())
                        _buildPopupMenuItem(
                            getupcomingPaymentList(
                                            index,
                                            AllBillersDataSaved![index]
                                                .cUSTOMERBILLID)
                                        .iSACTIVE ==
                                    1
                                ? 'Pause Autopay'
                                : 'Resume Autopay',
                            getupcomingPaymentList(
                                            index,
                                            AllBillersDataSaved![index]
                                                .cUSTOMERBILLID)
                                        .iSACTIVE ==
                                    1
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            txtPrimaryColor,
                            2),
                    if (AllBillersDataSaved![index].aUTOPAYID != null)
                      if (getAllAutopayList(index,
                              AllBillersDataSaved![index].cUSTOMERBILLID) !=
                          "")
                        if ((getAllAutopayList(
                                            1,
                                            AllBillersDataSaved![index]
                                                .cUSTOMERBILLID) !=
                                        ""
                                    ? getAllAutopayList(
                                            1,
                                            AllBillersDataSaved![index]
                                                .cUSTOMERBILLID)
                                        .pAYMENTDATE
                                    : "") !=
                                now.day.toString() &&
                            getAllAutopayList(
                                        index,
                                        AllBillersDataSaved![index]
                                            .cUSTOMERBILLID)
                                    .iSACTIVE ==
                                1)
                          _buildPopupMenuItem(
                              'Edit Autopay', Icons.edit, Colors.green, 3),
                    if (AllBillersDataSaved![index].aUTOPAYID != null)
                      _buildPopupMenuItem(
                          'Delete Autopay', Icons.delete, Colors.red, 4),
                    if (AllBillersDataSaved![index].aUTOPAYID == null)
                      _buildPopupMenuItem(
                          'Edit Biller', Icons.edit, Colors.green, 0),
                    if (AllBillersDataSaved![index].aUTOPAYID == null)
                      _buildPopupMenuItem(
                          'Delete Biller', Icons.delete, Colors.red, 1),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: width(context) * 0.040,
                  left: width(context) * 0.040,
                  top: width(context) * 0.020,
                  bottom: width(context) * 0.020,
                ),
                child: DottedLine(
                  dashColor: dashColor,
                ),
              ),

              // Divider(
              //   thickness: 1,
              //   indent: 8.0,
              //   endIndent: 8.0,
              //   color: divideColor,
              // ),
              if ((getupcomingPaymentList(
                          index, AllBillersDataSaved![index].cUSTOMERBILLID) !=
                      "" &&
                  getupcomingPaymentList(
                              index, AllBillersDataSaved![index].cUSTOMERBILLID)
                          .iSACTIVE ==
                      0 &&
                  AllBillersDataSaved![index].aUTOPAYID != null))
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: IgnorePointer(
                    ignoring: false,
                    child: ExpansionTile(
                      trailing: null,
                      // collapsedIconColor: Colors.red.shade600,
                      // iconColor: Colors.red.shade600,
                      childrenPadding: EdgeInsets.symmetric(
                          vertical: width(context) * 0.02,
                          horizontal: width(context) * 0.04),
                      title: GestureDetector(
                        onTap: () {
                          onSelected(
                              context,
                              AllBillersDataSaved![index],
                              getAllAutopayList(1,
                                  AllBillersDataSaved![index].cUSTOMERBILLID),
                              2);
                        },
                        child: PhysicalModel(
                          color: Colors.white,
                          // elevation: 3,
                          // shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            // height: 30,
                            width: width(context) * 0.25,

                            decoration: BoxDecoration(
                                color: Color.fromARGB(21, 91, 204, 46),
                                // border: Border.all(
                                //   width: 1.5,
                                //   color: Colors.green.shade200,
                                // ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
                                baseColor: alertSuccessColor,
                                highlightColor: Colors.green.shade100,
                                child: Text(
                                  'Resume Autopay ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      children: [
                        if (getdueAmount(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Bill Due',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data:
                                      "$rupee ${getdueAmount(index, AllBillersDataSaved![index].cUSTOMERBILLID)}",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          verticalSpacer(width(context) * 0.02),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Due Date',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data: getdueDate(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID) !=
                                          null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(getdueDate(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID))
                                              .add(Duration(days: 1)))
                                      : "-",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              else if ((AllBillersDataSaved![index].aUTOPAYID != null) ||
                  (AllBillersDataSaved![index].aUTOPAYID == null &&
                      AllBillersDataSaved![index].cUSTOMERBILLID != null &&
                      (AllBillersDataSaved![index].lASTPAIDDATE != null) &&
                      AllBillersDataSaved![index].bILLERACCEPTSADHOC == "N"))
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: IgnorePointer(
                    ignoring:
                        (AllBillersDataSaved![index].cHANGE_IN_AMOUNT == null &&
                                AllBillersDataSaved![index].lASTBILLAMOUNT ==
                                    null &&
                                AllBillersDataSaved![index].lASTPAIDDATE ==
                                    null &&
                                getdueAmount(
                                        index,
                                        AllBillersDataSaved![index]
                                            .cUSTOMERBILLID) ==
                                    "" &&
                                getdueDate(
                                        index,
                                        AllBillersDataSaved![index]
                                            .cUSTOMERBILLID) ==
                                    "")
                            ? true
                            : false,
                    child: ExpansionTile(
                      trailing: (AllBillersDataSaved![index].cHANGE_IN_AMOUNT ==
                                  null &&
                              AllBillersDataSaved![index].lASTBILLAMOUNT ==
                                  null &&
                              AllBillersDataSaved![index].lASTPAIDDATE ==
                                  null &&
                              getdueAmount(
                                      index,
                                      AllBillersDataSaved![index]
                                          .cUSTOMERBILLID) ==
                                  "" &&
                              getdueDate(
                                      index,
                                      AllBillersDataSaved![index]
                                          .cUSTOMERBILLID) ==
                                  "")
                          ? const SizedBox()
                          : null,
                      // collapsedIconColor: alertSuccessColor,
                      // iconColor: alertSuccessColor,
                      childrenPadding: EdgeInsets.symmetric(
                          vertical: width(context) * 0.02,
                          horizontal: width(context) * 0.04),
                      title: showAutoPay(
                          AllBillersDataSaved![index],
                          getdueAmount(index,
                              AllBillersDataSaved![index].cUSTOMERBILLID)),
                      children: [
                        if (AllBillersDataSaved![index].cHANGE_IN_AMOUNT !=
                            null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Change In Amount',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data: AllBillersDataSaved![index]
                                      .cHANGE_IN_AMOUNT,
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (AllBillersDataSaved![index].lASTBILLAMOUNT != null)
                          verticalSpacer(width(context) * 0.02),
                        if (AllBillersDataSaved![index].lASTBILLAMOUNT != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Last Bill Amount',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data:
                                      '$rupee ${AllBillersDataSaved![index].lASTBILLAMOUNT}',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (AllBillersDataSaved![index].lASTPAIDDATE != null)
                          verticalSpacer(width(context) * 0.02),
                        if (AllBillersDataSaved![index].lASTPAIDDATE != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Last Paid On',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data: AllBillersDataSaved![index]
                                              .lASTPAIDDATE !=
                                          null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(DateTime.parse(
                                                  AllBillersDataSaved![index]
                                                      .lASTPAIDDATE
                                                      .toString())
                                              .toLocal())
                                          .toString()
                                      : "",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (getdueAmount(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          verticalSpacer(width(context) * 0.02),
                        if (getdueAmount(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Due Amount',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data:
                                      "$rupee ${getdueAmount(index, AllBillersDataSaved![index].cUSTOMERBILLID)}",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          verticalSpacer(width(context) * 0.02),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Due Date',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data: getdueDate(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID) !=
                                          null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(getdueDate(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID))
                                              .add(Duration(days: 1)))
                                      : "-",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (getAllAutopayList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Column(
                            children: [
                              verticalSpacer(width(context) * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Autopay Date',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: (getAllAutopayList(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID)
                                              .pAYMENTDATE),
                                          style: TextStyle(
                                            color: txtSecondaryColor,
                                            fontSize: width(context) * 0.035,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(1, -6),
                                            child: Text(
                                              "${getDayOfMonthSuffix(int.parse(getAllAutopayList(index, AllBillersDataSaved![index].cUSTOMERBILLID).pAYMENTDATE.toString()))}",
                                              //superscript is usually smaller in size
                                              textScaleFactor: 0.8,
                                              style: TextStyle(
                                                  color: txtSecondaryColor,
                                                  fontSize:
                                                      width(context) * 0.035),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  of the Month',
                                          style: TextStyle(
                                            color: txtSecondaryColor,
                                            fontSize: width(context) * 0.035,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (getAllAutopayList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Column(
                            children: [
                              verticalSpacer(width(context) * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Debit Account',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data: getAllAutopayList(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID)
                                          .aCCOUNTNUMBER,
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor)
                                ],
                              ),
                            ],
                          ),
                        if (getAllAutopayList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Column(
                            children: [
                              verticalSpacer(width(context) * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      data: 'Debit Limit',
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                  appText(
                                      data:
                                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(getAllAutopayList(index, AllBillersDataSaved![index].cUSTOMERBILLID).mAXIMUMAMOUNT.toString()))}",
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor)
                                ],
                              ),
                            ],
                          ),
                        if (getAllAutopayList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          if (getAllAutopayList(
                                      index,
                                      AllBillersDataSaved![index]
                                          .cUSTOMERBILLID)
                                  .iSACTIVE ==
                              0)
                            Column(
                              children: [
                                verticalSpacer(width(context) * 0.02),
                                Align(
                                  alignment: Alignment.center,
                                  child: appText(
                                      data:
                                          "Edit Disabled till Auto Pay enables",
                                      size: width(context) * 0.035,
                                      color: txtSecondaryColor),
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                )
              else if (getUpcmoingDueData(
                      AllBillersDataSaved![index].cUSTOMERBILLID) !=
                  "")
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: IgnorePointer(
                    ignoring: false,
                    child: ExpansionTile(
                      trailing: null,
                      collapsedIconColor: Colors.red.shade600,
                      iconColor: Colors.red.shade600,
                      childrenPadding: EdgeInsets.symmetric(
                          vertical: width(context) * 0.02,
                          horizontal: width(context) * 0.04),
                      title: GestureDetector(
                        onTap: () {
                          if (AllBillersDataSaved![index]
                              .cATEGORYNAME
                              .toString()
                              .toLowerCase()
                              .contains("mobile prepaid")) {
                            isSavedBillFrom = true;
                            isMobilePrepaidFrom = true;

                            goToData(context, prepaidAddBillerRoute, {
                              "id": "",
                              "name": AllBillersDataSaved![index]
                                  .cATEGORYNAME
                                  .toString(),
                              "savedBillersData": AllBillersDataSaved![index],
                              "isSavedBill": true
                            });
                          } else {
                            isSavedBillFrom = true;
                            isMobilePrepaidFrom = false;
                            goToData(context, confirmPaymentRoute, {
                              "billID":
                                  AllBillersDataSaved![index].cUSTOMERBILLID,
                              "name": AllBillersDataSaved![index].bILLERNAME,
                              "number":
                                  AllBillersDataSaved![index].pARAMETERVALUE,
                              "billerID": AllBillersDataSaved![index].bILLERID,
                              "savedBillersData": AllBillersDataSaved![index],
                              "isSavedBill": true
                            });
                          }
                        },
                        child: PhysicalModel(
                          color: Colors.white,
                          // elevation: 3,
                          // shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            // height: 30,
                            width: width(context) * 0.25,

                            decoration: BoxDecoration(
                                color: Color.fromARGB(22, 193, 204, 46),
                                // border: Border.all(
                                //   width: 1.5,
                                //   color: Colors.green.shade200,
                                // ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.red,
                                highlightColor: Colors.yellow,
                                child: Text(
                                  'Pay Now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      children: [
                        if (getdueAmount(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Bill Due',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data:
                                      "$rupee ${getdueAmount(index, AllBillersDataSaved![index].cUSTOMERBILLID)}",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          verticalSpacer(width(context) * 0.02),
                        if (getdueDate(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                  data: 'Due Date',
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor),
                              appText(
                                  data: getdueDate(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID) !=
                                          null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(getdueDate(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID))
                                              .add(Duration(days: 1)))
                                      : "-",
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor)
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(
                      left: width(context) * 0.036,
                      right: width(context) * 0.032,
                      top: width(context) * 0.016,
                      bottom: width(context) * 0.016),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                          data: AllBillersDataSaved![index]
                                  .cATEGORYNAME
                                  .toString()
                                  .toLowerCase()
                                  .contains("mobile prepaid")
                              ? "Mobile Number"
                              : AllBillersDataSaved![index]
                                  .pARAMETERNAME
                                  .toString()
                                  .capitalizeByWord(),
                          size: width(context) * 0.035,
                          color: txtSecondaryColor),
                      appText(
                        data: AllBillersDataSaved![index]
                                .cATEGORYNAME
                                .toString()
                                .toLowerCase()
                                .contains("mobile prepaid")
                            ? AllBillersDataSaved![index]
                                .pARAMETERS!
                                .firstWhere(
                                  (param) =>
                                      param.pARAMETERNAME
                                          .toString()
                                          .toLowerCase() ==
                                      'mobile number',
                                )
                                .pARAMETERVALUE
                            : AllBillersDataSaved![index]
                                .pARAMETERVALUE
                                .toString()
                                .toUpperCase(),
                        size: width(context) * 0.035,
                        color: txtAmountColor,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              // if ((getAllAutopayList(
              //                 1, AllBillersDataSaved![index].cUSTOMERBILLID) !=
              //             ""
              //         ? getAllAutopayList(
              //                 1, AllBillersDataSaved![index].cUSTOMERBILLID)
              //             .pAYMENTDATE
              //         : "") ==
              //     now.day.toString())
              //   Container(
              //     width: width(context) * 0.95,
              //     height: height(context) * 0.03,
              //     decoration: BoxDecoration(
              //       color: alertSuccessColor,
              //       // borderRadius: BorderRadius.only(
              //       //   bottomLeft: Radius.circular(8),
              //       //   bottomRight: Radius.circular(8),
              //       // ),
              //     ),
              //     child: Center(
              //       child: Text(
              //         "Completed auto payments will be reflected in History section",
              //         style: TextStyle(
              //             fontSize: width(context) * 0.027,
              //             color: Colors.white),
              //       ),
              //     ),
              //   ),
              showAutopayInfoText(AllBillersDataSaved, index)
            ],
          ),
        );
      }

      return Container(
          margin: EdgeInsets.only(
            top: width(context) * 0.040,
          ),
          decoration: BoxDecoration(
            color: primaryBodyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: height(context) * 0.03),
              itemCount: AllBillersDataSaved!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    //logConsole(AllBillersDataSaved![index].toJson().toString(),
                    //     name: "AllBillersDataSaved![index] ::");

                    if (AllBillersDataSaved![index]
                        .cATEGORYNAME
                        .toString()
                        .toLowerCase()
                        .contains("mobile prepaid")) {
                      isSavedBillFrom = true;
                      isMobilePrepaidFrom = true;

                      goToData(context, prepaidAddBillerRoute, {
                        "id": "",
                        "name":
                            AllBillersDataSaved![index].cATEGORYNAME.toString(),
                        "savedBillersData": AllBillersDataSaved![index],
                        "isSavedBill": true
                      });
                    } else {
                      isSavedBillFrom = true;
                      isMobilePrepaidFrom = false;
                      goToData(context, confirmPaymentRoute, {
                        "billID": AllBillersDataSaved![index].cUSTOMERBILLID,
                        "name": AllBillersDataSaved![index].bILLERNAME,
                        "number": AllBillersDataSaved![index].pARAMETERVALUE,
                        "billerID": AllBillersDataSaved![index].bILLERID,
                        "savedBillersData": AllBillersDataSaved![index],
                        "isSavedBill": true
                      });
                    }
                  },
                  child: Column(children: [
                    if (getupcomingPaymentList(index,
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            '' ||
                        getUpcmoingDueData(
                                AllBillersDataSaved![index].cUSTOMERBILLID) !=
                            '')
                      Padding(
                        padding: EdgeInsets.only(right: width(context) * 0.55),
                        child: Container(
                            alignment: Alignment.center,
                            child: appText(
                              data: (getupcomingPaymentList(index, AllBillersDataSaved![index].cUSTOMERBILLID) != "" &&
                                      getupcomingPaymentList(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID)
                                              .iSACTIVE ==
                                          0)
                                  ? "Autopay Paused"
                                  : (getAllAutopayList(1, AllBillersDataSaved![index].cUSTOMERBILLID) != ""
                                              ? getAllAutopayList(
                                                      1,
                                                      AllBillersDataSaved![index]
                                                          .cUSTOMERBILLID)
                                                  .pAYMENTDATE
                                              : "") ==
                                          now.day.toString()
                                      ? "Today"
                                      : getupcomingPaymentList(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID) !=
                                              ''
                                          ? "Upcoming Autopay"
                                          : getUpcmoingDueData(AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID) !=
                                                  ''
                                              ? "Upcoming Due"
                                              : AllBillersDataSaved![index]
                                                  .cATEGORYNAME
                                                  .toString()
                                                  .capitalizeByWord(),
                              size: width(context) * 0.03,
                              color: Colors.white,
                              maxline: 1,
                              weight: FontWeight.bold,
                            ),
                            width: width(context) * 0.35,
                            height: height(context) * 0.03,
                            decoration: BoxDecoration(
                              color: (getupcomingPaymentList(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID) !=
                                          "" &&
                                      getupcomingPaymentList(
                                                  index,
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID)
                                              .iSACTIVE ==
                                          0)
                                  ? Colors.grey
                                  : getupcomingPaymentList(
                                              index,
                                              AllBillersDataSaved![index]
                                                  .cUSTOMERBILLID) !=
                                          ''
                                      ? alertSuccessColor
                                      : getUpcmoingDueData(
                                                  AllBillersDataSaved![index]
                                                      .cUSTOMERBILLID) !=
                                              ''
                                          ? Colors.red.shade600
                                          : AllBillersDataSaved[index]
                                                      .aUTOPAYID !=
                                                  null
                                              ? alertSuccessColor
                                              : alertSuccessColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            )),
                      ),
                    BillerDetailsUI(AllBillersDataSaved, index)
                  ])),
            ),
          ));
    }

    return Container(
      height: height(context) * 0.81,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          horizontal: width(context) * 0.040, vertical: width(context) * 0.012),
      decoration: BoxDecoration(
        // color: txtColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(width(context) * 0.02),
        child: TabBillers(getUpBillerData(widget.billerData), true),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, iconColor, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          horizondalSpacer(10),
          Text(title),
        ],
      ),
    );
  }
}
