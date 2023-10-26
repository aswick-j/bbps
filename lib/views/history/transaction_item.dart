import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                      widget.historyData![widget.index].bILLERNAME.toString(),
                      widget.historyData![widget.index].cATEGORYNAME
                          .toString()))),
            ),
            title: appText(
                data: widget.historyData![widget.index].cATEGORYNAME
                        .toString()
                        .toLowerCase()
                        .contains("mobile prepaid")
                    ? widget.historyData![widget.index].pARAMETERS!
                            .firstWhere((params) => params.pARAMETERNAME == null
                                ? params.pARAMETERNAME == null
                                : params.pARAMETERNAME
                                        .toString()
                                        .toLowerCase() ==
                                    "mobile number")
                            .pARAMETERVALUE ??
                        widget.historyData![widget.index].bILLNUMBER.toString()
                    : widget.historyData![widget.index].bILLNUMBER.toString() ??
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
                        : widget.historyData![widget.index].tRANSACTIONSTATUS ==
                                'bbps-timeout'
                            ? Icon(
                                Icons.hourglass_bottom_rounded,
                                color: alertPendingColor,
                              )
                            : const Icon(
                                Icons.cancel_outlined,
                                color: Color(0xffD63031),
                              ),
                  ],
                ))
              ],
            ),
          ),
          verticalSpacer(8.0),
        ],
      ),
    );
  }
}
