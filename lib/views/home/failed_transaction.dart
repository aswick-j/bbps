import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class FailedTransaction extends StatefulWidget {
  dynamic tnxData;
  FailedTransaction({Key? key, required this.tnxData}) : super(key: key);

  @override
  _FailedTransactionState createState() => _FailedTransactionState();
}

class _FailedTransactionState extends State<FailedTransaction> {
  bool isMobilePrepaid = false;

  amtText(text, size, colour) {
    return Text(
      text,
      style: TextStyle(
        color: colour,
        fontFamily: 'Rubik-Regular',
        fontSize: size,
      ),
    );
  }

  columnText(context, text1, text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width(context) / 1.6,
          child: Text(
            text1 ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: width(context) * 0.04,
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Rubik-Regular',
            ),
          ),
        ),
        SizedBox(
          width: width(context) / 1.6,
          child: Text(
            text2 ?? '-',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryColor,
              fontFamily: 'Rubik-Regular',
              fontSize: width(context) * 0.036,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    inspect(widget.tnxData);
    log(jsonEncode(widget.tnxData), name: "widget.tnxData ::");
    if (widget.tnxData['isMobilePrepaid'] == null ||
        widget.tnxData['isMobilePrepaid'] == false) {
      setState(() {
        isMobilePrepaid = false;
      });
    } else {
      setState(() {
        isMobilePrepaid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: primaryBodyColor,
          body: ListView(physics: const BouncingScrollPhysics(), children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Image.asset("assets/images/clrpappersfail.png"),
                ),
                Positioned(
                  top: height(context) * 0.025,
                  left: width(context) * 0.35,
                  child: Image.asset("assets/images/icon_failur_png.png"),
                ),
                Positioned(
                  top: height(context) * 0.2,
                  // left: width(context) * 0.35,
                  child: Row(
                    children: [
                      amtText(
                        "$rupee ${double.parse(widget.tnxData['billAmount']).toStringAsFixed(2).toString()}",
                        width(context) * 0.12,
                        primaryColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height(context) * 0.05,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  // widget.tnxData!['errData']
                  "Transaction Failed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: txtHintColor,
                    fontFamily: 'Rubik-Regular',
                    fontSize: width(context) * 0.055,
                  ),
                ),
              ),
            ),
            divideLine(),
            Padding(
              padding: EdgeInsets.only(
                left: width(context) * 0.04,
                bottom: width(context) * 0.04,
                top: width(context) * 0.04,
              ),
              child: Text(
                "Payment Details",
                style: TextStyle(
                  fontFamily: 'Rubik-Regular',
                  fontSize: width(context) * 0.045,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: width(context) * 0.04,
                left: width(context) * 0.04,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffE1E2F2),
                    spreadRadius: 3,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: double.infinity),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.02,
                    ),
                    child: SizedBox(
                        height: height(context) * 0.05,
                        width: width(context),
                        child: columnText(
                            context, "Paid to", widget.tnxData!['billerName'])),
                  ),
                  divideLine(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.02,
                    ),
                    child: SizedBox(
                      height: height(context) * 0.05,
                      width: width(context),
                      child: columnText(
                          context,
                          "Bill Number",
                          isMobilePrepaid
                              ? widget.tnxData['inputSignature']!
                                  .firstWhere(
                                    (param) =>
                                        param.pARAMETERNAME
                                            .toString()
                                            .toLowerCase() ==
                                        'mobile number',
                                  )
                                  .pARAMETERVALUE
                              : widget
                                  .tnxData['inputSignature'][0].pARAMETERVALUE
                          // widget.tnxData!['customerBillID'].toString(),
                          ),
                    ),
                  ),
                  /* Text(
                    isSavedBillFrom
                        ? widget.tnxData!['billerData']!.pARAMETERS![0]
                            .pARAMETERVALUE
                            .toString()
                        : widget.tnxData!['MobilePrepaid']
                            ? widget.tnxData['inputSignature'][0].pARAMETERVALUE
                            : widget.tnxData['inputSignature'][0]
                                ['PARAMETER_VALUE'],
                  ), */
                  divideLine(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.02,
                    ),
                    child: SizedBox(
                      height: height(context) * 0.05,
                      width: width(context),
                      child: columnText(
                          context,
                          "Date",
                          DateFormat("EEEE, d MMMM, y h:mm a")
                              .format(DateTime.now())
                              .toString()),
                      // DateFormat.yMMMd()
                      //     .add_jm()
                      //     .format(DateTime.now())
                      //     .toString()),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width(context) * 0.04,
                bottom: width(context) * 0.04,
                top: width(context) * 0.04,
              ),
              child: Text(
                "Debited from",
                style: TextStyle(
                  fontFamily: 'Rubik-Regular',
                  fontSize: width(context) * 0.045,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: width(context) * 0.04,
                left: width(context) * 0.04,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffE1E2F2),
                    spreadRadius: 3,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: double.infinity),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.02,
                    ),
                    child: SizedBox(
                        height: height(context) * 0.05,
                        width: width(context),
                        child: columnText(context, "Account Number",
                            widget.tnxData!['acNo'])),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width(context) * 0.04,
                bottom: width(context) * 0.04,
                top: width(context) * 0.04,
              ),
              child: Text(
                "Transaction",
                style: TextStyle(
                  fontFamily: 'Rubik-Regular',
                  fontSize: width(context) * 0.045,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: width(context) * 0.04,
                right: width(context) * 0.04,
              ),
              padding: EdgeInsets.all(width(context) * 0.02),
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffE1E2F2),
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        backgroundColor: primaryBodyColor,
                        useMaterial3: true),
                    child: ExpansionTile(
                      backgroundColor: primaryBodyColor,
                      collapsedIconColor: primaryColor,
                      iconColor: primaryColor,
                      childrenPadding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.043,
                          vertical: width(context) * 0.01),
                      collapsedBackgroundColor: primaryBodyColor,
                      initiallyExpanded: true,
                      title: Row(children: [
                        const Icon(Icons.cancel_rounded, color: Colors.red),
                        horizondalSpacer(width(context) * 0.03),
                        appText(
                            data: "Transaction Failed",
                            color: primaryColor,
                            weight: FontWeight.bold,
                            size: width(context) * 0.045)
                      ]),
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ListView.builder(
                                  itemCount: widget
                                      .tnxData!['errData']['transactionSteps']
                                      .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Container(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: widget.tnxData![
                                                                    'errData'][
                                                                'transactionSteps']
                                                            [index]['flag'] ==
                                                        true
                                                    ? const Icon(
                                                        Icons
                                                            .check_circle_outline_outlined,
                                                        color: Colors.green)
                                                    : const Icon(
                                                        Icons.cancel_rounded,
                                                        color: Colors.red),
                                              ),
                                              horizondalSpacer(10),
                                              appText(
                                                  data: widget
                                                      .tnxData!['errData']
                                                          ['transactionSteps']
                                                          [index]['description']
                                                      .toString(),
                                                  size: width(context) * 0.035,
                                                  color: txtPrimaryColor,
                                                  maxline: 1),
                                            ],
                                          ),
                                          verticalSpacer(15)
                                        ],
                                      ))),
                            ])
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width(context) * 0.048,
                        right: width(context) * 0.016,
                        top: width(context) * 0.002,
                        bottom: width(context) * 0.016),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          height: 2,
                          color: txtSecondaryDarkColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Payments done may take upto'),
                          TextSpan(
                            text: ' 3 working days',
                            style: TextStyle(
                                color: txtAmountColor,
                                decoration: TextDecoration.none),
                          ),
                          TextSpan(text: ' to reflect')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            myAppButton(
                context: context,
                buttonName: "Done",
                onpress: () {
                  goToUntil(context, homeRoute);
                },
                margin: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.04,
                    vertical: width(context) * 0.04))
          ]),
        ));
  }
}
