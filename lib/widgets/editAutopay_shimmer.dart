import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';
import 'shimmerCell.dart';

List<String> optionsList = <String>[
  'Immediately',
  getMonthName(currentMonth),
  getMonthName((int.parse(currentMonth) + 1).toString())
];

class editAutopayShimmer extends StatelessWidget {
  const editAutopayShimmer({super.key});
  editAutopayDetail(context, title) {
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
    return Container(
      height: height(context),
      width: width(context),
      color: primaryBodyColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          // first card
          Container(
            width: width(context),
            margin: const EdgeInsets.all(16.0),
            padding: EdgeInsets.only(bottom: width(context) * 0.03),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              verticalSpacer(4.0),
              ListTile(
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
                subtitle: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: divideColor.withOpacity(0.1),
                  child: ShimmerCell(
                      cellheight: 10.0, cellwidth: width(context) / 8),
                ),
              ),
              editAutopayDetail(context, "a"),
              Divider(
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
                color: divideColor,
              ),
              editAutopayDetail(context, "a b"),
              Divider(
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
                color: divideColor,
              ),
              editAutopayDetail(context, "a b c"),
              Divider(
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
                color: divideColor,
              ),
              editAutopayDetail(context, "a b c d"),
              Divider(
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
                color: divideColor,
              ),
              editAutopayDetail(context, "a b c d e"),
              Divider(
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
                color: divideColor,
              )
            ]),
          ),

          Container(
            height: height(context) / 1.5,
            width: width(context),
            margin: const EdgeInsets.all(16.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              // max amount
              verticalSpacer(16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                      data: "Maximum Amount",
                      size: width(context) * 0.04,
                      color: txtPrimaryColor),
                ],
              ),
              verticalSpacer(16.0),
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  fillColor: primaryBodyColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              //  date of payment

              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Date of Payment",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              verticalSpacer(8.0),
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  fillColor: primaryBodyColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryBodyColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              //  date of payment
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Changes to be reflected from",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              verticalSpacer(width(context) * 0.044),
              Container(
                height: height(context) * 0.065,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      spreadRadius: 2, color: divideColor.withOpacity(0.4))
                ], color: txtColor, borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonFormField(
                  icon: const Icon(Icons.expand_more),
                  isDense: false,
                  itemHeight: 60,
                  style: TextStyle(color: Colors.deepPurple),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(width(context) * 0.032),
                      border: InputBorder.none),
                  items:
                      optionsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (_) {},
                ),
              ),

              //  We Pay Your Bills Once:
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "We Pay Your Bills Once:",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),

              verticalSpacer(8.0),
              RadioListTile(
                value: 0,
                groupValue: "",
                onChanged: (ind) {},
                // onChanged: (value) => setState(() => isBimonthly = value!),
                title: appText(
                    data: "Every Month",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
              verticalSpacer(8.0),

              RadioListTile(
                value: 1,
                groupValue: "", //checked={isBimonthly === 1}
                onChanged: (ind) {},
                // onChanged: (ind) => setState(() => isBimonthly = ind!),
                title: appText(
                    data: "Every Two Months",
                    size: width(context) * 0.04,
                    color: txtPrimaryColor),
              ),
            ]),
          ),

          // third card
          Container(
            // height: height(context) / 3,
            width: width(context),
            margin: const EdgeInsets.all(16.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Column(children: [
              verticalSpacer(16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: appText(
                    data: "Select Payment Account",
                    size: width(context) * 0.05,
                    weight: FontWeight.bold,
                    color: txtPrimaryColor),
              ),
              RadioListTile(
                value: "",
                groupValue: "accountNumber",
                onChanged: (value) {
                  // FormValidation();
                },
                title: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: divideColor.withOpacity(0.1),
                  child: ShimmerCell(
                      cellheight: 10.0, cellwidth: width(context) / 4),
                ),
              ),
            ]),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: width(context) / 2.5,
                  height: height(context) / 14,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: null,
                    child: appText(
                        data: "Add",
                        size: width(context) * 0.04,
                        weight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
