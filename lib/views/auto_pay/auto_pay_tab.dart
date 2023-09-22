import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'all_auto_pay.dart';
import 'upcomming_schedule.dart';

class AutoPayTabScreen extends StatefulWidget {
  const AutoPayTabScreen({Key? key}) : super(key: key);

  @override
  State<AutoPayTabScreen> createState() => _AutoPayTabScreenState();
}

class _AutoPayTabScreenState extends State<AutoPayTabScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 2),
              textStyle: TextStyle(fontFamily: appFont, color: Colors.white),
              decoration: BoxDecoration(color: primaryColorDark),
              padding: EdgeInsets.all(width(context) * 0.02),
              margin: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              message:
                  "Autopay will be enabled from the 1st of the month you selected while setting up the autopay and payments will be made from the date selected for autopay execution. Until the autopay is enabled, you cannot edit it. To edit the auto pay that is not enabled yet, please wait till the autopay is enabled in the month selected during creation or delete the autopay and create a new one. [UAT-0.0.87]",
              child: Icon(
                Icons.info_outline,
                color: iconColor,
              ),
            ),
          ),
        ],
        backgroundColor: primaryColor,
        title: appText(
            data: 'Auto Pay',
            size: width(context) * 0.06,
            weight: FontWeight.bold),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size(width(context), 60.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: primaryBodyColor,
            child: TabBar(
              physics: const BouncingScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(
                  fontSize: width(context) * 0.04, fontWeight: FontWeight.bold),
              unselectedLabelColor: txtSecondaryColor,
              labelColor: txtAmountColor,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'All Auto Payments',
                ),
                Tab(
                  text: 'Upcoming Scheduled Payments',
                )
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: const [
          AllAutoPayScreen(),
          UpCommingScheduleScreen(),
        ],
      ),
    );
  }
}
