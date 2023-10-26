import 'dart:convert';
import 'dart:developer';

import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:bbps/model/complaints_model.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class ComplaintView extends StatefulWidget {
  ComplaintsData? complaintData;
  ComplaintView({Key? key, required this.complaintData}) : super(key: key);

  @override
  State<ComplaintView> createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ComplaintViewUI(
            complaintData: widget.complaintData,
          );
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ComplaintViewUI extends StatefulWidget {
  ComplaintsData? complaintData;

  ComplaintViewUI({super.key, required this.complaintData});

  @override
  State<ComplaintViewUI> createState() => _ComplaintViewUIState();
}

class _ComplaintViewUIState extends State<ComplaintViewUI> {
  @override
  void initState() {
    logConsole(
        jsonEncode(widget.complaintData).toString(), "AT COMPLAINT VIEW");
    super.initState();
  }

  detail(context, title, content) {
    return SizedBox(
      height: height(context) * 0.093,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
              data: title,
              size: width(context) * 0.04,
              color: txtSecondaryColor),
          appText(
              data: content,
              size: width(context) * 0.04,
              color: txtPrimaryColor,
              weight: FontWeight.w600),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: primaryColor,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: txtColor,
          ),
        ),
        title: appText(
          data: "Complaint Details",
          size: width(context) * 0.05,
          weight: FontWeight.w600,
        ),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
            width: width(context) / 4,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                width: width(context) / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(bbpspngLogo),
                  fit: BoxFit.contain,
                ))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Container(
                color: primaryColor,
                height: height(context) * 0.2,
              ),
              Container(
                height: height(context) * 0.77,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: txtColor,
                ),
                margin: const EdgeInsets.all(16),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detail(context, "Reason",
                                widget.complaintData?.cOMPLAINTREASON),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Type", "Transaction Based"),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Transaction Refernce ID",
                                widget.complaintData?.tRANSACTIONID ?? "-"),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(
                                context,
                                "Issued Date",
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                        widget.complaintData!.cREATEDON
                                            .toString())
                                    .toLocal())),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            detail(context, "Description",
                                widget.complaintData?.dESCRIPTION),
                            Divider(
                              thickness: 1,
                              color: divideColor,
                            ),
                            SizedBox(
                              height: height(context) * 0.1,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                      data: "Status",
                                      size: width(context) * 0.04,
                                      color: txtPrimaryColor,
                                      weight: FontWeight.w600),
                                  Container(
                                    alignment: Alignment.center,
                                    width:
                                        widget.complaintData!.sTATUS!.length! <
                                                12
                                            ? width(context) * 0.35
                                            : width(context) * 0.55,
                                    height: width(context) * 0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // widget.complaintData!.sTATUS =='Resolved'
                                        // widget.complaintData!.sTATUS =='ASSIGNED'

                                        color: widget.complaintData!.sTATUS!
                                                .toString()
                                                .contains("Resolved")
                                            ? alertSuccessColor.withOpacity(0.1)
                                            : widget.complaintData!.sTATUS!
                                                    .toString()
                                                    .contains("ASSIGNED")
                                                ? alertWaitingColor
                                                    .withOpacity(0.1)
                                                : widget.complaintData!.sTATUS!
                                                            .toString()
                                                            .contains(
                                                                "PENDING") ||
                                                        widget.complaintData!
                                                            .sTATUS!
                                                            .toString()
                                                            .contains(
                                                                "ESCALATED")
                                                    ? alertPendingColor
                                                        .withOpacity(0.1)
                                                    : alertFailedColor
                                                        .withOpacity(0.1)),
                                    child: appText(
                                        data: ComplaintStatus(
                                            widget.complaintData!.sTATUS!),
                                        // data: widget.complaintData!.sTATUS,
                                        size: width(context) * 0.04,
                                        color: widget.complaintData!.sTATUS!
                                                .toString()
                                                .contains("Resolved")
                                            ? alertSuccessColor
                                            : widget.complaintData!.sTATUS!
                                                    .toString()
                                                    .contains("ASSIGNED")
                                                ? widget.complaintData!.sTATUS!
                                                            .toString()
                                                            .contains(
                                                                "PENDING") ||
                                                        widget.complaintData!
                                                            .sTATUS!
                                                            .toString()
                                                            .contains(
                                                                "ESCALATED")
                                                    ? alertPendingColor
                                                    : alertWaitingColor
                                                : alertFailedColor,
                                        weight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Expanded(
              flex: 0,
              child: myAppButton(
                context: context,
                buttonName: "Close",
                onpress: () => goBack(context),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              )),
        ],
      ),
    );
  }
}
