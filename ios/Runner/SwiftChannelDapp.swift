//
//  SwiftChannelDapp.swift
//  Runner
//
//  Created by MWT on 25/12/2020.
//

import Foundation


class SwiftChannelDapp: NSObject,FlutterPlugin {
    
    static let CHANNEL_NAME = "plugins.coinidwallet.dapps";
    static let sharedInstance = SwiftChannelDapp()
    var methodChannel : FlutterMethodChannel?
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel  = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftChannelDapp.sharedInstance
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        NotificationCenter.default.addObserver(instance, selector: Selector(("observerMethod")), name: NSNotification.Name(rawValue: "updateDIDChoose"), object: nil)
    }
    
    func datas(_ coinType:Int,callBack:@escaping (Any?)->()) -> Void {
        
        let params:[String:Int] = ["coinType":coinType]
        methodChannel?.invokeMethod("datas", arguments: params,result: { (result :Any?) in
            callBack(result)
        })
    }
    
    func observerMethod() -> Void {
        
        print("observerMethod")
    }

    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
       
        if call.method == "pushWeb" {
            let arguments = call.arguments as? Dictionary<String,Any>
            let webVC = LoadWebVC.init()
            webVC.url = arguments?["url"] as? String
            webVC.urlType = URLLoadType.links
            let nav  =  UINavigationController.init(rootViewController: webVC)
            var topRoot  = UIApplication.shared.keyWindow?.rootViewController
            while ((topRoot?.presentedViewController) != nil) {
                topRoot = topRoot?.presentedViewController
            }
            topRoot?.present(nav, animated: true, completion: nil)
        }else{
            result(FlutterMethodNotImplemented);
        }
    }
    
    
}
