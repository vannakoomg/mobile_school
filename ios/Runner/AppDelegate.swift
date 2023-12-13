import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.windows.secureApp()
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
extension  UIWindow {
func secureApp(){
  let field= UITextfield()
  field.isSecureTextEntry=true
  self.addSubview(field)
  field.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive=true
    field.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive=true
  self.layer.superlayer?.addSublayer(field.layer)
  field.layer.superlayer?.first?.addSublayer(self.layer)
}
  
}
