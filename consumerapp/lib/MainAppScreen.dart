import 'package:bbps/bbps.dart';
import 'package:bbps/utils/const.dart';
import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAppScreen extends StatefulWidget {
  // final VoidCallback triggerBackButton;

  // MainAppScreen({super.key, required this.triggerBackButton});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  var params = {
    "redirectionRequest": {
      "msgBdy": {
        "IPAddress": "1.1.1.1",
        "platform": "IB",
        "service": "bbps",
        "data": {
          "accounts": [
            {
              "avlBal": "1632.13",
              "entityType": "I",
              "acctTp": "SA",
              "crntSts": "8",
              "acctId": "100007972803",
              "custRltnsp": "SOW",
              "prdNm": "1005-Regular Savings",
              "crntStsDesc": "ACCOUNT OPEN REGULAR"
            }
          ],
          "otpPreference": "SMS",
          "customer": {
            "gndr": "M",
            "mblNb": "919626772779",
            "dob": "1999-02-24",
            "custId": "8010346",
            "emailId": "aswick.j@fasoftwares.com"
          }
        }
      },
      "checkSum":
          "85ef9a4eeb2a4b465da6f14c44ebd1ed487c9fd9a8c3b9af2692b56b7866794b02632718e3af111996e0586ba524c0eb60affb880582d1b39c525165d638ec08"
    }
  };
  bool trigger = false;

  Future<void> triggerBackButton() async {
    try {
      trigger = true;
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => trigger,
      child: Scaffold(
        body: Center(
            child: BbpsScreen(data: params, triggerBackButton: triggerBackButton
                // router: MyRouter(),
                )),
      ),
    );
  }
}
