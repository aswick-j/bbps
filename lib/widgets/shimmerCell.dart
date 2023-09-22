import 'package:flutter/material.dart';

class ShimmerCell extends StatelessWidget {
  double cellheight;
  double cellwidth;
  ShimmerCell({required this.cellheight, required this.cellwidth});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: cellwidth,
          height: cellheight,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
        ),
      ],
    );
  }
}
