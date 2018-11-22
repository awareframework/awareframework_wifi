import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class WifiSensor extends AwareSensorCore {
  static const MethodChannel _wifiMethod = const MethodChannel('awareframework_wifi/method');
  static const EventChannel  _wifiStream  = const EventChannel('awareframework_wifi/event');

  static const EventChannel  _onWiFiAPDetectedStream  = const EventChannel('awareframework_wifi/event_on_wifi_ap_detected');
  static const EventChannel  _onWiFiDisabledStream    = const EventChannel('awareframework_wifi/event_on_wifi_disabled');
  static const EventChannel  _onWiFiScanStartedStream = const EventChannel('awareframework_wifi/event_on_wifi_scan_started');
  static const EventChannel  _onWiFiScanEndedStream   = const EventChannel('awareframework_wifi/event_on_wifi_scan_ended');

  /// Init Wifi Sensor with WifiSensorConfig
  WifiSensor(WifiSensorConfig config):this.convenience(config);
  WifiSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_wifiMethod, _wifiStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onWiFiAPDetected {
     return _onWiFiAPDetectedStream.receiveBroadcastStream(['on_wifi_ap_detected']).map((dynamic event) => Map<String,dynamic>.from(event));
  }

  Stream<dynamic> get onWiFiDisabled {
    return _onWiFiDisabledStream.receiveBroadcastStream(['on_wifi_disabled']);
  }

  Stream<dynamic> get onWiFiScanStarted {
    return _onWiFiScanStartedStream.receiveBroadcastStream(['on_wifi_scan_started']);
  }

  Stream<dynamic> get onWiFiScanEnded {
    return _onWiFiScanEndedStream.receiveBroadcastStream(['on_wifi_scan_ended']);
  }

}

class WifiSensorConfig extends AwareSensorConfig{
  WifiSensorConfig();
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class WifiCard extends StatefulWidget {
  WifiCard({Key key, @required this.sensor}) : super(key: key);

  WifiSensor sensor;

  @override
  WifiCardState createState() => new WifiCardState();
}


class WifiCardState extends State<WifiCard> {

  String data = "AP: unknown";
  String state = "state: unknown";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onWiFiAPDetected.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          data = "AP: $event";
          print(data);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });

    widget.sensor.onWiFiDisabled.listen((event) {
      setState((){
          state = "state: disabled";
      });
    });

    widget.sensor.onWiFiScanEnded.listen((event) {
      setState((){
        state = "state: scan end";
      });
    });

    widget.sensor.onWiFiScanStarted.listen((event) {
      setState((){
        state = "state: scan start";
      });
    });

    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text("${state}\n${data}"),
        ),
      title: "WiFi",
      sensor: widget.sensor
    );
  }

}
