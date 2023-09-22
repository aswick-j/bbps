import 'dart:convert';
import 'dart:developer';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/history_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class TransactionItem extends StatefulWidget {
  List<HistoryData>? historyData;
  int index;

  TransactionItem({super.key, required this.historyData, required this.index});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToData(context, transactionDetailsRoute, {
        "data": widget.historyData![widget.index],
      }),
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            leading: Image.asset(
              bNeumonic,
              // height: height(context) * 0.07,
            ),
            title: appText(
                data: widget.historyData![widget.index].bILLNUMBER.toString() ??
                    '',
                size: width(context) * 0.04,
                color: txtSecondaryColor,
                weight: FontWeight.w400),
            subtitle: Tooltip(
              message: widget.historyData![widget.index].bILLERNAME ?? '',
              child: appText(
                  data: widget.historyData![widget.index].bILLERNAME ?? '',
                  size: width(context) * 0.04,
                  color: txtPrimaryColor,
                  maxline: 1,
                  weight: FontWeight.w600),
            ),
            // trailing: widget.historyData![widget.index].aUTOPAYID == null
            //     ? null
            //     : Container(
            //         alignment: Alignment.center,
            //         width: width(context) * 0.35,
            //         height: width(context) * 0.06,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(6),
            //             color: alertSuccessColor.withOpacity(0.1)),
            //         child: appText(
            //             data: "AutoPay Enabled",
            //             size: width(context) * 0.03,
            //             color: alertSuccessColor,
            //             weight: FontWeight.w600),
            //       ),
          ),
          Divider(
            thickness: 1,
            endIndent: 16.0,
            indent: 16.0,
            color: divideColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width(context) * 0.032,
                vertical: width(context) * 0.010),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                    data: "Debited From",
                    size: width(context) * 0.04,
                    color: txtSecondaryColor),
                appText(
                    data: widget.historyData![widget.index].aCCOUNTNUMBER ?? '',
                    size: width(context) * 0.04,
                    color: txtSecondaryDarkColor)
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: divideColor,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width(context) * 0.032,
                vertical: width(context) * 0.010),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: appText(
                      data: DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              widget.historyData![widget.index].cOMPLETIONDATE
                                  .toString())
                          .toLocal()),
                      size: width(context) * 0.04,
                      color: txtSecondaryColor),
                ),
                SizedBox(
                    child: Row(
                  children: [
                    appText(
                        data:
                            "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData![widget.index].bILLAMOUNT.toString()))}" ??
                                '',
                        size: width(context) * 0.05,
                        color: txtAmountColor),
                    horizondalSpacer(8.0),
                    widget.historyData![widget.index].tRANSACTIONSTATUS ==
                            'success'
                        ? const Icon(Icons.check_circle_outline,
                            color: Color(0xff2ECC71))
                        : const Icon(
                            Icons.cancel_outlined,
                            color: Color(0xffD63031),
                          ),
                  ],
                ))
              ],
            ),
          ),
          if (widget.historyData![widget.index].aUTOPAYID != null)
            Column(
              children: [
                Divider(
                  thickness: 1,
                  color: divideColor,
                  indent: 16.0,
                  endIndent: 16.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.032,
                      vertical: width(context) * 0.010),
                  child: Container(
                    // margin: EdgeInsets.symmetric(
                    //     horizontal: width(context) * 0.14),
                    height: height(context) * 0.038,
                    width: width(context),
                    decoration: BoxDecoration(
                      color: const Color(0x172ECC70),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("Autopay Enabled",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: height(context) * 0.002,
                          color: alertSuccessColor,
                          fontSize: width(context) * 0.04,
                          fontFamily: appFont,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                ),
              ],
            ),
          if (widget.historyData![widget.index].aUTOPAYID == null &&
              widget.historyData![widget.index].cUSTOMERBILLID != null &&
              widget.historyData![widget.index].tRANSACTIONSTATUS ==
                  "success" &&
              widget.historyData![widget.index].bILLERACCEPTSADHOC == "N")
            Column(
              children: [
                Divider(
                  thickness: 1,
                  color: divideColor,
                  indent: 16.0,
                  endIndent: 16.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.032,
                      vertical: width(context) * 0.010),
                  child: Container(
                      // margin: EdgeInsets.symmetric(
                      //     horizontal: width(context) * 0.14),
                      height: height(context) * 0.038,
                      width: width(context),
                      decoration: BoxDecoration(
                        color: txtPrimaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextButton(
                        onPressed: () => goToData(context, setupAutoPayRoute, {
                          "customerBillID": widget
                              .historyData![widget.index].cUSTOMERBILLID
                              .toString(),
                          "paidAmount": widget
                              .historyData![widget.index].bILLAMOUNT
                              .toString(),
                          "inputSignatures":
                              widget.historyData![widget.index].pARAMETERS,
                          "billname":
                              widget.historyData![widget.index].bILLNAME,
                          "billername":
                              widget.historyData![widget.index].bILLERNAME,
                          "limit": "0"
                        }),
                        child: Text("Eligible for Autopay",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: height(context) * 0.001,
                              color: Colors.white,
                              fontSize: width(context) * 0.04,
                              fontFamily: appFont,
                              fontWeight: FontWeight.normal,
                            )),
                      )),
                ),
              ],
            ),
          verticalSpacer(8.0),
        ],
      ),
    );
  }
}
