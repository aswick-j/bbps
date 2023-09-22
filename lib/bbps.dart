// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bbps_platform_interface.dart';
import 'utils/const.dart';
import 'utils/utils.dart';

class Bbps {
  Future<String?> getPlatformVersion() {
    return BbpsPlatform.instance.getPlatformVersion();
  }
}

class BbpsScreen extends StatelessWidget {
  Map<String, dynamic>? data;

  bool isSuccess = false;
  final MyRouter? router;

  BbpsScreen({Key? key, required this.data, this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xff21084A, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
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
          RouteSettings(
            name: splashRoute,
            arguments: data,
          ),
        )!
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router!.generateRoute,
    );
  }
}
