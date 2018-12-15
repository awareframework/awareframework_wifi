import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


/// The WiFi measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = WiFiSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  WiFiSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = WiFiSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<WiFiScanData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onWiFiAPDetected.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = WiFiCard(sensor: sensor);
/// ```
class WiFiSensor extends AwareSensor {
  static const MethodChannel _wifiMethod = const MethodChannel('awareframework_wifi/method');
  // static const EventChannel  _wifiStream  = const EventChannel('awareframework_wifi/event');

  static const EventChannel  _onWiFiAPDetectedStream  = const EventChannel('awareframework_wifi/event_on_wifi_ap_detected');
  static const EventChannel  _onWiFiDisabledStream    = const EventChannel('awareframework_wifi/event_on_wifi_disabled');
  static const EventChannel  _onWiFiScanStartedStream = const EventChannel('awareframework_wifi/event_on_wifi_scan_started');
  static const EventChannel  _onWiFiScanEndedStream   = const EventChannel('awareframework_wifi/event_on_wifi_scan_ended');

  StreamController<WiFiScanData> onWiFiAPDetectedStreamController = StreamController<WiFiScanData>();
  StreamController<dynamic> onWiFiDisabledStreamController = StreamController<dynamic>();
  StreamController<dynamic> onWiFiScanStartedStreamController = StreamController<dynamic>();
  StreamController<dynamic> onWiFiScanEndedStreamController = StreamController<dynamic>();

  WiFiScanData wiFiScanData = WiFiScanData();

  /// Init WiFi Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = WiFiSensor.init(null);
  /// ```
  WiFiSensor():this.init(null);

  /// Init WiFi Sensor with WiFiSensorConfig
  ///
  /// ```dart
  /// var config =  WiFiSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = WiFiSensor.init(config);
  /// ```
  WiFiSensor.init(WiFiSensorConfig config) : super(config){
    super.setMethodChannel(_wifiMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<WiFiScanData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onWiFiAPDetected.listen((data) {
  ///   print(data)
  /// }
  ///
  Stream<WiFiScanData> get onWiFiAPDetected {
    onWiFiAPDetectedStreamController.close();
    onWiFiAPDetectedStreamController = StreamController<WiFiScanData>();
    return onWiFiAPDetectedStreamController.stream;
  }

  StreamController<dynamic> initStreamController(StreamController<dynamic> controller){
    controller.close();
    controller = StreamController<dynamic>();
    return controller;
  }

  Stream<dynamic> get onWiFiDisabled {
    return initStreamController(onWiFiDisabledStreamController).stream;
  }

  Stream<dynamic> get onWiFiScanStarted {
    return initStreamController(onWiFiScanStartedStreamController).stream;
  }

  Stream<dynamic> get onWiFiScanEnded {
    return initStreamController(onWiFiScanEndedStreamController).stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onWiFiAPDetectedStream, 'on_wifi_ap_detected').map(
            (dynamic event) => WiFiScanData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      wiFiScanData = event;
      if (!onWiFiAPDetectedStreamController.isClosed){
        onWiFiAPDetectedStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onWiFiDisabledStream, 'on_wifi_disabled').listen((event){
      if (!onWiFiDisabledStreamController.isClosed){
        onWiFiDisabledStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onWiFiScanStartedStream, 'on_wifi_scan_started').listen((event){
      if(!onWiFiScanStartedStreamController.isClosed){
        onWiFiScanStartedStreamController.add(event);
      }
    });

    super.getBroadcastStream(_onWiFiScanEndedStream, 'on_wifi_scan_ended').listen((event){
      if(!onWiFiScanEndedStreamController.isClosed){
        onWiFiScanEndedStreamController.add(event);
      }
    });

    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream('on_wifi_ap_detected');
    super.cancelBroadcastStream('on_wifi_disabled');
    super.cancelBroadcastStream('on_wifi_scan_started');
    super.cancelBroadcastStream('on_wifi_scan_ended');
    return super.stop();
  }
}

/// A configuration class of WiFiSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  WiFiSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class WiFiSensorConfig extends AwareSensorConfig{
  WiFiSensorConfig();
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// A data model of WiFiSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class WiFiScanData extends AwareData {
  String bssid = "";
  String ssid = "";
  String security = "";
  int frequency = 0;
  int rssi = 0;
  WiFiScanData():this.from(null);
  WiFiScanData.from(Map<String,dynamic> data):super.from(data){
    if (data != null){
      bssid = data["bssid"] ?? "";
      ssid = data["ssid"] ?? "";
      security = data["security"] ?? "";
      frequency = data["frequency"] ?? 0;
      rssi = data["rssi"] ?? 0;
    }
  }
}

///
/// A Card Widget of WiFi Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = WiFiCard(sensor: sensor);
/// ```
class WiFiCard extends StatefulWidget {
  WiFiCard({Key key, @required this.sensor}) : super(key: key);

  final WiFiSensor sensor;

  @override
  WiFiCardState createState() => new WiFiCardState();
}

///
/// A Card State of WiFi Sensor
///
class WiFiCardState extends State<WiFiCard> {

  String data = "AP: ---";
  String state = "state: ---";

  @override
  void initState() {

    super.initState();

    if(mounted){
      setState(() {
        var wifi = widget.sensor.wiFiScanData;
        data = data = "AP: ${wifi.ssid} ${wifi.bssid} ${wifi.frequency}";
      });
    }

    // set observer
    widget.sensor.onWiFiAPDetected.listen((wifi) {
      if(mounted){
        setState((){
          if(wifi!=null){
            DateTime.fromMicrosecondsSinceEpoch(wifi.timestamp);
            data = "AP: ${wifi.ssid} ${wifi.bssid} ${wifi.frequency}";
            print(data);
          }
        });
      }

    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });

    widget.sensor.onWiFiDisabled.listen((event) {
      if(mounted){
        setState((){
          state = "state: disabled";
        });
      }
    });

    widget.sensor.onWiFiScanEnded.listen((event) {
      if(mounted){
        setState((){
          state = "state: scan end";
        });
      }
    });

    widget.sensor.onWiFiScanStarted.listen((event) {
      if(mounted){
        setState((){
          state = "state: scan start";
        });
      }
    });

    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text("$state\n$data"),
        ),
      title: "WiFi",
      sensor: widget.sensor
    );
  }
}
