import 'dart:developer';

import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'const.dart';

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

final GlobalKey _dialogKey = GlobalKey();

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
      return Dialog(
        key: _dialogKey,
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
                      vertical:
                          fcp ? width(context) * 0.001 : width(context) * 0.03),
                  child: appText(
                      data: message,
                      maxline: 6,
                      align: TextAlign.center,
                      size:
                          fcp ? width(context) * 0.04 : width(context) * 0.032,
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
  logConsole(message.toString(), "customDialogMultiText");

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var eachItem;
      return WillPopScope(
        onWillPop: () {
          return Future.value(true);
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

                  // if (!isSavedBillFrom)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 16),
                  //     child: InkWell(
                  //       onTap: goToAddBiller,
                  //       child: Text(
                  //         'Save Biller for Future Payments',
                  //         style: TextStyle(
                  //           color: txtAmountColor,
                  //           fontWeight: FontWeight.w600,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ),
                  //   )
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
  logConsole(message.toString(), "customDialogMultiText");

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

String CatLogo(String CatName) {
  switch (CatName) {
    case "Mobile Postpaid":
      return "packages/bbps/assets/logo/logo_mobilePostpaid.svg";
    case "Mobile Prepaid":
      return "packages/bbps/assets/logo/logo_mobilePrepaid.svg";
    case "Education Fees":
      return "packages/bbps/assets/logo/logo_education.svg";
    case "Landline Postpaid":
      return "packages/bbps/assets/logo/logo_landline.svg";
    case "DTH":
      return "packages/bbps/assets/logo/logo_dth.svg";
    case "Electricity":
    case "ELECTRICITY":
      return "packages/bbps/assets/logo/logo_electricity.svg";
    case "Broadband Postpaid":
      return "packages/bbps/assets/logo/logo_broadbandpost.svg";
    case "Water":
      return "packages/bbps/assets/logo/logo_water.svg";
    case "Gas":
      return "packages/bbps/assets/logo/logo_gas.svg";
    case "LPG Gas":
      return "packages/bbps/assets/logo/logo_lpgGas.svg";
    case "Life Insurance":
      return "packages/bbps/assets/logo/logo_lifeInsurance.svg";
    case "Loan Repayment":
      return "packages/bbps/assets/logo/logo_loanRepay.svg";
    case "Fastag":
      return "packages/bbps/assets/logo/logo_fasttag.svg";
    case "Cable TV":
      return "packages/bbps/assets/logo/logo_cableTV.svg";
    case "Municipal Services":
      return "packages/bbps/assets/logo/logo_municipalService.svg";
    case "Clubs & Associations":
    case "Clubs and Associations":
      return "packages/bbps/assets/logo/logo_clubandasso.svg";
    case "Credit Card":
      return "packages/bbps/assets/logo/logo_creditCard.svg";
    case "Hospital":
      return "packages/bbps/assets/logo/logo_hospital.svg";
    case "Housing Society":
      return "packages/bbps/assets/logo/logo_housingSociety.svg";
    case "Subscription Fees":
    case "Subscription":
      return "packages/bbps/assets/logo/logo_subs.svg";
    case "Municipal Taxes":
      return "packages/bbps/assets/logo/logo_municipal.svg";
    case "Health Insurance":
      return "packages/bbps/assets/logo/logo_healthInsurance.svg";
    case "Insurance":
      return "packages/bbps/assets/logo/logo_insurance.svg";
    default:
      return "packages/bbps/assets/logo/logo_bbps.svg";
  }
}

String BillerLogo(String BillerName, String CatName) {
  switch (BillerName.toLowerCase()) {
    case "airtel dth":
    case "airtel postpaid":
    case "airtel postpaid (fetch and pay)":
    case "airtel broadband (fetch and pay)":
    case "airtel broadband":
      return "packages/bbps/assets/images/icon_airtel.svg";
    case "bsnl":
      return "packages/bbps/assets/images/icon_bsnl.svg";
    case "bsnl mobile postpaid":
      return "packages/bbps/assets/images/icon_bsnl.svg";
    case "vi postpaid":
    case "vi postpaid (fetch and pay)":
      return "packages/bbps/assets/images/icon_vi.svg";
    case "mtnl mumbai dolphin":
      return "packages/bbps/assets/images/icon_mtnl.svg";
    case "jio postpaid":
    case "jio postpaid (fetch and pay)":
      return "packages/bbps/assets/images/icon_jio.svg";
    case "meerut institute of technology":
    case "meerut institute of technology test":
      return "packages/bbps/assets/images/icon_meerut_education.svg";
    case "hdb financial services limited test":
    case "hdb financial services limited":
      return "packages/bbps/assets/images/icon_hdb_loan.svg";
    case "tamil nadu electricity board (tneb)":
    case "ofmedn mobile":
      return "packages/bbps/assets/images/icon_tneb.svg";
    case "bank of baroda":
    case "bank of baroda test":
      return "packages/bbps/assets/images/icon_bob.svg";

    default:
      return CatLogo(CatName);
  }
}

String getTransactionReason(String status) {
  switch (status) {
    case "Memo present on Loan Account.":
      return "Memo present on Loan Account";
    case "aggregator-failed":
    case "aggregator-response-unknown":
      return "Bill Payment failed";
    case "Insufficient Balance.":
    case " Insufficient Balance. ":
      return "Insufficient Balance";
    case "Database Error :":
    case "Called function has had a Fatal Error":
      return "Internal Error";
    case "fund-transfer-failed":
      return "Fund Transfer failed from Bank";
    case "bbps-timeout":
    case "bbps-in-progress":
      return "Waiting Confirmation from Biller";
    case "Customer is KYC Pending/KYC Non-Compliant. KYC Documents need to be collected from Customer.":
      return "KYC Pending";
    default:
      return "Bill Payment Failed";
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
