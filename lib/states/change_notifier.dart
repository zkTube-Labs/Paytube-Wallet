import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/pages/main/translist_page.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';
import 'package:flutter_coinid/utils/timer_util.dart';
import 'package:provider/provider.dart';

EventBus eventBus = EventBus();

class CurrentChooseWalletState with ChangeNotifier {
  MHWallet? _mhWallet;
  Map<String?, List<MCollectionTokens>> _collectionTokens = {}; //我的资产
  Map<String?, MainAssetResult?> _mainToken = {}; //主币的价格和数量
  Map<String?, String> _totalAssets = {}; //资产数额
  MCurrencyType? _currencyType;
  MCollectionTokens? _chooseTokens;
  TimerUtil? timer;
  bool requestTokenPrice = false;
  int tokenIndex = 0;

  void loadWallet() async {
    _mhWallet = await MHWallet.findChooseWallet();
    int type = await getAmountValue();
    _currencyType = type == 0 ? MCurrencyType.USD : MCurrencyType.CNY;
    notifyListeners();
    requestAssets(true);
    // _requestData();
  }

  void updateChoose(MHWallet wallet) {
    _mhWallet = wallet;
    MHWallet.updateChoose(wallet);
    notifyListeners();
    requestAssets(true);
  }

  void updateWalletDescName(String newName) {
    _mhWallet!.descName = newName;
    MHWallet.updateWallet(_mhWallet!);
    notifyListeners();
  }

  void updateCurrencyType(MCurrencyType mCurrencyType) {
    _currencyType = mCurrencyType;
    updateAmountValue(mCurrencyType == MCurrencyType.USD);
    findMyCollectionTokens();
  }

  void updateTokenChoose(int index) {
    _chooseTokens = collectionTokens[index];
    tokenIndex = index;
    notifyListeners();
    LogUtil.v(
        "updateTokenChoose index $index " + _chooseTokens!.toJson().toString());
  }

  void requestAssets(bool requestPrice) async {
    if (_mhWallet == null) {
      _mhWallet = await MHWallet.findChooseWallet();
    }
    final String walletAaddress = _mhWallet!.walletAaddress!;
    final String walletID = _mhWallet!.walletID!;
    final String symbol = "ETH";
    final int chainType = _mhWallet!.chainType!;
    final String convert = currencyTypeStr;
    MainAssetResult? cachePrice = _mainToken[walletID];
    if (cachePrice == null) {
      _mainToken[walletID] = MainAssetResult();
    }
    List? cacheValue = _collectionTokens[walletID];
    if (cacheValue == null) {
      num? mainUSDPrice = 0.0;
      num? mainCNYPrice = 0.0;
      num? mainBalance = 0.0;
      MCollectionTokens cacheMap = MCollectionTokens();
      cacheMap.token = symbol;
      cacheMap.coinType = symbol;
      cacheMap.decimals = Constant.getChainDecimals(chainType);
      cacheMap.digits = 6;
      if (convert == "CNY") {
        cacheMap.price = mainCNYPrice.toDouble();
      } else {
        cacheMap.price = mainUSDPrice.toDouble();
      }
      cacheMap.balance = mainBalance as double?;

      // MCollectionTokens ZKTRmap = MCollectionTokens();
      // ZKTRmap.token = "ZKTR";
      // ZKTRmap.coinType = "ETH";
      // ZKTRmap.decimals = 18;
      // ZKTRmap.digits = 4;
      // ZKTRmap.price = 0.0;
      // ZKTRmap.contract = "0xc53d46fd66edeb5d6f36e53ba22eee4647e2cdb2";
      // ZKTRmap.balance = mainBalance as double?;
      _collectionTokens[walletID] = [cacheMap];
      notifyListeners();
    }
    ChainServices.requestAssets(
      chainType: chainType,
      from: walletAaddress,
      contract: null,
      token: null,
      neePrice: requestPrice,
      block: (result, code) {
        if (code == 200) {
          MainAssetResult? value = result as MainAssetResult?;
          _mainToken[walletID] = value;
          LogUtil.v("_mainToken $_mainToken");
        }
        notifyListeners();
        findMyCollectionTokens();
      },
    );
  }

  void findMyCollectionTokens() async {
    if (_mhWallet == null) {
      _mhWallet = await MHWallet.findChooseWallet();
    }

    final String convert = currencyTypeStr;
    String? walletAaddress = _mhWallet!.walletAaddress;
    walletAaddress ??= "";
    final String? walletID = _mhWallet!.walletID;
    num? mainUSDPrice = _mainToken[walletID]!.mainUsdPrice;
    num? mainCNYPrice =
        (_mainToken[walletID]!.usdConversionCny)! * mainUSDPrice!;
    num? mainBalance = num.tryParse(_mainToken[walletID]!.c.toString());
    List<MCollectionTokens> tokens =
        await MCollectionTokens.findStateTokens(walletAaddress, 1);
    for (var item in tokens) {
      if (item.token == "ETH") {
        item.balance = mainBalance?.toDouble();
        if (convert == "CNY") {
          item.price = mainCNYPrice.toDouble();
        } else {
          item.price = mainUSDPrice.toDouble();
        }
        tokens.remove(item);
        tokens.insert(0, item);
        break;
      }
    }
    _collectionTokens[walletID] = tokens;
    notifyListeners();
    _calTotalAssets();
    _calTokenAssets();
  }

  _calTokenAssets() async {
    List rpcList = [];
    int i = 0;
    for (i = 0; i < collectionTokens.length; i++) {
      MCollectionTokens map = collectionTokens[i];
      if (map.isToken == false) {
        continue;
      }
      String owner = map.owner ?? "";
      //0x47ac0fb4f2d84898e4d9e7b4dab3c24507a6d503
      Map params = {};
      String data =
          "0x70a08231000000000000000000000000" + owner.replaceAll("0x", "");
      params["jsonrpc"] = "2.0";
      params["method"] = "eth_call";
      params["params"] = [
        {"to": map.contract, "data": data},
        "latest"
      ];
      params["id"] = map.contract;
      rpcList.add(params);

      if (requestTokenPrice == true) {
        requestTokenPrice = false;
        String price =
            await WalletServices.requestPrice(map.contract, map.token, null);
        map.price = double.tryParse(price);
        MCollectionTokens.updateTokens(map);
      }
    }

    dynamic result = await ChainServices.requestDatas(
        chainType: MCoinType.MCoinType_ETH.index, params: rpcList);
    List datas = result as List;
    if (result is List) {
      for (var response in datas) {
        if (response.keys.contains("result")) {
          String id = response["id"];
          String? bal = response["result"] as String;
          bal = bal.replaceFirst("0x", "");
          bal = bal.length == 0 ? "0.0" : bal;
          bal = (BigInt.tryParse(bal, radix: 16)).toString();
          for (var i = 0; i < collectionTokens.length; i++) {
            MCollectionTokens map = collectionTokens[i];
            if (map.contract?.toLowerCase() == id.toLowerCase()) {
              double? value = (double.tryParse(bal)) ?? 0.0;
              map.balance = ((value / pow(10, map.decimals ?? 0)));
              MCollectionTokens.updateTokens(map);
            }
          }
        }
      }
    }
    notifyListeners();
    _calTotalAssets();
  }

  _calTotalAssets() {
    final String? walletID = _mhWallet!.walletID;
    double sumAssets = 0;
    int i = 0;
    for (i = 0; i < collectionTokens.length; i++) {
      MCollectionTokens map = collectionTokens[i];
      sumAssets += (map.balance ?? 0) * (map.price ?? 0);
    }
    String total = StringUtil.dataFormat(sumAssets, 2);
    _totalAssets[walletID] = total;
    notifyListeners();
  }

  _requestBalance() async {
    if (_mhWallet == null) {
      _mhWallet = await MHWallet.findChooseWallet();
    }
    final String walletAaddress = _mhWallet!.walletAaddress!;
    Map<String, dynamic> balanceParams = Map();
    balanceParams["jsonrpc"] = "2.0";
    balanceParams["method"] = "eth_getBalance";
    balanceParams["params"] = [walletAaddress, "latest"];
    balanceParams["id"] = 1;
    dynamic balresult = await RequestMethod().futureRequestData(
        Method.POST, ChainServices.currentNode!.content, null,
        data: balanceParams);
    if (balresult != null) {
      String? bal = balresult["result"] as String?;
      bal = bal?.replaceFirst("0x", "");
      bal ??= "";
      bal = bal.length == 0 ? "0" : bal;
      bal = (BigInt.tryParse(bal, radix: 16)).toString();
      bal = (double.tryParse(bal)! / pow(10, 18)).toString();
      MainAssetResult? aa = _mainToken[_mhWallet!.walletID];
      aa!.c = bal;
      List rpcList = [];
      int i = 0;
      for (i = 0; i < collectionTokens.length; i++) {
        MCollectionTokens map = collectionTokens[i];
        if (map.isToken == false) {
          continue;
        }
        String owner = map.owner ?? "";
        //0x47ac0fb4f2d84898e4d9e7b4dab3c24507a6d503
        Map params = {};
        String data =
            "0x70a08231000000000000000000000000" + owner.replaceAll("0x", "");
        params["jsonrpc"] = "2.0";
        params["method"] = "eth_call";
        params["params"] = [
          {"to": map.contract, "data": data},
          "latest"
        ];
        params["id"] = map.contract;
        rpcList.add(params);
      }

      dynamic result = await ChainServices.requestDatas(
          chainType: MCoinType.MCoinType_ETH.index, params: rpcList);
      List datas = result as List;
      if (result is List) {
        for (var response in datas) {
          if (response.keys.contains("result")) {
            String id = response["id"];
            String? bal = response["result"] as String;
            bal = bal.replaceFirst("0x", "");
            bal = bal.length == 0 ? "0.0" : bal;
            bal = (BigInt.tryParse(bal, radix: 16)).toString();
            for (var i = 0; i < collectionTokens.length; i++) {
              MCollectionTokens map = collectionTokens[i];
              if (map.contract?.toLowerCase() == id.toLowerCase()) {
                double? value = (double.tryParse(bal)) ?? 0.0;
                map.balance = ((value / pow(10, map.decimals ?? 0)));
                MCollectionTokens.updateTokens(map);
              }
            }
          }
        }
      }
      updateTokenChoose(tokenIndex);
    }
  }

  _requestData() async {
    if (timer == null) {
      timer = TimerUtil(mInterval: 10000);
      timer!.setOnTimerTickCallback((millisUntilFinished) async {
        if (_mhWallet == null) return;
        _requestBalance();
      });
    }
    // if (timer!.isActive() == false) {
    //   timer!.startTimer();
    // }
  }

  MHWallet? get currentWallet => _mhWallet;
  List<MCollectionTokens> get collectionTokens =>
      _mhWallet != null ? _collectionTokens[_mhWallet!.walletID] ??= [] : [];
  String get totalAssets => _mhWallet != null
      ? "${_totalAssets[_mhWallet?.walletID] ?? "0.00"}"
      : "0.00";
  String totalBtcAssets() {
    String assets = _totalAssets[_mhWallet?.walletID] ?? "0.0";
    MainAssetResult? assetResult = _mainToken[_mhWallet?.walletID];
    num btcAssets = assetResult?.btcUsdPrice ?? 0.0;
    LogUtil.v("_totalAssets $assets");
    if (currencyTypeStr == "CNY") {
      btcAssets = btcAssets * (assetResult?.usdConversionCny ?? 0.0);
    }
    if (btcAssets == 0) {
      return "0.0000";
    } else {
      return StringUtil.dataFormat(num.parse(assets) / btcAssets, 4);
    }
  }

  String get currencyTypeStr =>
      _currencyType == MCurrencyType.CNY ? "CNY" : "USD";
  String get currencySymbolStr =>
      _currencyType == MCurrencyType.CNY ? "￥" : "\$";
  MCurrencyType? get currencyType => _currencyType;
  MCollectionTokens? get chooseTokens => _chooseTokens;
}

class MTransListState with ChangeNotifier {
  List<TransRecordModel> _datas = [];

  void requestTransRecord(int chainType, MTransListType? transType, String from,
      String? symbol, int page) async {
    HWToast.showLoading(clickClose: true);
    ChainServices.requestTransRecord(chainType, transType, from, symbol, page,
        (result, code) {
      HWToast.hiddenAllToast();
      if (code == 200 && result != null) {
        if (page == 1) {
          _datas.clear();
        }
        _datas.addAll(result);
      }
      notifyListeners();
    });
  }

  List<TransRecordModel> get datas => _datas;
}

class MCreateWalletState with ChangeNotifier {
  String? _content;
  String? _password;
  String? _pwdTip;
  String? _walletName;
  MCoinType? _coinType;
  MLeadType? _mLeadType;
  MOriginType? _mOriginType;

  String? get content => _content;
  String? get password => _password;
  String? get pwdTip => _pwdTip;
  String? get walletName => _walletName;
  MCoinType? get coinType => _coinType;
  MLeadType? get mLeadType => _mLeadType;
  MOriginType? get mOriginType => _mOriginType;
}

class MNodeState with ChangeNotifier {
  NodeModel? _nodeModel;
  void loadNode() async {
    List<NodeModel>? nodes = await NodeModel.queryNodeByIsChoose(true);
    if (nodes == null || nodes.length == 0) {
      nodes = [];
      _nodeModel = NodeModel(
          "https://mainnet.infura.io/v3/8ca19f6dadfb41afb24bff98fcfc3bb2",
          MCoinType.MCoinType_ETH.index,
          true,
          true,
          true,
          1);
      ChainServices.currentNode = _nodeModel;
      nodes.add(_nodeModel!);
      nodes.add(NodeModel(
          "https://rinkeby.infura.io/v3/0338da10bb39416c8fe2507370eeef8b",
          MCoinType.MCoinType_ETH.index,
          false,
          true,
          false,
          4));
      NodeModel.insertNodeDatas(nodes);
    } else {
      nodes.forEach((element) {
        if (element.chainType == MCoinType.MCoinType_ETH.index &&
            element.isChoose == true) {
          _nodeModel = element;
          ChainServices.currentNode = element;
        }
      });
    }
    notifyListeners();
  }

  void updateNode(NodeModel node) {
    ChainServices.currentNode = node;
    print("ethMainChain");
    _nodeModel = node;
    notifyListeners();
  }

  NodeModel? get currentNode => _nodeModel;

  int? get chainID => _nodeModel?.chainID;

  String nodeTypeStr() {
    String type = "";
    if (_nodeModel?.chainID == 1) {
      type = "Mainnet";
    }
    if (_nodeModel?.chainID == 4) {
      type = "Rinkeby";
    }
    if (_nodeModel?.chainID == 3) {
      type = "Ropsten";
    }
    if (_nodeModel?.chainID == 42) {
      type = "Kovan";
    }
    if (_nodeModel?.chainID == 5) {
      type = "Goerli";
    }
    if (type.length == 0) {
      loadNode();
    }
    return type;
  }
}
