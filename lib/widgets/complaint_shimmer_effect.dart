import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';
import 'shimmerCell.dart';

class ComplaintShimmerEffect extends StatelessWidget {
  const ComplaintShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: txtColor,
      height: height(context),
      width: width(context),
      child: Container(
        margin: const EdgeInsets.only(
          right: 16,
          left: 16,
        ),
        width: width(context),
        decoration: BoxDecoration(
          color: txtColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: const EdgeInsets.all(16),
          width: width(context),
          decoration: BoxDecoration(
            color: primaryBodyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              height: 200,
              child: Shimmer.fromColors(
                baseColor: divideColor,
                highlightColor: iconColor,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.vertical,
                  itemCount: 9,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          horizondalSpacer(5),
                          Row(
                            children: [
                              ShimmerCell(cellheight: 60.0, cellwidth: 60),
                              horizondalSpacer(10),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShimmerCell(
                                          cellheight: 10.0,
                                          cellwidth: width(context) / 4.2),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ShimmerCell(
                                            cellheight: 10.0,
                                            cellwidth: width(context) / 6.0),
                                      ),
                                    ],
                                  ),
                                  horizondalSpacer(width(context) / 3.6),
                                  Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: txtColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
