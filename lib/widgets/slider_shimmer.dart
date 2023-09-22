import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/const.dart';
import '../utils/utils.dart';

class sliderShimmer extends StatelessWidget {
  const sliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height(context) * 0.22,
          width: width(context),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                    width: width(context) / 1.05,
                    margin: EdgeInsets.only(
                      right: width(context) * 0.040,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: divideColor,
                      period: Duration(seconds: 2),
                      child: Image.asset(equitaspngLogo),
                    ));
              }),
        ),
      ],
    );
  }
}
