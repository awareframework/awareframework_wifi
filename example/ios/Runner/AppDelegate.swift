import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CLLocationManagerDelegate {

  var manager:CLLocationManager = CLLocationManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		switch status {
		case .restricted,.denied,.notDetermined:
			// report error, do something
			print("error")
		default:
			// location si allowed, start monitoring
			manager.startUpdatingLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		// manager.stopUpdatingLocation()
		// do something with the error
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// if let locationObj = locations.last {
			// if locationObj.horizontalAccuracy < minAllowedAccuracy {
			// 	manager.stopUpdatingLocation()
			// 	// report location somewhere else
			// }
		// }
	}

}
