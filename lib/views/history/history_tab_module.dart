import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/history/history_cubit.dart';
import '../../model/history_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/history_shimmer.dart';
import '../../widgets/history_shimmer_effect.dart';
import 'transaction_item.dart';

class HistoryTabViewScreen extends StatefulWidget {
  const HistoryTabViewScreen({Key? key}) : super(key: key);

  @override
  State<HistoryTabViewScreen> createState() => _HistoryTabViewScreenState();
}

class _HistoryTabViewScreenState extends State<HistoryTabViewScreen> {
  final searchController = TextEditingController();
  List<String> Periods = [
    "Today",
    'Yesterday',
    "This Week",
    "Last Week",
    "This Month",
    'Last Month',
    "Custom"
  ];
  List<HistoryData>? historyData = [];
  String _selectedPeriod = "This Week";
  List<HistoryData>? cloneData = [];
  String dateRange = "Enter From & To Date";
  bool isLoading = true;
  bool showSearch = false;
  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails('This Week', false);
    super.initState();
  }

  getDataPeriodRange(String periodValue) {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails(periodValue, false);
  }

  @override
  void dispose() {
    showSearch = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBodyColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: showSearch ? txtColor : primaryColor,
          leading: IconButton(
            splashRadius: 25,
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: !showSearch ? txtColor : primaryColor,
            ),
          ),
          title: !showSearch
              ? appText(
                  data: "History",
                  size: width(context) * 0.06,
                  weight: FontWeight.bold,
                )
              : TextFormField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (searchTxt) {
                    List<HistoryData>? searchData = [];

                    searchData = cloneData!
                        .where((i) => i.bILLERNAME!
                            .toLowerCase()
                            .contains(searchTxt.toLowerCase()))
                        .toList();
                    print(searchTxt);
                    print(searchData);
                    setState(() {
                      historyData = searchData;
                    });
                  },
                  onFieldSubmitted: (_) {},
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-z0-9A-Z ]*'))
                  ],
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.clear();

                        setState(() {
                          showSearch = false;
                          historyData = cloneData;
                        });
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                    ),
                    hintText: "Search a Bill",
                    hintStyle: TextStyle(color: txtHintColor),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
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
                  )
                ],
          elevation: 0,
        ),
        body: BlocConsumer<HistoryCubit, HistoryState>(
          listener: (context, state) {
            if (state is HistoryLoading) {
              isLoading = true;
            } else if (state is HistorySuccess) {
              historyData = state.historyData;
              cloneData = historyData;
              isLoading = false;
            } else if (state is HistoryFailed) {
              isLoading = false;
              showSnackBar(state.message, context);
            } else if (state is HistoryError) {
              isLoading = false;
              goToUntil(context, splashRoute);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                verticalSpacer(width(context) * 0.016),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: _selectedPeriod == "Custom"
                          ? width(context) / 2.7
                          : width(context) / 1.07,
                      margin: _selectedPeriod != "Custom"
                          ? EdgeInsets.symmetric(
                              horizontal: width(context) * 0.03,
                              vertical: width(context) * 0.02)
                          : EdgeInsets.symmetric(
                              horizontal: width(context) * 0.01,
                              vertical: width(context) * 0.01),
                      height: height(context) * 0.055,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(spreadRadius: 1, color: divideColor)
                          ],
                          color: txtColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          alignment: Alignment.center,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          isDense: false,
                          menuMaxHeight: height(context) * 0.5,
                          itemHeight: 55,
                          decoration: InputDecoration(
                              prefixIcon: ImageIcon(
                                const AssetImage(
                                    "assets/images/iconCalender.png"),
                                color: txtCheckBalanceColor,
                              ),
                              contentPadding:
                                  EdgeInsets.all(width(context) * 0.016),
                              border: InputBorder.none),
                          items: Periods.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child:
                                  Text(value, overflow: TextOverflow.ellipsis),
                              onTap: () {
                                if (value != "Custom") {
                                  getDataPeriodRange(value);
                                }
                                setState(() {
                                  _selectedPeriod = value;
                                });
                              },
                            );
                          }).toList(),
                          value: _selectedPeriod,
                          isExpanded: true,
                          onChanged: (period) {
                            if (period == "Custom") {
                              showDateRangePicker(
                                context: context,
                                firstDate: DateTime(1940),
                                lastDate: DateTime.now(),
                                saveText: "Select",
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: primaryColor,
                                        onPrimary: Colors.white,
                                        onSurface: txtAmountColor,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((DateValue) {
                                if (DateValue != null) {
                                  var dates =
                                      DateValue.toString().split('- ').toList();
                                  print(DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(dates[0]
                                              .toString()
                                              .substring(0, 10))
                                          .toLocal()));

                                  print(dates.toString());

                                  BlocProvider.of<HistoryCubit>(context)
                                      .getHistoryDetails({
                                    "startDate": dates[0].toString(),
                                    "endDate": dates[1].toString(),
                                  }, true);

                                  setState(() {
                                    dateRange =
                                        "${DateFormat('dd/MM/yyyy').format(DateTime.parse(dates[0].toString().substring(0, 10)).toLocal())} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(dates[1].toString().substring(0, 10)).toLocal())}";
                                  });
                                } else {
                                  log("No Date Selected");
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    if (_selectedPeriod == "Custom")
                      InkWell(
                        onTap: () {
                          showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1940),
                            saveText: "Select",
                            lastDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: txtAmountColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((DateValue) {
                            if (DateValue != null) {
                              var dates =
                                  DateValue.toString().split('- ').toList();
                              print(DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(
                                          dates[0].toString().substring(0, 10))
                                      .toLocal()));
                              print(dates.toString());

                              BlocProvider.of<HistoryCubit>(context)
                                  .getHistoryDetails({
                                "startDate": dates[0].toString(),
                                "endDate": dates[1].toString(),
                              }, true);

                              setState(() {
                                dateRange =
                                    "${DateFormat('dd/MM/yyyy').format(DateTime.parse(dates[0].toString().substring(0, 10)).toLocal())} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(dates[1].toString().substring(0, 10)).toLocal())}";
                              });
                            } else {
                              log("no Date selected");
                            }
                          });
                        },
                        child: Container(
                            width: _selectedPeriod == "Custom"
                                ? width(context) / 1.9
                                : width(context),
                            margin: _selectedPeriod != "Custom"
                                ? EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.03,
                                    vertical: width(context) * 0.02)
                                : EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.01,
                                    vertical: width(context) * 0.01),
                            alignment: Alignment.center,
                            height: height(context) * 0.055,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(spreadRadius: 1, color: divideColor)
                                ],
                                color: txtColor,
                                borderRadius: BorderRadius.circular(7)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  appText(
                                      data: dateRange,
                                      size: width(context) * 0.033,
                                      weight: FontWeight.w500,
                                      color: primaryColor),
                                  horizondalSpacer(width(context) * 0.016),
                                  ImageIcon(
                                    const AssetImage(
                                        "assets/images/iconCalender.png"),
                                    color: txtCheckBalanceColor,
                                  ),
                                ])),
                      )
                  ],
                ),
                isLoading
                    ? const Expanded(child: historyShimmer())
                    : Expanded(child: HistoryUI(historyData: historyData))
              ],
            );
          },
        ));
  }
}

class HistoryUI extends StatelessWidget {
  List<HistoryData>? historyData;
  HistoryUI({Key? key, this.historyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return historyData!.isNotEmpty
        ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: historyData!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  margin: EdgeInsets.only(
                      left: width(context) * 0.032,
                      right: width(context) * 0.032,
                      top: width(context) * 0.032,
                      bottom: 0),
                  // height: (historyData![index].aUTOPAYID == null &&
                  //             historyData![index].cUSTOMERBILLID != null &&
                  //             historyData![index].tRANSACTIONSTATUS ==
                  //                 "success" &&
                  //             historyData![index].bILLERACCEPTSADHOC == "N" ||
                  //         historyData![index].aUTOPAYID != null)
                  //     ? height(context) / 3.7
                  //     : height(context) / 4.8,
                  decoration: BoxDecoration(
                    color: txtColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      TransactionItem(historyData: historyData, index: index),
                ),
              ),
            ),
          )
        : Center(
            child: appText(
                data: "No Transaction Found",
                size: width(context) * 0.04,
                color: txtHintColor),
          );
  }
}
