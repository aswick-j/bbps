import 'package:bbps/bbps.dart';
import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';

class PluginScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Plugin Screen'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: BbpsScreen(
          data: params,
          router: MyRouter(),
        ),
      ),
    );
  }
}
