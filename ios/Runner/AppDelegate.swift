import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
        
  static let rootvc = FlutterViewController.init()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let nav = UINavigationController.init(rootViewController: AppDelegate.rootvc)
    nav.setNavigationBarHidden(true, animated: false)
    SwiftChannelMemo.register(with: AppDelegate.rootvc.registrar(forPlugin: "SwiftChannelMemo")!)
    SwiftChannelWallet.register(with: AppDelegate.rootvc.registrar(forPlugin: "SwiftChannelWallet")!)
    SwiftChannelNative.register(with: AppDelegate.rootvc.registrar(forPlugin: "SwiftChannelNative")!)
    SwiftFlutterAppUpgradePlugin.register(with: AppDelegate.rootvc.registrar(forPlugin: "SwiftFlutterAppUpgradePlugin")!)
    ChannelScan.register(with: AppDelegate.rootvc.registrar(forPlugin: "ChannelScan")!)
    GeneratedPluginRegistrant.register(with: AppDelegate.rootvc)
    NSLog("home %@",NSHomeDirectory())
    self.window.rootViewController = nav
    self.window.makeKeyAndVisible()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

