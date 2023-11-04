// bbps.dart (Plugin)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/const.dart';
import 'utils/utils.dart';

class AppTrigger {
  AppTrigger._privateConstructor();

  static final AppTrigger instance = AppTrigger._privateConstructor();

  Function? mainAppTrigger;

  void setMainAppTrigger(final Function? Trigger) {
    mainAppTrigger = Trigger;
  }
}

class BbpsScreen extends StatelessWidget {
  Map<String, dynamic>? data;
  final VoidCallback triggerBackButton;

  final MyRouter? router = MyRouter();
  BbpsScreen({
    Key? key,
    required this.data,
    required this.triggerBackButton,
  }) : super(key: key) {
    AppTrigger.instance.setMainAppTrigger(triggerBackButton);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xff21084A,
          <int, Color>{
            50: Color.fromRGBO(33, 8, 74, .1),
            100: Color.fromRGBO(33, 8, 74, .2),
            200: Color.fromRGBO(33, 8, 74, .3),
            300: Color.fromRGBO(33, 8, 74, .4),
            400: Color.fromRGBO(33, 8, 74, .5),
            500: Color.fromRGBO(33, 8, 74, .6),
            600: Color.fromRGBO(33, 8, 74, .7),
            700: Color.fromRGBO(33, 8, 74, .8),
            800: Color.fromRGBO(33, 8, 74, .9),
            900: Color.fromRGBO(33, 8, 74, 1),
          },
        ),
      ),
      initialRoute: splashRoute,
      onGenerateInitialRoutes: (initialRoute) => [
        router!.generateRoute(
          RouteSettings(name: splashRoute, arguments: data),
        )!
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router!.generateRoute,
    );
  }
}
