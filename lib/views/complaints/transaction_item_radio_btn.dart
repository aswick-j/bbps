import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../../model/history_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'package:flutter/material.dart';

class TransactionItemRadioBtn extends StatefulWidget {
  List<HistoryData>? historyData;
  int index;
  int? SelectedTxns;
  dynamic Function(int)? updatedRadioBtn;

  TransactionItemRadioBtn(
      {super.key,
      required this.historyData,
      required this.index,
      required this.SelectedTxns,
      @required this.updatedRadioBtn});
  @override
  State<TransactionItemRadioBtn> createState() =>
      _TransactionItemRadioBtnState();
}

class _TransactionItemRadioBtnState extends State<TransactionItemRadioBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
            value: widget.index,
            groupValue: widget.SelectedTxns,
            activeColor: txtAmountColor,
            secondary: Image.asset(
              BLogo,
              height: height(context) * 0.068,
            ),
            title: appText(
                data: widget.historyData![widget.index].bILLERNAME.toString(),
                maxline: 1,
                size: width(context) * 0.038,
                color: txtSecondaryDarkColor),
            subtitle: Padding(
              padding: EdgeInsets.only(top: width(context) * 0.016),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      appText(
                          data:
                              "$rupee ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData![widget.index].bILLAMOUNT.toString()))}",
                          size: width(context) * 0.04,
                          color: txtPrimaryColor,
                          weight: FontWeight.bold),
                      horizondalSpacer(5),
                      widget.historyData![widget.index].tRANSACTIONSTATUS
                                  .toString() ==
                              "success"
                          ? Icon(
                              Icons.check_circle_outline,
                              color: alertSuccessColor,
                              size: width(context) * 0.05,
                            )
                          : Icon(
                              Icons.cancel_outlined,
                              color: alertFailedColor,
                              size: width(context) * 0.05,
                            ),
                    ],
                  ),

                  //dd/MM/yyyy - h:mm a
                  Tooltip(
                    message: widget.historyData![widget.index].cOMPLETIONDATE
                        .toString(),
                    child: appText(
                        data: DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                widget.historyData![widget.index].cOMPLETIONDATE
                                    .toString())
                            .toLocal()),
                        size: width(context) * 0.028,
                        color: txtSecondaryColor,
                        align: TextAlign.right),
                  ),
                ],
              ),
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (int? index) {
              widget.updatedRadioBtn!(widget.index);
            }),
        Divider(
          thickness: 1,
          color: divideDarkColor,
          height: height(context) * 0.002,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}
