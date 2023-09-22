import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';
import 'shimmerCell.dart';

class myBillsShimmer extends StatelessWidget {
  const myBillsShimmer({super.key});

  countLoaderText(icon, iconColor, word, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            appText(
              data: word,
              size: width(context) * 0.035,
              color: txtSecondaryColor,
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Shimmer.fromColors(
          baseColor: dashColor,
          highlightColor: divideColor,
          child: ShimmerCell(cellheight: 10.0, cellwidth: width(context) / 20),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          bottom: height(context) / 1.6,
          left: 0,
          child: Container(
            width: width(context),
            color: primaryColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              verticalSpacer(height(context) * 0.05),
            ]),
          ),
        ),
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: width(context) * 0.040,
                      left: width(context) * 0.040,
                      right: width(context) * 0.040),
                  padding: EdgeInsets.all(width(context) * 0.040),
                  height: height(context) / 1.2,
                  width: width(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    // padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
                    height: height(context),
                    width: width(context),
                    decoration: BoxDecoration(
                      color: txtColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: width(context) * 0.040),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: appText(
                                  data: "Transaction Detail",
                                  size: width(context) * 0.045,
                                  weight: FontWeight.bold,
                                  color: txtPrimaryColor),
                            ),
                          ),
                        ),
                        Container(
                          // height: height(context),
                          decoration: BoxDecoration(
                            color: primaryBodyColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              //Amount
                              Container(
                                height: height(context) / 8,
                                margin: EdgeInsets.only(
                                  top: width(context) * 0.008,
                                  right: width(context) * 0.008,
                                  left: width(context) * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: txtColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width(context) * 0.040),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(rupeeSvg),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width(context) * 0.040,
                                          top: width(context) * 0.040,
                                          bottom: width(context) * 0.040,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            appText(
                                              data: "Total Paid Amount",
                                              size: width(context) * 0.035,
                                              color: txtSecondaryColor,
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: dashColor,
                                              highlightColor: divideColor,
                                              child: ShimmerCell(
                                                  cellheight: 10.0,
                                                  cellwidth:
                                                      width(context) / 4),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Success & Failure
                              Container(
                                height: height(context) / 10,
                                margin: EdgeInsets.only(
                                  top: width(context) * 0.008,
                                  right: width(context) * 0.008,
                                  left: width(context) * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: txtColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: width(context) * 0.040,
                                    left: width(context) * 0.016,
                                    top: width(context) * 0.040,
                                    bottom: width(context) * 0.040,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      countLoaderText(
                                        Icons.check,
                                        alertSuccessColor,
                                        "  Success",
                                        context,
                                      ),
                                      VerticalDivider(
                                        color: dashColor,
                                        indent: 2,
                                        endIndent: 2,
                                        thickness: 1,
                                      ),
                                      countLoaderText(
                                        Icons.close,
                                        alertFailedColor,
                                        "  Failed",
                                        context,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: width(context) * 0.008,
                                  left: width(context) * 0.008,
                                  right: width(context) * 0.008,
                                ),
                                height: height(context) / 2,
                                decoration: BoxDecoration(
                                  color: txtColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(width(context) * 0.040),
                                  child: Container(
                                    height: height(context),
                                    width: width(context),
                                    child: Shimmer.fromColors(
                                      baseColor: dashColor,
                                      highlightColor: divideColor,
                                      child: ShimmerCell(
                                          cellheight: height(context) / 2.3,
                                          cellwidth: width(context)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
    ;
  }
}
