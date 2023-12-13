import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var textField =UITextField();
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.windows.secureApplication()
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func secureApplication() {
    if (!self.window.subviews.contains(textField)) {
      self.window.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.window.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.window.centerXAnchor).isActive = true
        self.window.layer.superlayer?.addSublayer(textField.layer)
        textField.layer.sublayers?.first?.addSublayer(self.window.layer)
    }
  }
  // Call method disable screenshot
  if(call.method.elementsEqual("DisableScreenshot")){
    self.textField.isSecureTextEntry = true
      return
  }
  // Call method enable screenshot
  if(call.method.elementsEqual("EnableScreenshot")){
    self.textField.isSecureTextEntry = false
      return
  }
}

