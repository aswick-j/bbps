import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';
import 'shimmerCell.dart';

class historyShimmer extends StatelessWidget {
  const historyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(
                    left: width(context) * 0.032,
                    right: width(context) * 0.032,
                    top: width(context) * 0.032,
                    bottom: 0),
                height: height(context) / 4.8,
                decoration: BoxDecoration(
                    color: txtColor, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
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
                        message: '',
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: divideColor.withOpacity(0.1),
                          child: ShimmerCell(
                              cellheight: 10.0, cellwidth: width(context) / 3),
                        ),
                      ),
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
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: divideColor.withOpacity(0.1),
                            child: ShimmerCell(
                                cellheight: 10.0,
                                cellwidth: width(context) / 3),
                          ),
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
                            child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: divideColor.withOpacity(0.1),
                              child: ShimmerCell(
                                  cellheight: 10.0,
                                  cellwidth: width(context) / 3),
                            ),
                          ),
                          SizedBox(
                              child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: divideColor.withOpacity(0.1),
                                child: ShimmerCell(
                                    cellheight: 10.0,
                                    cellwidth: width(context) / 3),
                              ),
                              horizondalSpacer(8.0),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
