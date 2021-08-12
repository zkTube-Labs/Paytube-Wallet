import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/net/request_method.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/pages/main/translist_page.dart';
import 'package:flutter_coinid/utils/instruction_data_format.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import '../public.dart';

class MainAssetResult {
  String? c; //余额
  num? mainUsdPrice; //usd单价
  num? usdConversionCny; //1U = ~CNY
  num? btcUsdPrice; //btc单价 1btc = 50000u

  MainAssetResult(
      {this.c, this.mainUsdPrice, this.usdConversionCny, this.btcUsdPrice});

  @override
  String toString() {
    // TODO: implement toString
    return {
      "c": this.c,
      "mainUsdPrice": this.mainUsdPrice,
      "usdConversionCny": this.usdConversionCny,
      "btcUsdPrice": this.btcUsdPrice
    }.toString();
  }
}

class ChainServices {
  static NodeModel? currentNode;
  static String? get ethMainChain => currentNode?.content;

  static void requestChainInfo(
      {required int? chainType,
      required String? from,
      required String amount,
      int? m,
      int? n,
      String? contract,
      required complationBlock block}) {
    assert(chainType != null, "requestChainInfo");
    assert(from != null, "requestChainInfo");
    assert(amount != null, "requestChainInfo");
    assert(block != null, "requestChainInfo");

    if (chainType == MCoinType.MCoinType_ETH.index) {
      return _requestETHAddresssInfo(
          from: from, contract: contract, chainType: chainType, block: block);
    }
  }

  static void requestTokenInfo(
      {required int? chainType,
      required String? from,
      String? contract,
      required complationBlock block}) async {
    Map decimals = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_call",
      "params": [
        {"to": contract, "data": "0x313ce567"},
        "latest"
      ]
    };
    Map symbol = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_call",
      "params": [
        {"to": contract, "data": "0x95d89b41"},
        "latest"
      ]
    };
    Map name = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_call",
      "params": [
        {"to": contract, "data": "0x06fdde03"},
        "latest"
      ]
    };
    if (ethMainChain == null) {
      currentNode = (await NodeModel.queryNodeByIsChoose(true))?.first;
    }
    String url = ethMainChain!;
    RequestMethod().requestNetwork(Method.POST, url, (response, code) {
      if (code == 200 && response is List == true) {
        List datas = response as List;
        bool err = false;
        MCollectionTokens token = MCollectionTokens();
        token.contract = contract!;
        token.digits = 4;
        token.coinType = "ETH";
        token.state = 0;
        token.owner = from;
        for (var i = 0; i < datas.length; i++) {
          Map params = datas[i];
          if (params.keys.contains("result")) {
            String result = params["result"] as String;
            result = result.replaceAll("0x", "");
            if (i == 0) {
              int? decimal = int.tryParse(result, radix: 16);
              LogUtil.v("decimal $decimal");
              token.decimals = decimal;
            } else {
              result = result.substring(128);
              String value = InstructionDataFormat.intToString(result);
              value = value.replaceAll(" ", "").trim();
              LogUtil.v("result  $value");
              if (i == 1) {
                token.token = value;
              }
            }
          } else {
            err = true;
            break;
          }
        }
        if (block != null) {
          if (err == true) {
            block(null, 500);
          } else {
            block(token, 200);
          }
        }
      } else {
        if (block != null) {
          block(null, 500);
        }
      }
    }, data: [decimals, symbol, name]);
  }

  static void requestTransRecord(int chainType, MTransListType? transType,
      String from, String? symbol, int page, complationBlock block) {
    assert(chainType != null, "requestTransRecord");
    assert(from != null, "requestTransRecord");
    assert(block != null, "requestTransRecord");

    if (chainType == MCoinType.MCoinType_ETH.index) {
      return _requestETHTransRecord(transType, from, symbol, page, block);
    } else {
      assert(false, "补充请求");
    }
  }

  static void pushData(
      int chainType, String? packByteString, complationBlock block) {
    assert(chainType != null, "pushData 链类型为空");
    assert(chainType != null, "pushData 签名数据为空");
    if (chainType == MCoinType.MCoinType_ETH.index) {
      packByteString = "0x" + packByteString!;
      return _pushETHData(
          packByteString: packByteString, chainType: chainType, block: block);
    } else {
      assert(false, "补充请求pushData");
    }
  }

  static Future<dynamic>? requestDatas(
      {required int? chainType, dynamic params, complationBlock? block}) async {
    if (ethMainChain == null) {
      currentNode = (await NodeModel.queryNodeByIsChoose(true))?.first;
    }
    String url = ethMainChain!;
    dynamic balresult = await RequestMethod()
        .futureRequestData(Method.POST, url, null, data: params);
    return balresult;
  }

  static Future<dynamic>? requestAssets(
      {required int? chainType,
      required String? from,
      required String? contract,
      required String? token,
      int? tokenDecimal = 18,
      bool neePrice = true,
      complationBlock? block}) {
    assert(chainType != null, "requestAssets");
    assert(from != null);

    if (chainType == MCoinType.MCoinType_ETH.index) {
      return _requestETHAssets(
          chainType: chainType,
          from: from,
          contract: contract,
          neePrice: neePrice,
          tokenDecimal: tokenDecimal,
          token: token,
          block: block);
    } else {
      assert(false, "补充请求requestAssets");
    }
  }

  static void _requestETHTransRecord(MTransListType? transType, String from,
      String? symbol, int page, complationBlock block) async {
    // from = "0x33dc37c534d041fddb6e26e019b49304c985b2b3";
    // from = "0x26f1ab5a967c51a79863a767a20e0564e5aa5e44";

    if (block != null) {
      block([], 200);
    }
    return;

    String url = "";
    if (currentNode?.isMainnet == true) {
      url = "https://cn.etherscan.com/txs?a=$from";
    } else {
      // url = "https://rinkeby.etherscan.io/txs?a=$from";
      url = "https://cn.etherscan.com/txs?a=$from";
    }
    if (page > 1) {
      url += "&p=$page";
    }
    if (transType == MTransListType.MTransListType_Err) {
      url += "&f=1";
    }
    if (transType == MTransListType.MTransListType_In) {
      url += "&f=3";
    }
    if (transType == MTransListType.MTransListType_Out) {
      url += "&f=2";
    }

    List<TransRecordModel> results = [];
    RequestMethod().requestNetwork(Method.GET, url, (result, code) async {
      if (code == 200 && result != null) {
        List<List<String>> values =
            await compute(_parseHtmlValue, result.toString());
        for (var list in values) {
          LogUtil.v(
              "list   " + list.toString() + "   " + list.length.toString());
          if (list.length == 12) {
            String trxid = list[1].trim().replaceAll(" ", "");
            String block = list[3].trim().replaceAll(" ", "");
            String expiration = list[4].trim().replaceAll(" ", "");
            String from = list[6].trim().replaceAll(" ", "");
            String type = list[7].trim().replaceAll(" ", "");
            String to = list[8].trim().replaceAll(" ", "");
            String value = list[9].trim().replaceAll(" ", "");
            value = value.replaceAll("Ether", "").trim();
            String fee = list[10].trim().replaceAll(" ", "");
            TransRecordModel model = TransRecordModel();
            model.fromAdd = from;
            model.date = expiration;
            model.amount = value.toString();
            model.txid = trxid;
            model.symbol = symbol;
            model.coinType = "ETH";
            model.fee = fee;
            model.toAdd = to;
            model.transStatus = transType == MTransListType.MTransListType_Err
                ? MTransState.MTransState_Failere.index
                : int.tryParse(block) == null
                    ? MTransState.MTransState_Pending.index
                    : MTransState.MTransState_Success.index;
            model.transType = type.toLowerCase() == "OUT".toLowerCase()
                ? MTransListType.MTransListType_Out.index
                : type.toLowerCase() == "IN".toLowerCase()
                    ? MTransListType.MTransListType_In.index
                    : MTransListType.MTransListType_Err.index;
            results.add(model);
          }
        }
        if (page == 1) {
          TransRecordModel.insertTrxLists(results);
        }
        if (block != null) {
          LogUtil.v("results   " + results.toString());
          block(results, 200);
        }
      } else {
        if (block != null) {
          block(results, 200);
        }
      }
    });
  }

  static List<List<String>> _parseHtmlValue(String result) {
    try {
      Document? document = parse(result);
      return document
              .querySelector("body")
              ?.getElementsByClassName("wrapper")
              .first
              .children
              .elementAt(1)
              .getElementsByClassName("container space-bottom-2")
              .last
              .getElementsByClassName("card")
              .last
              .getElementsByClassName("card-body")
              .first
              .children
              .elementAt(2)
              .getElementsByClassName("table table-hover")
              .first
              .children
              .last
              .children
              .map((e) => e.children.map((e) => e.text).toList())
              .toList() ??
          [];
    } catch (e) {
      LogUtil.v("_parseHtmlValuerr " + e.toString());
      return [];
    }
  }

  static void _requestETHAddresssInfo(
      {String? from,
      String? contract,
      int? chainType,
      complationBlock? block}) async {
    Map gasPrice = {
      "jsonrpc": "2.0",
      "method": "eth_gasPrice",
      "params": [],
      "id": "p"
    };
    Map nonce = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_getTransactionCount",
      "params": [from, "latest"]
    };
    Map version = {
      "jsonrpc": "2.0",
      "method": "net_version",
      "params": [],
      "id": "v"
    };
    if (ethMainChain == null) {
      currentNode = (await NodeModel.queryNodeByIsChoose(true))?.first;
    }
    String url = ethMainChain!;
    RequestMethod().requestNetwork(Method.POST, url, (response, code) {
      Map<String?, dynamic> values = Map();
      values["g"] = "23788";
      values["v"] = "1";
      if (contract?.isValid() == true) {
        values["g"] = "60000";
      }

      if (code == 200 && response is List == true) {
        List datas = response as List;
        datas.forEach(
          (element) {
            if (element as Map != null) {
              Map params = element;
              if (params.keys.contains("result")) {
                String? result = params["result"] as String?;
                String? id = params["id"] as String?;
                if (id != "v") {
                  result = result!.replaceFirst("0x", '');
                  BigInt bigValue = BigInt.parse(result, radix: 16);
                  values[id] = bigValue.toString();
                } else {
                  values[id] = result;
                }
              }
            }
          },
        );
        if (block != null) {
          block(values, 200);
        }
      } else {
        if (block != null) {
          block(values, 500);
        }
      }
    }, data: [gasPrice, nonce, version]);
  }

  static void requestETHRpc(
      {int? chainType, String? url, dynamic paramas, complationBlock? block}) {
    RequestMethod().requestNetwork(Method.POST, url ?? "", (response, code) {
      if (code == 200 && response is List == true) {
        List datas = response as List;
        datas.forEach(
          (element) {
            if (element is Map) {
              Map params = element;
              if (params.keys.contains("result")) {
                dynamic result = params["result"];
                String? id = params["id"] as String?;
                if (block != null) {
                  block(response, 200);
                }
              }
            }
          },
        );
      } else {
        if (block != null) {
          block(null, 500);
        }
      }
    }, data: paramas);
  }

  static void _pushETHData(
      {String? packByteString, int? chainType, complationBlock? block}) async {
    final Map<String, dynamic> params = {
      "id": "1",
      "jsonrpc": "2.0",
      "method": "eth_sendRawTransaction",
      "params": [packByteString]
    };
    if (ethMainChain == null) {
      currentNode = (await NodeModel.queryNodeByIsChoose(true))?.first;
    }
    String url = ethMainChain!;
    RequestMethod().requestNetwork(Method.POST, url, (response, code) {
      if (code == 200 && response != null) {
        if (response.keys.contains("error")) {
          Map<String, dynamic>? err =
              (response["error"] as Map?) as Map<String, dynamic>?;
          if (err != null) {
            String? message = err["message"] as String?;
            int? code = err["code"] as int?;
            if (block != null) {
              //失败 texid 为空
              block(message, code);
            }
          }
        } else if (response.keys.contains("result")) {
          String? result = response["result"] as String?;
          if (block != null) {
            block(result, 200);
          }
        }
      } else {
        if (block != null) {
          block([], 500);
        }
      }
    }, data: params);
  }

  static Future<dynamic> _requestETHAssets(
      {int? chainType,
      String? from,
      String? contract,
      String? token,
      int? tokenDecimal = 18,
      bool neePrice = true,
      complationBlock? block}) async {
    Map<String, dynamic> balanceParams = Map();
    if (contract?.isValid() == true) {
      String data =
          "0x70a08231000000000000000000000000" + from!.replaceAll("0x", "");

      balanceParams["jsonrpc"] = "2.0";
      balanceParams["method"] = "eth_call";
      balanceParams["params"] = [
        {"to": contract, "data": data},
        "latest"
      ];
      balanceParams["id"] = 1;
    } else {
      balanceParams["jsonrpc"] = "2.0";
      balanceParams["method"] = "eth_getBalance";
      balanceParams["params"] = [from, "latest"];
      balanceParams["id"] = 1;
    }
    if (ethMainChain == null) {
      currentNode = (await NodeModel.queryNodeByIsChoose(true))?.first;
    }
    String url = ethMainChain!;
    MainAssetResult assetResult = MainAssetResult();
    dynamic balresult = await RequestMethod()
        .futureRequestData(Method.POST, url, null, data: balanceParams);
    if (balresult != null && tokenDecimal != 0) {
      String? bal = balresult["result"] as String?;
      bal = bal?.replaceFirst("0x", "");
      bal ??= "";
      bal = bal.length == 0 ? "0" : bal;
      bal = (BigInt.tryParse(bal, radix: 16)).toString();
      if (contract?.isValid() == false) {
        bal = (double.tryParse(bal)! / pow(10, 18)).toString();
      } else {
        bal = (double.tryParse(bal)! / pow(10, tokenDecimal!)).toString();
      }
      assetResult.c = bal;
    }
    if (neePrice == true) {
      String priceResule =
          await WalletServices.requestPrice(contract, token, null);
      assetResult.mainUsdPrice = num.tryParse(priceResule) ?? 0.0;
      if (contract == null || contract.length == 0) {
        String btc = await WalletServices.requestBTCPrice(null);
        String usd = await WalletServices.requestUSDPrice(null);
        assetResult.btcUsdPrice = num.tryParse(btc) ?? 0.0;
        assetResult.usdConversionCny = num.tryParse(usd) ?? 0.0;
      }
    }
    LogUtil.v("assetResult $assetResult");
    if (block != null) {
      block(assetResult, 200);
    }
    return assetResult;
  }
}
