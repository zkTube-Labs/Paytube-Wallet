import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_coinid/constant/constant.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/utils/log_util.dart';

import '../public.dart';

class WalletObject {
  String? address; //地址
  String? prvKey; //加密后的私钥
  String? pubKey; //公钥
  String? subPrvKey; //子私钥
  String? subPubKey; //子公钥
  String? keyStore; //keystore内容
  int? coinType;
  String? masterPubKey; //主公钥
  String? walletID;
  int? originType;
  String? descName;
  bool? didChoose;
  WalletObject(this.address, this.prvKey, this.pubKey, this.subPrvKey,
      this.subPubKey, this.keyStore, this.coinType, this.masterPubKey);

  WalletObject.fromJson(Map<dynamic, dynamic> json) {
    prvKey = json['prvKey'];
    keyStore = json['keyStore'];
    coinType = json['coinType'];
  }

  WalletObject.fromWallet(MHWallet wallet) {
    address = wallet.walletAaddress;
    pubKey = wallet.pubKey;
    prvKey = wallet.prvKey;
    coinType = wallet.chainType;
    walletID = wallet.walletID;
    originType = wallet.originType;
    descName =
        StringUtil.isNotEmpty(wallet.descName) ? wallet.descName : "null";
  }

  @override
  String toString() {
    Map<String, dynamic> params = {
      'address': this.address,
      'prvKey': this.prvKey,
      'pubKey': this.pubKey,
      'subPubKey': this.subPubKey,
      'subPrvKey': this.subPrvKey,
      'keyStore': this.keyStore,
      'coinType': this.coinType,
      'masterPubKey': this.masterPubKey,
      'walletID': this.walletID,
      'descName': this.descName,
      "didChoose": this.didChoose,
    };
    return jsonEncode(params);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> params = {
      'address': this.address,
      'prvKey': this.prvKey,
      'pubKey': this.pubKey,
      'subPubKey': this.subPubKey,
      'subPrvKey': this.subPrvKey,
      'keyStore': this.keyStore,
      'coinType': this.coinType,
      'masterPubKey': this.masterPubKey,
      'walletID': this.walletID,
      'originType': this.originType,
      'descName': this.descName,
      'didChoose': this.didChoose,
    };
    return params;
  }
}

//助记词相关
class ChannelWallet {
  static const channel_wallets = MethodChannel(Constant.CHANNEL_Wallets);

  // 生成钱包数据
  static Future<List<WalletObject>> importWalletFrom(String content, String pin,
      MLeadType mLeadType, MCoinType mCoinType, MOriginType mOriginType) async {
    Map params = Map();
    params["content"] = content;
    params["pin"] = pin;
    params["mLeadType"] = mLeadType.index;
    params["mCoinType"] = mCoinType.index;
    params["mOriginType"] = mOriginType.index;
    final List result =
        await (channel_wallets.invokeMethod('importWalletFrom', params));
    List<WalletObject> datas = [];
    for (var m in result) {
      LogUtil.v("钱包数据" + m.toString());
      String? prvKey = m["prvKey"] as String?;
      if (prvKey == null || prvKey.length == 0) {
        LogUtil.v("这个钱包无效" + m.toString());
        continue;
      }
      WalletObject walletObject = WalletObject(
          m["address"] as String?,
          prvKey,
          m["pubKey"] as String?,
          m["subPrvKey"] as String?,
          m["subPubKey"] as String?,
          m["keyStore"] as String?,
          m["coinType"] as int?,
          m["masterPubKey"] as String?);
      LogUtil.v("构造object" + m.toString());
      datas.add(walletObject);
    }
    return datas;
  }

  // 导出私钥
  static Future<WalletObject> exportPrvFrom(
      String content, String pin, int? mCoinType) async {
    Map params = Map();
    params["content"] = content;
    params["pin"] = pin;
    params["mCoinType"] = mCoinType;
    final Map result =
        await (channel_wallets.invokeMethod('exportPrvFrom', params));
    WalletObject walletObject = WalletObject.fromJson(result);
    return Future.value(walletObject);
  }

  //导出keystore
  static Future<WalletObject> exportKeyStoreFrom(
      String content, String pin, int? mCoinType) async {
    Map params = Map();
    params["content"] = content;
    params["pin"] = pin;
    params["mCoinType"] = mCoinType;
    final Map result =
        await (channel_wallets.invokeMethod('exportKeyStoreFrom', params));
    WalletObject walletObject = WalletObject.fromJson(result);
    return Future.value(walletObject);
  }

  //获取设备IMEI
  static Future<String?> deviceImei() async {
    return await channel_wallets.invokeMethod('deviceImei', {});
  }

  //获取网络Ping值
  static Future<String?> getAvgRTT(String? url) async {
    return await channel_wallets.invokeMethod('getAvgRTT', url);
  }
}
