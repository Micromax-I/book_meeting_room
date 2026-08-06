import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API key
        GMSServices.provideAPIKey("AIzaSyDab47aoEuUP58eKtiUJuOsbJ9-_V6u98I")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
