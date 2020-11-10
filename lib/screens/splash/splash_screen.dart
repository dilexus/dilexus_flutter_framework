import 'dart:async';

import 'package:dilexus/imports.dart';

class DxSplashScreen extends StatefulWidget {
  @override
  DxSplashScreenState createState() => DxSplashScreenState();
}

class DxSplashScreenState extends State<DxSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("hello")),
    );
  }

  startTimer() async {
    var duration = new Duration(seconds: FlavorConfig.instance.variables["splashScreenDelay"]);
    return new Timer(duration, navigate);
  }

  Future<void> navigate() async {}
}
