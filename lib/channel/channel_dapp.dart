import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';

import '../public.dart';

class ChannelDapp {
  static const MethodChannel _channel =
      const MethodChannel(Constant.CHANNEL_Dapp);

  static addMethodListener() {
    try {
      _channel.setMethodCallHandler((call) async {
        String method = call.method;
        dynamic arguments = call.arguments;

        LogUtil.v("setMethodCallHandler " +
            method +
            " arguments " +
            arguments.toString());
        if (method == "datas") {
          //获得对应链的钱包数据
          int coinType = arguments["coinType"] as int;
          List<MHWallet> wallets =
              await MHWallet.findWalletsByChainType(coinType);
          List<Map<String, dynamic>> objects = [];
          wallets.forEach((element) {
            if (element.originType == MOriginType.MOriginType_Create.index ||
                element.originType == MOriginType.MOriginType_Restore.index ||
                element.originType == MOriginType.MOriginType_LeadIn.index) {
              objects.add(WalletObject.fromWallet(element).toJson());
            }
          });
          return objects;
        } else if (method == "updateDid") {
          //更新did选中
          String walletID = arguments["walletID"] as String;
          MHWallet? wallets = await MHWallet.findWalletByWalletID(walletID);
          if (wallets != null) {
            MHWallet.updateDIDChoose(wallets);
          }
          return true;
        } else if (method == "getDid") {
          MHWallet? wallet = await MHWallet.finDidChooseWallet();
          return wallet == null
              ? null
              : WalletObject.fromWallet(wallet).toJson();
        } else if (method == "lock") {
          String walletID = arguments["walletID"] as String;
          String? pin = arguments["pin"] as String?;
          MHWallet wallets =
              (MHWallet.findWalletByWalletID(walletID) as MHWallet);
          return wallets.lockPin(text: pin, ok: null, wrong: null);
        }
      });
    } catch (e) {
      LogUtil.v("addMethodListener " + e.toString());
    }
  }

  static Future<void> _pushWeb(String url, int urlType) async {
    var map = {"url": url, "urlType": urlType};
    final dynamic result = await _channel.invokeMethod('pushWeb', map);
  }

  static Future<void> pushBancor() async {
    return _pushWeb("http://oss.coinid.pro/CoinidPro/newBancor/load.html",
        MURLType.Bancor.index);
  }

  static Future<void> pushVdns() async {
    return _pushWeb(
        "http://oss.coinid.pro/allVdns/load.html", MURLType.VDns.index);
  }

  static Future<void> pushVdai() async {
    return _pushWeb(
        "http://oss.coinid.pro/vdai/newindex.html", MURLType.VDai.index);
  }

  static Future<void> pushUrl(String url) async {
    return _pushWeb(url, MURLType.Links.index);
  }
}
