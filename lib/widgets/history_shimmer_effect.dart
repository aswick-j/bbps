import 'package:bbps/widgets/shimmerCell.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/const.dart';
import '../utils/utils.dart';

class HistoryShimmerEffect extends StatelessWidget {
  const HistoryShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBodyColor,
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
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (_, __) => Divider(
                    color: Color.fromARGB(255, 51, 53, 59),
                    thickness: 6,
                  ),
                  itemCount: 7,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              ShimmerCell(cellheight: 60.0, cellwidth: 60),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerCell(
                                      cellheight: 10.0,
                                      cellwidth: width(context) / 2.8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ShimmerCell(
                                        cellheight: 10.0,
                                        cellwidth: width(context) / 2.4),
                                  )
                                ],
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            endIndent: 10.0,
                            indent: 10.0,
                            color: divideColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ShimmerCell(
                                                cellheight: 10.0,
                                                cellwidth:
                                                    width(context) / 3.5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: ShimmerCell(
                                                  cellheight: 10.0,
                                                  cellwidth:
                                                      width(context) / 3.8),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 80,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ShimmerCell(
                                                cellheight: 10.0,
                                                cellwidth:
                                                    width(context) / 3.5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: ShimmerCell(
                                                  cellheight: 10.0,
                                                  cellwidth:
                                                      width(context) / 6.2),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                              ],
                            ),
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
