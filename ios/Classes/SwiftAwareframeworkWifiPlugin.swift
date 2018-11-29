import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_wifi
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkWifiPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, WiFiObserver{


    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.wifiSensor = WiFiSensor.init(WiFiSensor.Config(config))
            }else{
                self.wifiSensor = WiFiSensor.init(WiFiSensor.Config())
            }
            self.wifiSensor?.CONFIG.sensorObserver = self
            return self.wifiSensor
        }else{
            return nil
        }
    }

    var wifiSensor:WiFiSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance =  SwiftAwareframeworkWifiPlugin()
        
        super.setMethodChannel(with: registrar, instance: instance, channelName:  "awareframework_wifi/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames:
            [
                "awareframework_wifi/event",
                "awareframework_wifi/event_on_wifi_ap_detected",
                "awareframework_wifi/event_on_wifi_scan_started",
                "awareframework_wifi/event_on_wifi_disabled",
                "awareframework_wifi/event_on_wifi_scan_ended"
            ])
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
