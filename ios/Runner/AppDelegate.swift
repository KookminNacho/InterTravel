import UIKit
import Flutter
//import GoogleMaps // Google Maps SDK for iOS를 import합니다.

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    GMSServices.provideAPIKey("AIzaSyArLt9UWohhdh3W_BLVLICw8_4PvsWoaWo") // Google Maps API 키를 추가합니다.
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
