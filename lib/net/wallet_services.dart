import 'dart:async';

import 'package:flutter_coinid/models/tokens/collection_tokens.dart';

import '../public.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class WalletServices {
  static void requestUpdateInfo(
      String? imei,
      String? version,
      String? packageName,
      String appType,
      String? productId,
      complationBlock block) {}

  static void requestVersionLog(String appType, complationBlock block) {}

  static Future<String> requestPrice(
      String? contract, String? token, complationBlock? block) async {
    LogUtil.v(
        "requestPrice $token  ${contract?.isValid()} " + contract.toString());
    Completer<String> completer = Completer();
    Future<String> future = completer.future;
    if (contract == null || contract.length == 0) {
      String convert_id = "2781";
      RequestMethod().requestNetwork(Method.GET,
          "https://web-api.coinmarketcap.com/v1/tools/price-conversion?amount=1&convert_id=$convert_id&id=1027",
          (result, code) {
        if (code == 200 && result != null) {
          Map resultMap = result as Map;
          if (resultMap.containsKey("data")) {
            Map data = resultMap["data"];
            num price = data["quote"][convert_id]["price"] ?? 0;
            completer.complete(price.toString());
            LogUtil.v("requestTokenPrice $price ");
          }
        } else {
          completer.complete("0.00");
        }
      });
    } else {
      RequestMethod().requestNetwork(
          Method.GET, "https://cn.etherscan.com/token/$contract",
          (result, code) {
        if (code == 200 && result != null) {
          final document = parse(result.toString());
          List titles = document.querySelector("title")?.text.split("|") ?? [];
          String? value = titles.length < 3
              ? "0.0"
              : titles.first.trim().replaceAll(" ", "").replaceAll("\$", "");
          LogUtil.v("requestTokenPrice $value ");
          completer.complete(value);
        } else {
          completer.complete("0.00");
        }
      });
    }
    return future;
  }

  static Future<String> requestUSDPrice(complationBlock? block) async {
    Completer<String> completer = Completer();
    Future<String> future = completer.future;
    String convert_id = "2787";
    String id = "2781";
    RequestMethod().requestNetwork(Method.GET,
        "https://web-api.coinmarketcap.com/v1/tools/price-conversion?amount=1&convert_id=$convert_id&id=$id",
        (result, code) {
      if (code == 200 && result != null) {
        Map resultMap = result as Map;
        if (resultMap.containsKey("data")) {
          Map data = resultMap["data"];
          num price = data["quote"][convert_id]["price"] ?? 0;
          completer.complete(price.toString());
        }
      } else {
        completer.complete("0.00");
      }
    });
    return future;
  }

  static Future<String> requestBTCPrice(complationBlock? block) async {
    Completer<String> completer = Completer();
    Future<String> future = completer.future;
    String convert_id = "2781";
    String id = "1";
    RequestMethod().requestNetwork(Method.GET,
        "https://web-api.coinmarketcap.com/v1/tools/price-conversion?amount=1&convert_id=$convert_id&id=$id",
        (result, code) {
      if (code == 200 && result != null) {
        Map resultMap = result as Map;
        if (resultMap.containsKey("data")) {
          Map data = resultMap["data"];
          num price = data["quote"][convert_id]["price"] ?? 0;
          completer.complete(price.toString());
        }
      } else {
        completer.complete("0.00");
      }
    });
    return future;
  }

  //获取探索页面数据
  static Future<dynamic> getExploreData(String type) async {
    String url = '';
    if (type == 'exchange') {
      url = 'https://file.zktube.io/json/exchange.json';
    } else {
      url = 'https://file.zktube.io/json/currency.json';
    }
    return RequestMethod()
        .futureRequestData(Method.GET, url, (result, code) {});
  }

  static void requestGetCurrencyTokenPriceAndTokenCount(String? account,
      String convert, String coinType, complationBlock block) {}

  static void requestMyCollectionTokens(String? account, String convert,
      String coinType, complationBlock block) {}

  static void requestFindTokensData(
      String? account, String token, String? coinType, complationBlock block) {}

  static void requestCollectionToken(
      String? account, int? tokenId, String? coinType, complationBlock block) {}

  static void requestGetSystemMessage(
      String? account, int page, int pageSize, complationBlock block) {}

  static void requestClickSystemMessage(
      String? account, int? messageId, complationBlock block) {}

  static void requestClickSystemMessageAllRead(
      String? account, complationBlock block) {}

  static void requestGetTransferNotice(
      List<String?> account, int page, int pageSize, complationBlock block) {}

  static void requestClickTransferNotice(
      String? account, String? trxId, complationBlock block) {}

  static void requestClickTransferNoticeAllRead(
      List<String> account, complationBlock block) {}

  static void requestGetCurrencyInfo(Map params, complationBlock block) {}

  static void updateMyCollection(Map params, complationBlock block) {}

  static void getOtherLinkImageDatas(String coinType, complationBlock block) {}

  static void requestPopularCurrency(complationBlock block) {}

  static void requestCurrencySearch(
      Map<String, dynamic> params, complationBlock block) {}
}
