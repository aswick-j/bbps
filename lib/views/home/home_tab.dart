import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../api/api_repository.dart';
import '../../bloc/autopay/autopay_cubit.dart';
import '../../bloc/mybill/mybill_cubit.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../auto_pay/auto_pay_tab.dart';
import '../mybills/my_bill.dart';
import '../other_options/other_options.dart';
import 'home.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  int selectedIndex = 1;
  @override
  void initState() {
    selectedIndex = 1;
    super.initState();
  }

  ApiCall apicall = ApiCall();

  refresh() {
    setState(() {});
  }

  showAlert() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: SizedBox(
        height: height(context) / 2.7,
        width: width(context) / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // SvgPicture.asset(iconAlertDialog),
            SvgPicture.asset(alertSvg, height: height(context) * 0.09),
            appText(
              data: "Alert!",
              size: width(context) * 0.04,
              color: txtPrimaryColor,
              weight: FontWeight.w600,
            ),
            appText(
                data: "It will redirect to mobile banking home page",
                size: width(context) * 0.034,
                align: TextAlign.center,
                color: txtSecondaryDarkColor),
            appText(
                data: "Are you sure want to redirect",
                size: width(context) * 0.034,
                color: txtSecondaryDarkColor),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2ECC71)),
                  child: const Text("Yes"),
                  onPressed: () {
                    // SystemNavigator.pop(animated: true);
                    if (Platform.isAndroid) {
                      SystemNavigator.pop(animated: true);
                    } else {
                      platform_channel.invokeMethod("exitBbpsModule", "");
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD63031)),
                  child: const Text("No"),
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        return showAlert();
      case 1:
        return HomeScreen(
          notifyParent: refresh,
        );
      case 2:
        return BlocProvider(
          create: (context) => MybillCubit(repository: apicall),
          child: const MyBillScreen(),
        );
      case 3:
        return BlocProvider(
          create: (context) => AutopayCubit(repository: apicall),
          child: const AutoPayTabScreen(),
        );
      case 4:
        return const OthersOptions();
      default:
        return HomeScreen(
          notifyParent: refresh,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (selectedIndex != 0) {
          _onItemTapped(0);
        } else {
          // SystemNavigator.pop(animated: true);
          if (Platform.isAndroid) {
            SystemNavigator.pop(animated: true);
          } else {
            platform_channel.invokeMethod("exitBbpsModule", "");
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _onItemTapped(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Theme(
                data: ThemeData(splashColor: Colors.transparent),
                child: BottomNavigationBar(
                  onTap: _onItemTapped,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: iconColor,
                  currentIndex: selectedIndex,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "",
                      activeIcon: Icon(Icons.home_filled),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconAppHomeSvg),
                      label: "",
                      activeIcon: SvgPicture.asset(iconAppHomeSelectedSvg),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconMyBillSvg),
                      label: "",
                      activeIcon: SvgPicture.asset(iconMyBillSelectedSvg),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconAutoPaySvg),
                      label: "",
                      activeIcon: SvgPicture.asset(iconAutoPaySelectedSvg),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconOtherOptionsSvg),
                      label: "",
                      activeIcon: SvgPicture.asset(iconOtherOptionsSelectedSvg),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
