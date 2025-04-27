import Flutter
import UIKit
import FirebaseCore
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // Provide Google Maps API key if needed
    GMSServices.provideAPIKey("AIzaSyDUdvTcrvbKWmBYBub0rRsZkhSw_SB07Xk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
