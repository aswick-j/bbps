import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'const.dart';
import 'utils.dart';

horizondalSpacer(double width) {
  return SizedBox(
    width: width,
  );
}

verticalSpacer(double height) {
  return SizedBox(
    height: height,
  );
}

showSnackBar(msg, context) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

// String k_m_b_generator(num) {
//   if (num > 999 && num < 99999) {
//     return "${(num / 1000).toStringAsFixed(1)} K";
//   } else if (num > 99999 && num < 999999) {
//     return "${(num / 1000).toStringAsFixed(0)} K";
//   } else if (num > 999999 && num < 999999999) {
//     return "${(num / 1000000).toStringAsFixed(1)} M";
//   } else if (num > 999999999) {
//     return "${(num / 1000000000).toStringAsFixed(1)} B";
//   } else {
//     return num.toString();
//   }
// }

appText(
    {@required data,
    color,
    @required size,
    weight,
    decorate,
    align,
    maxline,
    lineHeight,
    flowType,
    textAlign}) {
  return Text(
    data ?? '',
    textScaleFactor: 1.0,
    softWrap: false,
    overflow: flowType ?? TextOverflow.ellipsis,
    textAlign: align ?? TextAlign.left,
    maxLines: maxline ?? 2,
    style: TextStyle(
      color: color ?? Colors.white,
      fontSize: size,
      fontFamily: appFont,
      height: lineHeight ?? 0,
      fontWeight: weight ?? FontWeight.normal,
      decoration: decorate ?? TextDecoration.none,
    ),
  );
}

// commen appbar
myAppBar({
  @required context,
  @required title,
  List<Widget>? actions,
  backgroundColor,
  bottom,
}) {
  return bottom != null
      ? AppBar(
          centerTitle: false,
          leading: IconButton(
            splashRadius: 25,
            onPressed: () => goBack(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: txtColor,
            ),
          ),
          actions: actions != null
              ? actions.isNotEmpty
                  ? actions
                  : null
              : null,
          backgroundColor: backgroundColor ?? primaryColor,
          title: appText(
            data: title,
            size: width(context) * 0.05,
            weight: FontWeight.w600,
          ),
          elevation: 0,
          bottom: bottom)
      : AppBar(
          centerTitle: false,
          leading: IconButton(
            splashRadius: 25,
            onPressed: () => goBack(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: txtColor,
            ),
          ),
          actions: actions != null
              ? actions.isNotEmpty
                  ? actions
                  : null
              : null,
          backgroundColor: backgroundColor ?? primaryColor,
          title: appText(
            data: title,
            size: width(context) * 0.06,
            weight: FontWeight.w600,
          ),
          elevation: 0,
        );
}

customDialog(
    {context,
    message,
    required String message2,
    required String message3,
    title,
    buttonName,
    buttonAction,
    iconSvg,
    isMultiBTN,
    iconHeight,
    fromConfirmPayment,
    dialogHeight}) {
  var fcp = fromConfirmPayment ?? false;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            height: dialogHeight ?? height(context) / 2,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.04,
                  vertical: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: SvgPicture.asset(
                        [
                          "you have no pending bill",
                          "no bill data available at the moment"
                        ].any(message.toString().toLowerCase().contains)
                            ? iconSuccessSvg
                            : iconSvg,
                        height: iconHeight ?? null),
                  ),
                  if (!fcp)
                    appText(
                      data: title,
                      size: width(context) * 0.04,
                      color: txtPrimaryColor,
                      weight: FontWeight.w600,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.03,
                        vertical: fcp
                            ? width(context) * 0.001
                            : width(context) * 0.03),
                    child: appText(
                        data: message,
                        maxline: 6,
                        align: TextAlign.center,
                        size: fcp
                            ? width(context) * 0.04
                            : width(context) * 0.032,
                        color: txtPrimaryColor,
                        weight: fcp ? FontWeight.bold : FontWeight.w500),
                  ),
                  if (message2 != "")
                    appText(
                        data: message2,
                        align: TextAlign.center,
                        size: width(context) * 0.03,
                        color: txtSecondaryDarkColor,
                        weight: FontWeight.w500),
                  if (message3 != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: appText(
                          data: message3,
                          size: width(context) * 0.04,
                          color: txtAmountColor),
                    ),
                  isMultiBTN ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: primaryColor),
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              horizondalSpacer(28.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: alertFailedColor),
                                child: Text(buttonName),
                                onPressed: buttonAction,
                              )
                            ],
                          ),
                        )
                      : myAppButton(
                          context: context,
                          buttonName: buttonName,
                          margin: const EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 0,
                          ),
                          onpress: buttonAction,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/**
[{
  "type" : "bold",
  "message" : "sara its working"
},
{
  "type" : "normal",
  "message" : "sara its working"
}
]


 */

prepaidCustomDialogMultiText(
    {context,
    List<Map<String, dynamic>>? message,
    title,
    buttonName,
    buttonAction,
    iconSvg,
    isMultiBTN,
    iconHeight,
    dialogHeight,
    goToAddBiller}) {
  message?.forEach((element) {});
  log(message.toString(), name: "customDialogMultiText");

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var eachItem;
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            height: dialogHeight ?? height(context) / 2,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.04,
                  vertical: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child:
                        SvgPicture.asset(iconSvg, height: iconHeight ?? null),
                  ),
                  appText(
                    data: title,
                    size: width(context) * 0.04,
                    color: txtPrimaryColor,
                    weight: FontWeight.w600,
                  ),

                  RichText(
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      text: "",
                      children: <TextSpan>[
                        for (eachItem in message!)
                          eachItem['type'] == "normal"
                              ? TextSpan(
                                  text: eachItem['message'],
                                  style: TextStyle(
                                      color: txtSecondaryColor,
                                      fontSize: width(context) * 0.032,
                                      fontWeight: FontWeight.w500))
                              : TextSpan(
                                  text: eachItem['message'],
                                  style: TextStyle(
                                      color: txtPrimaryColor,
                                      fontSize: width(context) * 0.032,
                                      fontWeight: FontWeight.w900),
                                ),
                      ],
                    ),
                  ),

                  // message!.asMap().forEach((key, value) {}),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: width(context) * 0.03,
                  //       vertical: width(context) * 0.03),
                  //   child: appText(
                  //       data: message,
                  //       maxline: 6,
                  //       align: TextAlign.center,
                  //       size: width(context) * 0.032,
                  //       color: txtSecondaryColor,
                  //       weight: FontWeight.w500),
                  // ),
                  isMultiBTN ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: txtPrimaryColor, width: 1.5)),
                                child: Text(
                                  buttonName,
                                  style: TextStyle(
                                    color: txtPrimaryColor,
                                  ),
                                ),
                                onPressed: buttonAction,
                              ),
                              horizondalSpacer(28.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: primaryColor),
                                child: const Text("Done"),
                                onPressed: () {
                                  isMobilePrepaidFrom = false;
                                  goToUntil(context, homeRoute);
                                },
                              ),
                            ],
                          ),
                        )
                      : myAppButton(
                          context: context,
                          buttonName: buttonName,
                          textColour: txtPrimaryColor,
                          color: Colors.white,
                          margin: const EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 10,
                          ),
                          onpress: buttonAction,
                        ),

                  if (!isSavedBillFrom)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: InkWell(
                        onTap: goToAddBiller,
                        child: Text(
                          'Save Biller for Future Payments',
                          style: TextStyle(
                            color: txtAmountColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

customDialogMultiText(
    {context,
    List<Map<String, dynamic>>? message,
    title,
    buttonName,
    buttonAction,
    iconSvg,
    isMultiBTN,
    iconHeight,
    dialogHeight}) {
  message?.forEach((element) {});
  log(message.toString(), name: "customDialogMultiText");

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var eachItem;
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            height: dialogHeight ?? height(context) / 2,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.04,
                  vertical: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child:
                        SvgPicture.asset(iconSvg, height: iconHeight ?? null),
                  ),
                  appText(
                    data: title,
                    size: width(context) * 0.04,
                    color: txtPrimaryColor,
                    weight: FontWeight.w600,
                  ),

                  RichText(
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      text: "",
                      children: <TextSpan>[
                        for (eachItem in message!)
                          eachItem['type'] == "normal"
                              ? TextSpan(
                                  text: eachItem['message'],
                                  style: TextStyle(
                                      color: txtSecondaryColor,
                                      fontSize: width(context) * 0.032,
                                      fontWeight: FontWeight.w500))
                              : TextSpan(
                                  text: eachItem['message'],
                                  style: TextStyle(
                                      color: txtPrimaryColor,
                                      fontSize: width(context) * 0.032,
                                      fontWeight: FontWeight.w900),
                                ),
                      ],
                    ),
                  ),

                  // message!.asMap().forEach((key, value) {}),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: width(context) * 0.03,
                  //       vertical: width(context) * 0.03),
                  //   child: appText(
                  //       data: message,
                  //       maxline: 6,
                  //       align: TextAlign.center,
                  //       size: width(context) * 0.032,
                  //       color: txtSecondaryColor,
                  //       weight: FontWeight.w500),
                  // ),
                  isMultiBTN ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: primaryColor),
                                child: const Text("Cancel"),
                                onPressed: () => goToUntil(context, homeRoute),
                              ),
                              horizondalSpacer(28.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width(context) * 0.30, 40.0),
                                    backgroundColor: alertFailedColor),
                                child: Text(buttonName),
                                onPressed: buttonAction,
                              )
                            ],
                          ),
                        )
                      : myAppButton(
                          context: context,
                          buttonName: buttonName,
                          margin: const EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 10,
                          ),
                          onpress: buttonAction,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

myAppButton(
    {@required context,
    @required buttonName,
    margin,
    @required onpress,
    color,
    textColour,
    wt}) {
  return Container(
    margin: margin ?? const EdgeInsets.all(0.0),
    child: ElevatedButton(
      onPressed: onpress,
      child: appText(
        data: buttonName,
        size: width(context) * 0.04,
        weight: FontWeight.w600,
        color: textColour ?? txtColor,
      ),
      style: ElevatedButton.styleFrom(
        // primary: color ?? primaryColor,
        backgroundColor: color ?? primaryColor,
        minimumSize: Size(wt ?? width(context), height(context) / 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

String CatIcon(String CatName) {
  switch (CatName) {
    case "Mobile Postpaid":
      return iconMobilePostpaidSvg;
    case "Mobile Prepaid":
      return iconPrepaidSvg;
    case "Education Fees":
      return iconEducationFeeSvg;
    case "Landline Postpaid":
      return iconLandlinePostpaidSvg;
    case "DTH":
      return iconDthSvg;
    case "Electricity":
      return iconElectricityBillSvg;
    case "Broadband Postpaid":
      return iconBroadbandPostpaidSvg;
    case "Water":
      return iconWaterTaxSvg;
    case "Gas":
      return iconGasBookingSvg;
    case "LPG Gas":
      return iconLpgGasSvg;
    case "Life Insurance":
      return iconLifeInsuranceSvg;
    case "Loan Repayment":
      return iconLoanPaymentSvg;
    case "Fastag":
      return iconFastagFeeSvg;
    case "Cable TV":
      return iconCableSvg;
    case "Municipal Services":
      return iconMunicipalServicesSvg;
    case "Clubs & Associations":
      return iconClubsAssociationsSvg;
    case "Credit Card":
      return iconCreditCardSvg;
    case "Hospital":
      return iconHospitalServicesSvg;
    case "Housing Society":
      return iconHousingSocietuSvg;
    case "Subscription Fees":
      return iconSubscriptionSvg;
    case "Municipal Taxes":
      return iconMunicipalTaxesSvg;
    case "Health Insurance":
      return iconHealthInsuranceSvg;
    case "Insurance":
      return iconInsuranceSvg;
    default:
      return iconMunicipalTaxesSvg;
  }
}

divideLine() {
  return Divider(
    thickness: 1,
    color: divideColor,
    indent: 16,
    endIndent: 16,
  );
}

PopupMenuItem customPopupMenuItem({
  required BuildContext context,
  @required title,
  required IconData iconData,
  required Color color,
  dynamic value,
}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(width(context) * 0.015),
          decoration: BoxDecoration(
              color: primaryBodyColor, borderRadius: BorderRadius.circular(22)),
          child: Icon(
            iconData,
            size: width(context) * 0.04,
            color: color,
          ),
        ),
        Padding(
            padding: EdgeInsets.all(2),
            child: appText(
              data: title,
              color: txtSecondaryDarkColor,
              size: width(context) * 0.035,
            )),
      ],
    ),
  );
}
