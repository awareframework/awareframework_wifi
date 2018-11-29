import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class WiFiSensor extends AwareSensorCore {
  static const MethodChannel _wifiMethod = const MethodChannel('awareframework_wifi/method');
  static const EventChannel  _wifiStream  = const EventChannel('awareframework_wifi/event');

  static const EventChannel  _onWiFiAPDetectedStream  = const EventChannel('awareframework_wifi/event_on_wifi_ap_detected');
  static const EventChannel  _onWiFiDisabledStream    = const EventChannel('awareframework_wifi/event_on_wifi_disabled');
  static const EventChannel  _onWiFiScanStartedStream = const EventChannel('awareframework_wifi/event_on_wifi_scan_started');
  static const EventChannel  _onWiFiScanEndedStream   = const EventChannel('awareframework_wifi/event_on_wifi_scan_ended');

  /// Init Wifi Sensor with WifiSensorConfig
  WiFiSensor(WiFiSensorConfig config):this.convenience(config);
  WiFiSensor.convenience(config) : super(config){
    super.setMethodChannel(_wifiMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onWiFiAPDetected {
//     return _onWiFiAPDetectedStream.receiveBroadcastStream(['on_wifi_ap_detected']).map((dynamic event) => Map<String,dynamic>.from(event));
    return super.getBroadcastStream(_onWiFiAPDetectedStream, 'on_wifi_ap_detected').map((dynamic event) => Map<String,dynamic>.from(event));
  }

  Stream<dynamic> get onWiFiDisabled {
    // return _onWiFiDisabledStream.receiveBroadcastStream(['on_wifi_disabled']);
    return super.getBroadcastStream(_onWiFiDisabledStream, 'on_wifi_disabled');
  }

  Stream<dynamic> get onWiFiScanStarted {
    return super.getBroadcastStream(_onWiFiScanStartedStream, 'on_wifi_scan_started');
  }

  Stream<dynamic> get onWiFiScanEnded {
    return super.getBroadcastStream(_onWiFiScanEndedStream, 'on_wifi_scan_ended');
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream('on_wifi_ap_detected');
    super.cancelBroadcastStream('on_wifi_disabled');
    super.cancelBroadcastStream('on_wifi_scan_started');
    super.cancelBroadcastStream('on_wifi_scan_ended');
  }

}

class WiFiSensorConfig extends AwareSensorConfig{
  WiFiSensorConfig();
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}


/// Make an AwareWidget
class WiFiCard extends StatefulWidget {
  WiFiCard({Key key, @required this.sensor}) : super(key: key);

  final WiFiSensor sensor;

  String data = "AP: unknown";
  String state = "state: unknown";

  @override
  WiFiCardState createState() => new WiFiCardState();
}


class WiFiCardState extends State<WiFiCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onWiFiAPDetected.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.data = "AP: $event";
          print(widget.data);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });

    widget.sensor.onWiFiDisabled.listen((event) {
      setState((){
        widget.state = "state: disabled";
      });
    });

    widget.sensor.onWiFiScanEnded.listen((event) {
      setState((){
        widget.state = "state: scan end";
      });
    });

    widget.sensor.onWiFiScanStarted.listen((event) {
      setState((){
        widget.state = "state: scan start";
      });
    });

    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text("${widget.state}\n${widget.data}"),
        ),
      title: "WiFi",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
