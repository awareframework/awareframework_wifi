import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_wifi/awareframework_wifi.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  WifiSensor sensor;
  WifiSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = WifiSensorConfig()
      ..debug = true;

    sensor = new WifiSensor(config);

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new WifiCard(sensor: sensor,)
      ),
    );
  }
}
