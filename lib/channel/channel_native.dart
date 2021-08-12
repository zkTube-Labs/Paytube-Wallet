import 'dart:convert';

import 'package:flutter/services.dart';

import '../public.dart';

class ChannelNative {
  static const MethodChannel _channel =
      const MethodChannel(Constant.CHANNEL_Natives);

  //加密
  static Future<String?> encKeyByAES128CBC(
      String input, String inputPIN) async {
    if (input == null ||
        input.length == 0 ||
        inputPIN == null ||
        inputPIN.length == 0) {
      return null;
    }
    var map = {'input': input, 'inputPIN': inputPIN};
    return await _channel.invokeMethod('CoinID_EncKeyByAES128CBC', map);
  }

  //解密
  static Future<String?> decByAES128CBC(String? input, String inputPIN) async {
    if (input == null ||
        input.length == 0 ||
        inputPIN == null ||
        inputPIN.length == 0) {
      return null;
    }
    var map = {'input': input, 'inputPIN': inputPIN};
    return await _channel.invokeMethod('CoinID_DecByAES128CBC', map);
  }

  //EOS交易序列化方法
  static Future<Map?> serializeEosTranJSON(String jsonTran) async {
    if (jsonTran == null || jsonTran.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran};
    return await _channel.invokeMethod('CoinID_serializeTranJSON', map);
  }

  //EOS交易序列化方法(冷端防篡改)
  static Future<Map?> serializeTranJSONOnly(String jsonTran) async {
    if (jsonTran == null || jsonTran.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran};
    return await _channel.invokeMethod('CoinID_serializeTranJSONOnly', map);
  }

  //EOS签名方法
  static Future<String?> getEosTranSigJson(
      String jsonTran, String prvKey) async {
    if (jsonTran == null ||
        jsonTran.length == 0 ||
        prvKey == null ||
        prvKey.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran, 'prvKey': prvKey};
    return await _channel.invokeMethod('CoinID_GetTranSigJson', map);
  }

  //EOS签名打包方法
  static Future<String?> packEosTranJson(
      String sigData, String packData, int recid, int msgLen) async {
    if (sigData == null ||
        sigData.length == 0 ||
        packData == null ||
        packData.length == 0 ||
        recid < 0 ||
        msgLen < 0) {
      return null;
    }
    var map = {
      'sigData': sigData,
      'packData': packData,
      'recid': recid,
      'msgLen': msgLen
    };
    return await _channel.invokeMethod('CoinID_packTranJson', map);
  }

  //EOS签名打包方法(冷端防篡改)
  static Future<String?> packEosTranJsonOnly(String sigData, int recid) async {
    if (sigData == null || sigData.length == 0 || recid < 0) {
      return null;
    }
    var map = {
      'sigData': sigData,
      'recid': recid,
    };
    return await _channel.invokeMethod('CoinID_packTranJsonOnly', map);
  }

  //以太坊交易数据序列化
  static Future<Map?> serETHTranByStr(
      String nonce,
      String gasprice,
      String startgas,
      String to,
      String value,
      String data,
      String chainId) async {
    if (nonce == null ||
        nonce.length == 0 ||
        gasprice == null ||
        gasprice.length == 0 ||
        startgas == null ||
        startgas.length == 0 ||
        to == null ||
        to.length == 0 ||
        value == null ||
        value.length == 0 ||
        data == null ||
        data.length == 0 ||
        chainId == null ||
        chainId.length == 0) {
      return null;
    }
    var map = {
      'nonce': nonce,
      'gasprice': gasprice,
      'startgas': startgas,
      'to': to,
      'value': value,
      'data': data,
      'chainId': chainId
    };
    return await _channel.invokeMethod('CoinID_serETH_TX_by_str', map);
  }

  //以太坊交易签名
  static Future<String?> sigETHTranByStr(
      {String? nonce,
      String? gasprice,
      String? startgas,
      String? to,
      String? value,
      String? data,
      String? chainId,
      String? prvKey}) async {
    data ??= "";
    var map = {
      'nonce': nonce,
      'gasprice': gasprice,
      'startgas': startgas,
      'to': to,
      'value': value,
      'data': data,
      'chainId': chainId,
      'prvKey': prvKey
    };
    return await _channel.invokeMethod('CoinID_sigETH_TX_by_str', map);
  }

  //以太坊交易签名打包
  static Future<String?> packETHTranByStr(
      String sigOut, String sigData, int recid, String chainId) async {
    var map = {
      'sigOut': sigOut,
      'sigData': sigData,
      'recid': recid,
      'chainId': chainId
    };
    return await _channel.invokeMethod('CoinID_packETH_TX_by_str', map);
  }

  //btc交易数据序列化
  static Future<Map?> serializeBTCTranJSON(
      String jsonTran, String pubKey) async {
    if (jsonTran == null ||
        jsonTran.length == 0 ||
        pubKey == null ||
        pubKey.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran, 'pubKey': pubKey};
    return await _channel.invokeMethod('CoinID_serializeBTCTranJSON', map);
  }

  //btc交易数据序列化（冷端防篡改）
  static Future<Map?> serializeBTCTranJSONOnly(
      String jsonTran, String pubKey) async {
    if (jsonTran == null ||
        jsonTran.length == 0 ||
        pubKey == null ||
        pubKey.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran, 'pubKey': pubKey};
    return await _channel.invokeMethod('CoinID_serializeBTCTranJSONOnly', map);
  }

  //btc交易数据进行签名
  static Future<String?> sigtBTCTransaction(
      String? jsonTran, String prvKey) async {
    if (jsonTran == null ||
        jsonTran.length == 0 ||
        prvKey == null ||
        prvKey.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran, 'prvKey': prvKey};
    return await _channel.invokeMethod('CoinID_sigtBTCTransaction', map);
  }

  //btc交易数据打包
  static Future<String?> packBTCTranJson(
      int segwit, String sigData, String pubKey) async {
    if (sigData == null ||
        sigData.length == 0 ||
        pubKey == null ||
        pubKey.length == 0 ||
        segwit < 0) {
      return null;
    }
    var map = {'segwit': segwit, 'sigData': sigData, 'pubKey': pubKey};
    return await _channel.invokeMethod('CoinID_packBTCTranJson', map);
  }

  //btc交易数据打包（冷端防篡改）
  static Future<String?> packBTCTranJsonOnly(
      String sigData, String pubKey) async {
    if (sigData == null ||
        sigData.length == 0 ||
        pubKey == null ||
        pubKey.length == 0) {
      return null;
    }
    var map = {'sigData': sigData, 'pubKey': pubKey};
    return await _channel.invokeMethod('CoinID_packBTCTranJsonOnly', map);
  }

  //btc钱包地址哈希
  static Future<String?> btcGenScriptHash(String address) async {
    if (address == null || address.length == 0) {
      return null;
    }
    var map = {'address': address};
    return await _channel.invokeMethod('CoinID_genScriptHash', map);
  }

  //将比原地址转换成code
  static Future<String?> getBYTOMCode(String address) async {
    if (address == null || address.length == 0) {
      return null;
    }
    var map = {'address': address};
    return await _channel.invokeMethod('CoinID_getBYTOMCode', map);
  }

  //比原交易序列化
  static Future<Map?> serializeBYTOMTranJSON(String jsonTran) async {
    if (jsonTran == null || jsonTran.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran};
    return await _channel.invokeMethod('CoinID_serializeBYTOMTranJSON', map);
  }

  //比原交易序列化（冷端防篡改）
  static Future<Map?> serializeBYTOMTranJSONOnly(String jsonTran) async {
    if (jsonTran == null || jsonTran.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran};
    return await _channel.invokeMethod(
        'CoinID_serializeBYTOMTranJSONOnly', map);
  }

  //比原交易签名
  static Future<String?> sigtBYTOMTransaction(
      String jsonTran, String prvKey) async {
    if (jsonTran == null ||
        jsonTran.length == 0 ||
        prvKey == null ||
        prvKey.length == 0) {
      return null;
    }
    var map = {'jsonTran': jsonTran, 'prvKey': prvKey};
    return await _channel.invokeMethod('CoinID_sigtBYTOMTransaction', map);
  }

  //比原交易数据签名打包
  static Future<String?> packBYTOMTranJson(String sigOut) async {
    if (sigOut == null || sigOut.length == 0) {
      return null;
    }
    var map = {'sigOut': sigOut};
    return await _channel.invokeMethod('CoinID_packBYTOMTranJson', map);
  }

  //比原交易数据签名打包（冷端防篡改）
  static Future<String?> packBYTOMTranJsonOnly(String sigOut) async {
    if (sigOut == null || sigOut.length == 0) {
      return null;
    }
    var map = {'sigOut': sigOut};
    return await _channel.invokeMethod('CoinID_packBYTOMTranJsonOnly', map);
  }

  //验证EOS交易数据
  static Future<bool?> checkEOSpushValid(
      String pushStr, String to, String value, String unit) async {
    if (pushStr == null ||
        pushStr.length == 0 ||
        to == null ||
        to.length == 0 ||
        value == null ||
        value.length == 0 ||
        unit == null ||
        unit.length == 0) {
      return false;
    }
    var map = {'pushStr': pushStr, 'to': to, 'value': value, 'unit': unit};
    return await _channel.invokeMethod('CoinID_checkEOSpushValid', map);
  }

  //验证ETH交易数据
  static Future<bool?> checkETHpushValid(String? pushStr, String to,
      String value, int decimal, String? contractAddr) async {
    if (pushStr == null ||
        pushStr.length == 0 ||
        to == null ||
        to.length == 0 ||
        value == null ||
        decimal <= 0 ||
        contractAddr == null) {
      return false;
    }
    var map = {
      'pushStr': pushStr,
      'to': to,
      'value': value,
      'decimal': decimal,
      'contractAddr': contractAddr
    };
    return await _channel.invokeMethod('CoinID_checkETHpushValid', map);
  }

  //验证Btc交易数据
  static Future<bool?> checkBTCpushValid(
      String? pushStr,
      String? to,
      String toValue,
      String from,
      String fromValue,
      String usdtValue,
      String coinType,
      bool isSegwit) async {
    if (pushStr == null ||
        pushStr.length == 0 ||
        to == null ||
        to.length == 0 ||
        toValue == null ||
        toValue.length == 0 ||
        from == null ||
        fromValue == null ||
        usdtValue == null ||
        coinType == null ||
        coinType.length == 0) {
      return false;
    }
    var map = {
      'pushStr': pushStr,
      'to': to,
      'toValue': toValue,
      'from': from,
      'fromValue': fromValue,
      'usdtValue': usdtValue,
      'coinType': coinType,
      'isSegwit': isSegwit
    };
    return await _channel.invokeMethod('CoinID_checkBTCpushValid', map);
  }

  //验证比原交易数据
  static Future<bool?> checkBYTOMpushValid(String pushStr, String to,
      String toValue, String from, String fromValue) async {
    if (pushStr == null ||
        pushStr.length == 0 ||
        to == null ||
        to.length == 0 ||
        toValue == null ||
        toValue.length == 0 ||
        from == null ||
        from.length == 0 ||
        fromValue == null ||
        fromValue.length == 0) {
      return false;
    }
    var map = {
      'pushStr': pushStr,
      'to': to,
      'toValue': toValue,
      'from': from,
      'fromValue': fromValue
    };
    return await _channel.invokeMethod('CoinID_checkBYTOMpushValid', map);
  }

  //验证地址格式
  static Future<bool?> checkAddressValid(int? chainType, String address) async {
    if (chainType == null || address == null || address.length == 0) {
      return false;
    }
    String value = Constant.getChainSymbol(chainType);
    var map = {'chainType': value, 'address': address};
    dynamic a = await _channel.invokeMethod('CoinID_checkAddressValid', map);
    LogUtil.v("CoinID_checkAddressValid $a map $map");
    return a;
  }

  //以太系地址格式转换
  static Future<String?> cvtAddrByEIP55(String address) async {
    if (address == null || address.length == 0) {
      return null;
    }
    var map = {'address': address};
    return await _channel.invokeMethod('CoinID_cvtAddrByEIP55', map);
  }

  //筛选UTXO
  static Future<String?> filterUTXO(String utxoJson, String amount, String fee,
      int quorum, int number, String type) async {
    if (utxoJson == null ||
        utxoJson.length == 0 ||
        amount == null ||
        amount.length == 0 ||
        fee == null ||
        fee.length == 0 ||
        quorum <= 0 ||
        type == null ||
        type.length == 0 ||
        number <= 0) {
      return null;
    }
    var map = {
      'utxoJson': utxoJson,
      'amount': amount,
      'fee': fee,
      'quorum': quorum,
      'num': number,
      'type': type
    };
    return await _channel.invokeMethod('CoinID_filterUTXO', map);
  }

  //产生配对公私钥对
  static Future<Map?> genKeyPair() async {
    return await _channel.invokeMethod('CoinID_genKeyPair');
  }

  //产生解密的output
  static Future<String?> keyAgreement(String prvKey, String pubKey) async {
    if (prvKey == null ||
        prvKey.length == 0 ||
        pubKey == null ||
        pubKey.length == 0) {
      return null;
    }
    var map = {'prvKey': prvKey, 'pubKey': pubKey};
    return await _channel.invokeMethod('CoinID_keyAgreement', map);
  }

  static Future<String?> eCDSASign(String msg) async {
    if (msg == null || msg.length == 0) {
      return null;
    }
    var map = {'msg': msg};
    return await _channel.invokeMethod('CoinID_ECDSA_sign', map);
  }

  //配对加密公私钥验证
  static Future<bool?> eCDSAVerify(String msg, String sigData) async {
    if (msg == null ||
        msg.length == 0 ||
        sigData == null ||
        sigData.length == 0) {
      return null;
    }
    var map = {'msg': msg, 'sigData': sigData};
    return await _channel.invokeMethod('CoinID_ECDSA_verify', map);
  }

  //BTC隔离见证方法
  static Future<String?> genBTCAddress(String prvKey, bool segwit) async {
    if (prvKey == null || prvKey.length == 0) {
      return null;
    }
    var map = {'prvKey': prvKey, 'segwit': segwit};
    return await _channel.invokeMethod('CoinID_genBTCAddress', map);
  }

  static Future<String?> sigPolkadotTransaction(
      String jsonTran, String prvKey, String? pubKey) async {
    assert(json != null, "json不为空");
    assert(prvKey != null, "私钥不为空");
    var map = {'prvKey': prvKey, 'jsonTran': jsonTran, "pubKey": pubKey};
    return _channel.invokeMethod('CoinID_sigPolkadotTransaction', map);
  }

  static Future<String?> polkadotgetNonceKey(String address) async {
    assert(address != null, "地址不为空");
    var map = {'address': address};
    return _channel.invokeMethod('CoinID_polkadot_getNonceKey', map);
  }
}
