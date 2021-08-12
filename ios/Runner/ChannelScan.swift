//
//  ChannelScan.swift
//  Runner
//
//  Created by MWT on 5/1/2021.
//

import Foundation


class ChannelScan: NSObject , FlutterPlugin{
    
    static let CHANNEL_NAME = "plugins.coinidwallet.scans";
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel  = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = ChannelScan()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "scan" ) {
            
            let vc = ScanVC.init()
            vc.scanComplation = result
            AppDelegate.rootvc.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            result(FlutterMethodNotImplemented);
        }
    }
}
