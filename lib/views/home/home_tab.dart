import 'dart:async';
import 'dart:io';

import 'package:bbps/bbps.dart';
import 'package:bbps/bloc/mybill/mybill_cubit.dart';
import 'package:bbps/utils/const.dart';
import 'package:bbps/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_repository.dart';
import '../../bloc/history/history_cubit.dart';
import '../../utils/utils.dart';
import '../history/history_tab_module.dart';
import '../mybills/my_bill.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  static const newspl = MethodChannel('equitas.flutter.fas/backButton');

  bool isTriggerDisabled = false;
  Timer? delayedTimer = null;

  Future<void> triggerBackButton() async {
    if (!isTriggerDisabled) {
      try {
        setState(() {
          isTriggerDisabled = true;
        });

        await newspl.invokeMethod("triggerBackButton");
      } catch (e) {
        print("Error: $e");
      } finally {
        delayedTimer = Timer(Duration(seconds: 4), () {
          setState(() {
            isTriggerDisabled = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    delayedTimer?.cancel();
    super.dispose();
  }

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

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        if (Platform.isAndroid) {
          AppTrigger.instance.mainAppTrigger!.call();
          triggerBackButton();
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
      onWillPop: () async => false,
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
