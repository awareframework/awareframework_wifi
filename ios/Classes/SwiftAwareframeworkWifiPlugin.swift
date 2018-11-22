import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_wifi
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkWifiPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, WifiObserver{


    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.wifiSensor = WifiSensor.init(WifiSensor.Config(json))
            }else{
                self.wifiSensor = WifiSensor.init(WifiSensor.Config())
            }
            self.wifiSensor?.CONFIG.sensorObserver = self
            return self.wifiSensor
        }else{
            return nil
        }
    }

    var wifiSensor:WifiSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance =  SwiftAwareframeworkWifiPlugin()
        
        // add own channel
        super.setChannels(with: registrar,
                          instance: instance,
                          methodChannelName: "awareframework_wifi/method",
                          eventChannelName: "awareframework_wifi/event")
        
        let onWiFiAPDetectedStream  = FlutterEventChannel(name: "awareframework_wifi/event_on_wifi_ap_detected",  binaryMessenger: registrar.messenger())
        let onWiFiScanStartedStream = FlutterEventChannel(name: "awareframework_wifi/event_on_wifi_scan_started", binaryMessenger: registrar.messenger())
        let onWiFiDisabledStream    = FlutterEventChannel(name: "awareframework_wifi/event_on_wifi_disabled",     binaryMessenger: registrar.messenger())
        let onWiFiScanEndedStream   = FlutterEventChannel(name: "awareframework_wifi/event_on_wifi_scan_ended",   binaryMessenger: registrar.messenger())
        
        onWiFiDisabledStream.setStreamHandler(instance)
        onWiFiScanStartedStream.setStreamHandler(instance)
        onWiFiAPDetectedStream.setStreamHandler(instance)
        onWiFiScanEndedStream.setStreamHandler(instance)
    }
    
    public func onWiFiAPDetected(data: WiFiScanData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_wifi_ap_detected" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
    
    public func onWiFiDisabled() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_wifi_disabled" {
                handler.eventSink(nil)
            }
        }
    }
    
    public func onWiFiScanStarted() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_wifi_scan_started" {
                handler.eventSink(nil)
            }
        }
    }
    
    public func onWiFiScanEnded() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_wifi_scan_ended" {
                handler.eventSink(nil)
            }
        }
    }
}
