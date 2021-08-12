//
//  SwiftChannelWallet.swift
//  Runner
//
//  Created by MWT on 2/11/2020.
//

import Foundation


class SwiftChannelWallet: NSObject , FlutterPlugin{
    
    static let CHANNEL_NAME = "plugins.coinidwallet.wallets";
    var mpObjects = [String:MPing]()

    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel  = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftChannelWallet()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "importWalletFrom" ) {
            let params : Dictionary = call.arguments as! Dictionary<String, Any>
            let impObj = ImportObject();
            let content = params["content"] as! String ;
            let pin = params["pin"] as! String;
            let mLeadType = params["mLeadType"] as! Int32;
            let mCoinType = params["mCoinType"] as! Int32;
            impObj.content = content ;
            impObj.pin = pin ;
            impObj.mLeadType = mLeadType  ;
            impObj.mCoinType = mCoinType ;
            let value = CoinIDHelper.importWallet(from: impObj);
            result (value);
        }else if (call.method == "exportPrvFrom" ) {
            let arguments : Dictionary = call.arguments as! Dictionary<String, Any>
            let content   = arguments["content"] as! String
            let pin   = arguments["pin"] as! String
            let mCoinType = arguments["mCoinType"] as! Int32
            let value = CoinIDTool.coinID_Dec(byAES128CBC: content, pin: pin)
            let params = ["prvKey":value,"keyStore":"","coinType":mCoinType] as [String : Any]
            result(params)
        }else if (call.method == "exportKeyStoreFrom" ) {

            let arguments : Dictionary = call.arguments as! Dictionary<String, Any>
            let content   = arguments["content"] as! String
            let pin   = arguments["pin"] as! String
            let mCoinType = arguments["mCoinType"] as! Int32
            let prvkey = CoinIDTool.coinID_Dec(byAES128CBC: content, pin: pin)
            let keyStore = CoinIDHelper .fetch_ExportKeyStore(pin, priKey: prvkey, coinType: mCoinType)
            let params = ["prvKey":"","keyStore":keyStore as Any,"coinType":mCoinType] as [String : Any]
            result(params)
        }else if(call.method == "deviceImei"){
            
            let uid  = UIDevice.current.uuid()
            result(uid);
        }
        else if(call.method == "getAvgRTT"){
            var adds = call.arguments as! String
            adds = adds.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
            print("adds  \(adds)")
            let mp  = MPing.init(hostName: adds, count: 1) {[weak self] (item:MPingItem) in
                
                if item.status == MPingManagerStatus.didReceivePacket {
                    
                    let time = "\(Int(item.millSecondsDelay))"
                    print("millSecondsDelay  \(time) host \(item.hostName)")
                    self?.mpObjects.removeValue(forKey: item.hostName)
                    result(time)
                }
            }
            mpObjects[adds] = mp
        }
        else{
            
            result(FlutterMethodNotImplemented);
        }
    }

}
