import 'package:bbps/utils/const.dart';
import 'package:bbps/utils/utils.dart';
import 'package:consumerapp/MainAppScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  static const newspl = MethodChannel('equitas.flutter.fas/backButton');

  Future<void> triggerBackButton() async {
    try {
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: triggerBackButton,
              child: const Text('Trigger Back Button'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pluginpage');

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PluginScreen(),
                //   ),
                // );
              },
              child: Text('Go to BBPS Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
