import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class OthersOptions extends StatefulWidget {
  const OthersOptions({Key? key}) : super(key: key);

  @override
  State<OthersOptions> createState() => _OthersOptionsState();
}

menuFeield(context, image, name, content, routeName) {
  return GestureDetector(
    onTap: () => goTo(context, routeName),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: txtColor),
      height: height(context) * 0.16,
      margin: EdgeInsets.all(width(context) * 0.04),
      padding: EdgeInsets.all(width(context) * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: width(context) * 0.16,
          ),
          Padding(
            padding: EdgeInsets.only(left: width(context) * 0.04),
            child: SizedBox(
              width: width(context) * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  appText(
                      data: name,
                      size: width(context) * 0.04,
                      weight: FontWeight.w500,
                      color: txtPrimaryColor),
                  appText(
                      data: content,
                      size: width(context) * 0.035,
                      color: txtSecondaryColor),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => goTo(context, routeName),
            icon: Icon(
              Icons.keyboard_arrow_right,
              size: width(context) * 0.08,
              color: iconColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class _OthersOptionsState extends State<OthersOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        title: appText(
          data: 'Others',
          size: width(context) * 0.06,
          weight: FontWeight.w600,
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Stack(children: [
            Container(
              color: primaryColor,
              height: height(context) * 0.10,
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: txtColor,
                ),
                height: height(context) * 0.16,
                margin: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(equitaspngLogo),
                    Image.asset(bbpspngLogo),
                  ],
                ),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: appText(
                data: "Menus",
                size: width(context) * 0.06,
                weight: FontWeight.w600,
                color: txtPrimaryColor,
              ),
            ),
          ),
          menuFeield(context, historyLogo, 'History',
              'Click here to view the transactions', historyRoute),
          menuFeield(
              context,
              complaintsLogo,
              'Complaints',
              'Click here to add or view registered Complaints',
              complaintRoute),
        ],
      ),
    );
  }
}
