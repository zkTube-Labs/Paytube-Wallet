//
//  SwiftChannelNative.swift
//  Runner
//
//  Created by MWT on 30/10/2020.
//

import Foundation

class SwiftChannelNative: NSObject , FlutterPlugin{
    static let CHANNEL_NAME = "plugins.coinidwallet.natives";
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel  = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftChannelNative()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let arguments  = call.arguments as? Dictionary<String,Any>
        if (call.method == "CoinID_EncKeyByAES128CBC" ) {
            
            let input = arguments?["input"] as! String
            let inputPIN = arguments?["inputPIN"] as! String
            let value = CoinIDTool.coinID_Enc(byAES128CBC: input, pin: inputPIN)
            result(value);
        }else if (call.method == "CoinID_DecByAES128CBC" ) {
            let input = arguments?["input"] as! String
            let inputPIN = arguments?["inputPIN"] as! String
            let value = CoinIDTool.coinID_Dec(byAES128CBC: input, pin: inputPIN)
            result(value);
        }else if (call.method == "CoinID_checkAddressValid" ) {
            let chainType = arguments?["chainType"] as! String
            let address = arguments?["address"] as! String
            let value = CoinIDTool.coinID_checkAddressValid(chainType, address: address)
            result(value);
        }
        else if(call.method == "CoinID_sigETH_TX_by_str"){
            
            let value =  CoinIDTool.coinID_sigETH_TX_(by_str: arguments!)
            result(value);
        }
        else if (call.method == "CoinID_checkETHpushValid"){
            
            let value = CoinIDTool.coinID_checkETHpushValid(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_sigtBTCTransaction"){
            
            let value = CoinIDTool.coinID_sigtBTCTransaction(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_checkBTCpushValid"){
            
            let value = CoinIDTool.coinID_checkBTCpushValid(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_sigtBYTOMTransaction"){
            
            let value = CoinIDTool.coinID_sigtBYTOMTransaction(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_getBYTOMCode"){
            
            let value = CoinIDTool.coinID_getBYTOMCode(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_checkBYTOMpushValid"){
            
            let value = CoinIDTool.coinID_checkBYTOMpushValid(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_GetTranSigJson"){
            
            let value = CoinIDTool.coinID_GetTranSigJson(arguments!)
            result(value);
        }
        else if (call.method == "CoinID_checkEOSpushValid"){
            
            let value = CoinIDTool.coinID_checkEOSpushValid(arguments!)
            result(value);
        }else if (call.method == "CoinID_cvtAddrByEIP55"){
            
            let address =  arguments!["address"] as! String;
            let value = CoinIDTool.coinID_cvtAddr(byEIP55: address)
            result(value);
        }
        else if(call.method == "CoinID_genBTCAddress"){
            
            let value = CoinIDTool.coinID_genBTCAddress(arguments!)
            result(value)
        }
        else if(call.method == "CoinID_filterUTXO"){
            
            let value = CoinIDTool.coinID_filterUTXO(arguments!)
            result(value)
        }
        else if(call.method == "CoinID_genScriptHash"){
            
            let value = CoinIDTool.coinID_genScriptHash(arguments!)
            result(value)
        }
        else if(call.method == "CoinID_sigPolkadotTransaction"){
            
            let value = CoinIDTool.coinID_sigPolkadotTransaction(arguments!)
            result(value)
        }
        else if(call.method == "CoinID_polkadot_getNonceKey"){
            
            let value = CoinIDTool.coinID_polkadot_getNonceKey(arguments!)
            result(value)
        }
        else{
            result(FlutterMethodNotImplemented);
        }
    }
    
    
    

}


