import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bbps/utils/const.dart';
import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// const platform = MethodChannel('com.example.baseapp/bbpsMethodChannel');
// const platform =
//     MethodChannel('com.iexceed.equitas.consumer/bbpsMethodChannel');

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  platform_channel.setMethodCallHandler((call) {
    if (call.method.toString() == 'callBack') {
      debugPrint("IF CONDITION FOR callBack");
      debugPrint(call.arguments.toString());

      redirect(jsonDecode(call.arguments));
    } else {
      debugPrint("ELSE CONDITION FOR callBack ::: ");
      debugPrint("Faild to Load BBPSApp ::: ");
    }
    return Future.value('okay');
  });

// android - flutter build aar --build-number=0.0.54
// ios - flutter build ios-framework --output=../BBPS_IOS_BUILD
//
  // ****** uncomment the below code before for local testing *****

  runApp(
    MediaQuery(
      data: MediaQueryData.fromWindow(ui.window),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MyApp(
          router: MyRouter(),
          initDatas: const {},
        ),
      ),
    ),
  );
}

Future redirect(args) async {
  debugPrint("From Redirect " + args.toString());

  return runApp(
    MediaQuery(
      data: MediaQueryData.fromWindow(ui.window),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MyApp(
          router: MyRouter(),
          initDatas: args,
        ),
      ),
    ),
  );
}

// MyApp
class MyApp extends StatelessWidget {
  Map<String, dynamic>? initDatas;
  final MyRouter? router;
  MyApp({Key? key, @required this.router, this.initDatas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logConsole(initDatas!['checkSum'].toString(), "CHECKSUM :::");
    logConsole(initDatas!['data'].toString(), "DATE ::::");
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
            arguments: initDatas,
          ),
        )!
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router!.generateRoute,
    );
  }
}
