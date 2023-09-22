import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';
import 'shimmerCell.dart';

class confirmPaymentsShimmer extends StatefulWidget {
  const confirmPaymentsShimmer({super.key});

  @override
  State<confirmPaymentsShimmer> createState() => _confirmPaymentsShimmerState();
}

class _confirmPaymentsShimmerState extends State<confirmPaymentsShimmer> {
  confirmDetail(context, title) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appText(
              data: title,
              size: width(context) * 0.04,
              color: txtSecondaryColor),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: divideColor.withOpacity(0.1),
            child: ShimmerCell(cellheight: 10.0, cellwidth: width(context) / 9),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(2),
        child: Column(children: [
          Container(
            height: height(context) * 0.27,
            // height: height(context) * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: txtColor,
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 6)),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  leading: Image.asset(
                    bNeumonic,
                    height: height(context) * 0.07,
                  ),
                  title: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: divideColor.withOpacity(0.1),
                    child: ShimmerCell(
                        cellheight: 10.0, cellwidth: width(context) / 3),
                  ),
                  subtitle: Tooltip(
                    message: "sss",
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: divideColor.withOpacity(0.1),
                      child: ShimmerCell(
                          cellheight: 10.0, cellwidth: width(context) / 8),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(context, "Bill Name"),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(context, "Provider"),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "a",
                ),
              ],
            ),
          ),
          Container(
            height: height(context) * 0.62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: txtColor,
            ),
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: appText(
                      data: 'Bill Details',
                      size: width(context) * 0.04,
                      color: txtPrimaryColor,
                      maxline: 1,
                      weight: FontWeight.w600),
                ),
                confirmDetail(
                  context,
                  "Due Date",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Bill Date",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Bill Number",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Customer Name",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Bill Period",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Late Payment Fee",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "Fixed Charges",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(context, "Additional Charges"),
                Padding(padding: EdgeInsets.all(8)),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/be_assured_logo.png",
                    height: height(context) * 0.07,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: appText(
                      data:
                          'All billing details are verified by Bharat Billpay',
                      size: width(context) * 0.03,
                      color: txtSecondaryColor,
                      maxline: 1,
                    ))
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: txtColor,
            ),
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: appText(
                      data: 'Additional Info',
                      size: width(context) * 0.04,
                      color: txtPrimaryColor,
                      maxline: 1,
                      weight: FontWeight.w600),
                ),
                confirmDetail(
                  context,
                  "a",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "a b",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "a b c",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                confirmDetail(
                  context,
                  "a b c d",
                ),
                Divider(
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: divideColor,
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText(
                        data: "Outstanding Amount",
                        size: width(context) * 0.04,
                        weight: FontWeight.w500,
                        color: txtPrimaryColor,
                      ),
                      verticalSpacer(10.0),
                      TextFormField(
                        onChanged: (val) {},
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          fillColor: primaryBodyColor,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryBodyColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryBodyColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryBodyColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryBodyColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: "Amount",
                          hintStyle: TextStyle(color: txtHintColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Align(
                    alignment: Alignment.center,
                    child: appText(
                      data: 'Payment amount has to been 0.01 and 99999.99',
                      size: width(context) * 0.03,
                      color: txtSecondaryColor,
                      maxline: 1,
                    )),
                Padding(padding: EdgeInsets.only(bottom: 12)),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: txtColor,
            ),
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: appText(
                      data: 'Debit From',
                      size: width(context) * 0.04,
                      color: txtPrimaryColor,
                      maxline: 1,
                      weight: FontWeight.w600),
                ),
                Column(
                  children: [
                    RadioListTile(
                      value: "i",
                      groupValue: "selectedAccount",
                      onChanged: (value) {},
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: divideColor.withOpacity(0.1),
                            child: ShimmerCell(
                                cellheight: 10.0,
                                cellwidth: width(context) / 3),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: divideColor.withOpacity(0.1),
                            child: ShimmerCell(
                                cellheight: 10.0,
                                cellwidth: width(context) / 3),
                          ),
                        ],
                      ),
                      selectedTileColor: txtAmountColor,
                    ),
                  ],
                ),
                Container(
                  height: height(context) * 0.14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryBodyColor,
                  ),
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 8, left: 10, bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: txtSecondaryColor),
                              appText(
                                  data: "  Message from Biller",
                                  size: width(context) * 0.035,
                                  weight: FontWeight.w800,
                                  color: txtPrimaryColor),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 4, top: 3, bottom: 16),
                        child: appText(
                            data:
                                "It might take upto 72 hours to complete this transaction based on the billers bank availability in case of any network or technical failure.",
                            size: width(context) * 0.032,
                            color: txtSecondaryColor,
                            maxline: 5,
                            weight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 16.0, top: 0, bottom: 16),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: appFont),
                      children: <TextSpan>[
                        TextSpan(text: tcTextContent),
                        TextSpan(
                          text: tcText,
                          style: TextStyle(
                              color: txtAmountColor,
                              fontFamily: appFont,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  // margin:
                  //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: TextButton(
                    onPressed: () => goBack(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: txtPrimaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: appText(
                        data: "Cancel",
                        size: width(context) * 0.04,
                        weight: FontWeight.bold,
                        color: txtPrimaryColor),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 16),
                  // margin:
                  //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: null,
                    child: appText(
                        data: "Make Payment",
                        size: width(context) * 0.04,
                        weight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
