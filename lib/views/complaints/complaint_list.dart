import 'dart:developer';
import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/complaints_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  List<ComplaintsData> AllComplaints = [];
  @override
  void initState() {
    BlocProvider.of<ComplaintCubit>(context).getAllComplaints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintLoading) {
          } else if (state is ComplaintSuccess) {
            AllComplaints = state.ComplaintList!;
          } else if (state is ComplaintFailed) {
            showSnackBar(state.message, context);
          } else if (state is ComplaintError) {
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          return ComplaintScreenUI(complaints: AllComplaints);
        },
      ),
    );
  }
}

class ComplaintScreenUI extends StatefulWidget {
  List<ComplaintsData>? complaints;
  ComplaintScreenUI({Key? key, this.complaints}) : super(key: key);

  @override
  State<ComplaintScreenUI> createState() => _ComplaintScreenUIState();
}

class _ComplaintScreenUIState extends State<ComplaintScreenUI> {
  List<String> FilterOpt = ["Today", "Last day"];
  String capitalizeFirstWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  // ValueNotifier<String> _selectedItem = FilterOpt[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: myAppBar(
          context: context,
          title: "My Complaints",
          bottom: PreferredSize(
            preferredSize: Size(width(context), 8.0),
            child: Container(
              width: width(context),
              color: primaryBodyColor,
            ),
          )),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: widget.complaints!.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.complaints?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: txtColor,
                      ),
                      margin: EdgeInsets.only(
                          left: width(context) * 0.044,
                          right: width(context) * 0.044,
                          top: width(context) * 0.044,
                          bottom: width(context) * 0.010),
                      height: height(context) / 6.1,
                      child: Material(
                        child: InkWell(
                          onTap: () => goToData(context, viewComplaintRoute, {
                            "data": widget.complaints![index],
                          }),
                          child: Padding(
                            padding: EdgeInsets.all(width(context) * 0.042),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: height(context) * 0.06,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        BLogo,
                                        height: height(context) * 0.072,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: height(context) * 0.008),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            appText(
                                                data: widget.complaints![index]
                                                    .tRANSACTIONID,
                                                size: width(context) * 0.036,
                                                color: txtSecondaryDarkColor,
                                                weight: FontWeight.w400),
                                            SizedBox(
                                              width: width(context) * 0.69,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  widget.complaints![index]
                                                      .cOMPLAINTREASON
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: txtPrimaryColor,
                                                      fontSize: width(context) *
                                                          0.038,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  // overflow: TextOverflow.visible,
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DottedLine(
                                  dashColor: dashColor,
                                  dashLength: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    appText(
                                        data: DateFormat(
                                          'dd/MM/yyyy, hh:mm a',
                                        )
                                            .format(DateTime.parse(widget
                                                    .complaints![index]
                                                    .cREATEDON
                                                    .toString())
                                                .toLocal())
                                            .toString(),
                                        size: width(context) * 0.04,
                                        weight: FontWeight.w400,
                                        color: txtSecondaryColor),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            widget.complaints![index].sTATUS!.length < 12
                                                ? width(context) * 0.35
                                                : width(context) * 0.35,
                                        height: width(context) * 0.06,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(44),
                                            color: widget
                                                    .complaints![index].sTATUS!
                                                    .toString()
                                                    .contains("Resolved")
                                                ? alertSuccessColor
                                                    .withOpacity(0.1)
                                                : widget.complaints![index]
                                                        .sTATUS!
                                                        .toString()
                                                        .contains("ASSIGNED")
                                                    ? alertWaitingColor
                                                        .withOpacity(0.1)
                                                    : widget.complaints![index]
                                                                .sTATUS!
                                                                .toString()
                                                                .contains(
                                                                    "PENDING") ||
                                                            widget
                                                                .complaints![index]
                                                                .sTATUS!
                                                                .toString()
                                                                .contains("ESCALATED")
                                                        ? alertPendingColor.withOpacity(0.1)
                                                        : alertFailedColor.withOpacity(0.1)),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: appText(
                                            textAlign: TextAlign.center,
                                            data:
                                                " ${ComplaintStatus(widget.complaints![index].sTATUS!)} ",
                                            // data: widget.complaints![index]
                                            //             .sTATUS ==
                                            //         "PENDING_WITH_BBPOU"
                                            //     ? "Pending"
                                            //     : capitalizeFirstWord(widget
                                            //         .complaints![index].sTATUS
                                            //         .toString()
                                            //         .toLowerCase()),
                                            size: width(context) * 0.04,
                                            color: widget
                                                    .complaints![index].sTATUS!
                                                    .toString()
                                                    .contains("Resolved")
                                                ? alertSuccessColor
                                                : widget.complaints![index]
                                                        .sTATUS!
                                                        .toString()
                                                        .contains("ASSIGNED")
                                                    ? alertWaitingColor
                                                    : widget.complaints![index]
                                                                .sTATUS!
                                                                .toString()
                                                                .contains(
                                                                    "PENDING") ||
                                                            widget
                                                                .complaints![
                                                                    index]
                                                                .sTATUS!
                                                                .toString()
                                                                .contains(
                                                                    "ESCALATED")
                                                        ? alertPendingColor
                                                        : alertFailedColor,
                                            weight: FontWeight.w600,
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        complaintsLogo,
                        height: height(context) * 0.10,
                      ),
                      verticalSpacer(width(context) * 0.07),
                      appText(
                          data: "You have No Complaints Raised",
                          size: 16.6,
                          color: txtPrimaryColor)
                    ],
                  ),
          ),
          Expanded(
              flex: 0,
              child: myAppButton(
                context: context,
                buttonName: "Add New Complaint",
                onpress: () {
                  goTo(context, complaintNewRoute);
                },
                margin: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.044,
                    vertical: width(context) * 0.044),
              )),
        ],
      ),
    );
  }
}
