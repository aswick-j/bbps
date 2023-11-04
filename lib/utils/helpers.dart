import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';

import '../widgets/ScrollingText.dart';
import 'commen.dart';
import 'const.dart';

void onSelected(BuildContext context, dynamic? BillerData,
    dynamic? allAutopayData, int value) {
  final DateTime now = DateTime.now();

  switch (value) {
    case 0:
      goToData(context, editBill, {
        "data": BillerData,
      });
      break;
    case 1:
      customDialog(
          context: context,
          message: BillerData.cATEGORYNAME == "Mobile Prepaid"
              ? "You will no longer receive any notifications about the biller in future"
              : "You will no longer receive any notifications about the biller in future and all auto pay setups would be disabled effectively from the next cycle",
          message2: "",
          message3: "",
          title: "Alert!",
          buttonName: "Delete",
          isMultiBTN: true,
          dialogHeight: height(context) / 2.5,
          buttonAction: () {
            Navigator.of(context, rootNavigator: true).pop();

            goToData(context, otpRoute, {
              "from": myBillRoute,
              "templateName": "delete-biller-otp",
              "data": {
                "bILLERNAME": BillerData.bILLERNAME,
                "cbid": BillerData.cUSTOMERBILLID.toString()
              }
            });
          },
          iconSvg: alertSvg);

      break;
    case 2:
      customDialog(
          context: context,
          message: allAutopayData.iSACTIVE == 1
              ? "You are stopping the currently scheduled payment and this is a one time thing. If you want to permanently disable auto pay for this bill, delete it from the list of billers configured for auto payment. You can resume this payment anytime before the date of payment."
              : "Please confirm you want to allow the payment scheduled for auto pay.",
          message2: "",
          message3: "",
          title:
              allAutopayData.iSACTIVE == 1 ? "Stop Autopay" : "Enable Autopay",
          buttonName: "Confirm",
          isMultiBTN: true,
          dialogHeight: allAutopayData.iSACTIVE == 1
              ? height(context) / 2.3
              : height(context) / 2.6,
          buttonAction: () {
            Navigator.of(context, rootNavigator: true).pop();
            goToData(context, otpRoute, {
              "from": fromUpcomingDisable,
              "templateName": allAutopayData.iSACTIVE == 1
                  ? "disable-auto-pay"
                  : "enable-auto-pay",
              "data": {
                "id": allAutopayData.iD,
                "status": allAutopayData.iSACTIVE == 1 ? "0" : "1",
                "billerName": allAutopayData.bILLERNAME
              }
            });
          },
          iconSvg: alertSvg);
      break;
    case 3:
      goToData(context, autoPayEditRoute, {
        "customerBillID": allAutopayData.cUSTOMERBILLID.toString(),
        "autoPayData": allAutopayData,
        "billername": allAutopayData.bILLERNAME,
        "lastPaidAmount": BillerData.lASTBILLAMOUNT.toString(),
        "limit": '50000'
      });
      break;
    case 4:
      allAutopayData.pAYMENTDATE == now.day.toString()
          ? customDialog(
              context: context,
              message:
                  // "Completed auto payments will be reflected in History section",
                  "Biller cannot be deleted as auto pay date is set for today",
              message2: "",
              message3: "",
              title: "Alert",
              buttonName: "Okay",
              isMultiBTN: false,
              dialogHeight: height(context) / 2.6,
              buttonAction: () {
                Navigator.of(context, rootNavigator: true).pop();

                goBack(context);
              },
              iconSvg: alertSvg)
          : customDialog(
              context: context,
              message:
                  "Are you sure you want to delete your bill set up for Auto Pay? Your bill will no longer be paid by us and you will have to pay them manually.",
              message2: "",
              message3: "",
              title: "Alert!",
              buttonName: "Delete",
              isMultiBTN: true,
              dialogHeight: height(context) / 2.5,
              buttonAction: () {
                Navigator.of(context, rootNavigator: true).pop();
                goToData(context, otpRoute, {
                  "from": fromAutoPayDelete,
                  "templateName": "delete-auto-pay",
                  "data": allAutopayData,
                });
              },
              iconSvg: alertSvg);
      break;
  }
}

class AutopayInfoText extends StatelessWidget {
  String text;
  AutopayInfoText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context) * 0.95,
      height: height(context) * 0.03,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 204, 64),

        // border: Border.all(
        //   color: Colors.orangeAccent,
        // ),
      ),
      child: ScrollingText(
        text: text,
        textStyle:
            TextStyle(fontSize: width(context) * 0.032, color: Colors.black),
      ),
    );
  }
}
