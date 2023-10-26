import 'dart:io';

import 'package:bbps/bloc/mybill/mybill_cubit.dart';
import 'package:bbps/utils/const.dart';
import 'package:bbps/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_repository.dart';
import '../../bloc/history/history_cubit.dart';
import '../../utils/commen.dart';
import '../../utils/utils.dart';
import '../history/history_tab_module.dart';
import '../mybills/my_bill.dart';

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
        if (Platform.isAndroid) {
          SystemNavigator.pop(animated: true);
        } else {
          platform_channel.invokeMethod("exitBbpsModule", "");
        }

        break;
      //Redirect to Parent app removal

      // return showAlert();
      case 1:
        return HomeScreen(
          notifyParent: refresh,
        );
      case 2:
        return BlocProvider(
          create: (context) => MybillCubit(repository: apicall),
          child: const MyBillScreen(),
        );
      // case 3:
      //   return BlocProvider(
      //     create: (context) => AutopayCubit(repository: apicall),
      //     child: const AutoPayTabScreen(),
      //   );
      case 3:
        return BlocProvider(
          create: (context) => HistoryCubit(repository: apicall),
          child: const HistoryTabViewScreen(),
          // child: const HistoryTabScreen(),
        );
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
          notchMargin: 4,
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
                  showUnselectedLabels: false,
                  onTap: _onItemTapped,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: iconColor,
                  currentIndex: selectedIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon:
                          Icon(Icons.home_sharp, size: height(context) * 0.04),
                      label: "",
                      activeIcon:
                          Icon(Icons.home_filled, size: height(context) * 0.04),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconAppHomeSvg),
                      label: "",
                      activeIcon: SvgPicture.asset(iconAppHomeSelectedSvg),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(iconMyBillSvg),
                      // icon: Icon(Icons.perm_contact_cal_outlined,
                      //     size: height(context) * 0.04),
                      label: "",
                      activeIcon: SvgPicture.asset(iconMyBillSelectedSvg),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: SvgPicture.asset(iconAutoPaySvg),
                    //   label: "",
                    //   activeIcon: SvgPicture.asset(iconAutoPaySelectedSvg),
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_rounded,
                          size: height(context) * 0.04),
                      label: "",
                      activeIcon: Icon(Icons.history_rounded,
                          size: height(context) * 0.04),
                      // icon: SvgPicture.asset(iconOtherOptionsSvg),
                      // label: "",
                      // activeIcon: SvgPicture.asset(iconOtherOptionsSelectedSvg),
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
