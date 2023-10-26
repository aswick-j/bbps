import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';

class TransactionReceipt extends StatefulWidget {
  const TransactionReceipt({Key? key}) : super(key: key);

  @override
  _TransactionReceiptState createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: myAppBar(
        context: context,
        backgroundColor: primaryColor,
        title: "Transaction Receipt",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width(context),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCBCBCB),
                blurRadius: 15.0,
                spreadRadius: 2.0,
                offset: Offset(
                  2.0,
                  2.0,
                ),
              )
            ],
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: SvgPicture.asset(iconSuccessSvg),
            ),
            appText(
              data: " Success!",
              size: width(context) * 0.05,
              color: txtPrimaryColor,
              weight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: appText(
                  data: "Your Payment has been successfully\nPaid",
                  align: TextAlign.center,
                  size: width(context) * 0.04,
                  color: txtSecondaryColor,
                  weight: FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(
                    data: " Transaction ID :",
                    size: width(context) * 0.04,
                    color: txtSecondaryDarkColor,
                    weight: FontWeight.w400),
                appText(
                    data: "QB145458781589585288",
                    size: width(context) * 0.04,
                    color: txtAmountColor),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(
                    data: "Approval Reference Number :",
                    size: width(context) * 0.04,
                    color: txtSecondaryDarkColor,
                    weight: FontWeight.w400),
                appText(
                    data: "9585288",
                    size: width(context) * 0.04,
                    color: txtAmountColor),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
