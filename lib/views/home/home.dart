import 'package:bbps/bloc/home/home_cubit.dart';
import 'package:bbps/views/home/home_sliders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'bill_category.dart';

class HomeScreen extends StatefulWidget {
  final Function()? notifyParent;
  const HomeScreen({Key? key, this.notifyParent}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return HomeScreenUI();
        },
      ),
    );
  }
}

class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({Key? key}) : super(key: key);

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI>
    with SingleTickerProviderStateMixin {
  GlobalKey _welcome = GlobalKey();
  GlobalKey _searchBiller = GlobalKey();

  final listViewController = PageController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 1,
      vsync: this,
      initialIndex: 0,
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context).startShowCase([_welcome, _searchBiller]);
    // });
  }

  Widget _individualTab(String text) {
    return Container(
      width: width(context) * 0.4,
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: txtHintColor, width: 1, style: BorderStyle.solid))),
      child: Tab(
        text: text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: height(context) / 2.12,
            color: primaryBodyColor,
            child: Stack(
              children: [
                Container(
                  height: height(context) / 3,
                  width: width(context),
                  color: primaryColor,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height(context) * 0.08,
                    ),
                    padding: EdgeInsets.only(
                      left: width(context) * 0.016,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height(context) * 0.1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(width(context) * 0.016),
                                child: appText(
                                    data: "Welcome to BBPS",
                                    color: txtColor,
                                    size: width(context) * 0.06,
                                    weight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width(context) * 0.016),
                                child: appText(
                                  data: "Powered by Equitas",
                                  color: primarySubColor,
                                  size: width(context) * 0.045,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          color: txtColor,
                          padding:
                              EdgeInsets.only(right: width(context) * 0.07),
                          icon: Icon(Icons.search, size: width(context) * 0.09),
                          onPressed: () {
                            goTo(context, billerSearchRoute);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: height(context) * 0.22,
                  left: width(context) * 0.02,
                  child: SizedBox(
                    // height: height(context) * 0.22,
                    width: width(context),
                    // child: HomeSlider(),
                    child: HomeSliders(),
                  ),
                ),
                // Positioned(
                //   top: width(context) / 1.04,
                //   left: height(context) / 4.5,
                //   child: SmoothPageIndicator(
                //     controller: listViewController,
                //     count: cardItem.length,
                //     effect: ColorTransitionEffect(
                //       dotColor: smoothPageIndicatorColor,
                //       activeDotColor: primaryColor,
                //       dotHeight: 8,
                //       dotWidth: 8,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            width: width(context),
            color: primaryBodyColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: width(context) * 0.056,
                      bottom: width(context) * 0.046),
                  child: appText(
                    data: "Bill Categories",
                    color: primaryColor,
                    weight: FontWeight.w600,
                    size: width(context) * 0.040,
                  ),
                ),
                SizedBox(
                  height: height(context) * 0.40,
                  child: BillCategory(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
