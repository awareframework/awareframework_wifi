import 'package:flutter/material.dart';
import 'package:awareframework_wifi/awareframework_wifi.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WiFiSensor? sensor;
  WiFiSensorConfig? config;

  @override
  void initState() {
    super.initState();

    config = WiFiSensorConfig()..debug = true;
    config?.interval = 1.0 / 60.0;

    sensor = new WiFiSensor.init(config!);

    sensor?.start();

    sensor?.onWiFiAPDetected.listen((device) {
      print(device);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
        title: const Text('Plugin Example App'),
      )),
    );
  }
}
