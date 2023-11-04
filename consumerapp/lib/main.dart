import 'dart:io';

import 'package:consumerapp/NewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MainAppScreen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
// `onBackPressed()` is a method in Android that is called when the back button is pressed on the
// device. In this code snippet, `onBackPressed()` is being called when the method `navigateBack` is
// invoked from Flutter. This allows the Flutter app to navigate back to the previous screen on
// Android.
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routes: {
        '/plugin': (context) => NewScreen(),
        '/pluginpage': (context) => MainAppScreen(),
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const newspl = MethodChannel('equitas.flutter.fas/backButton');

  Future<void> triggerBackButton() async {
    try {
      print("=====================TRIGERED====");

      print("+++++NNN+++");
      await newspl.invokeMethod("triggerBackButton");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.title),
          ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/plugin');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainAppScreen(),
              ),
            );
          },
          child: Text('Go to BBPS Screen'),
        ),
      ),
    );
  }
}
