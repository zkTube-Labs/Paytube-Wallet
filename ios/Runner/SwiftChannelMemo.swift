//
//  SwiftChannelMemo.swift
//  Runner
//
//  Created by MWT on 2/11/2020.
//

import Foundation


class SwiftChannelMemo: NSObject , FlutterPlugin{
    
    static let CHANNEL_NAME = "plugins.coinidwallet.memos";
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel  = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftChannelMemo()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "createWalletMemo" ) {
            
            let numberValue : NSNumber = call.arguments as! NSNumber
            let count : MMemoCount = MMemoCount(rawValue: numberValue.intValue)!
            let cnMemos : Array  = CoinIDHelper.createWalletMemo(count, memoType: MMemoType.chinese);
            let enMemos : Array = CoinIDHelper.createWalletMemo(count, memoType: MMemoType.english);
            let cnStandMemos : Array  = CoinIDHelper.createWalletMemo(count, memoType: MMemoType.chinese);
            let enStandMemos : Array  = CoinIDHelper.createWalletMemo(count, memoType: MMemoType.english);
            let someDict:[String: Array<String>] = ["cnMemos": cnMemos, "enMemos":enMemos,"cnStandMemos" : cnStandMemos ,"enStandMemos" :enStandMemos]
            result(someDict);
            
        }else if (call.method == "checkMemoValid" ) {
            let memos  = call.arguments as! String;
            let value  = CoinIDHelper.checkMemoValid(memos);
            result(value)
        }
        else{
            result(FlutterMethodNotImplemented);
        }
    }
}
