import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'complaint_last_month_txns.dart';
import 'complaint_last_three_months_txns.dart';
import 'complaint_last_week_txns.dart';
import 'complaint_this_month_txns.dart';
import 'complaint_this_week_txns.dart';
import 'complaint_today_txns.dart';
import 'complaint_yesterday_txns.dart';

class NewComplaintTabViewScreen extends StatefulWidget {
  const NewComplaintTabViewScreen({Key? key}) : super(key: key);

  @override
  State<NewComplaintTabViewScreen> createState() =>
      _NewComplaintTabViewScreenState();
}

class _NewComplaintTabViewScreenState extends State<NewComplaintTabViewScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this, initialIndex: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: myAppBar(
        context: context,
        backgroundColor: primaryColor,
        title: 'My Complaints',
        bottom: PreferredSize(
          preferredSize: Size(width(context), 60.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: txtColor,
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
                  text: 'Today',
                ),
                Tab(
                  text: 'Yesterday',
                ),
                Tab(
                  text: 'This Week',
                ),
                Tab(
                  text: 'Last Week',
                ),
                Tab(
                  text: 'This Month',
                ),
                Tab(
                  text: 'Last Month',
                ),
                Tab(
                  text: 'Last 3 Months',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ComplaintTodayTxns(),
          ComplaintYesterdayTxns(),
          ComplaintThisWeekTxns(),
          ComplaintLastWeekTxns(),
          ComplaintThisMonthTxns(),
          ComplaintLastMonthTxns(),
          ComplaintLastThreeMonthTxns()
        ],
      ),
    );
  }
}
