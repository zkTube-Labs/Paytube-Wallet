import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';
import '../public.dart';

class LogsInterceptors extends InterceptorsWrapper {
  // @override
  // Future onRequest(RequestOptions options) {
  //   String url = options.path;
  //   addHeadersParams(url, options);
  //   LogUtil.v('request url: ${options.path}');
  //   LogUtil.v('request header: ${options.headers.toString()} \n');
  //   if (options.data != null) {
  //     LogUtil.v('request params: ${options.data.toString()} \n');
  //   }
  //   return super.onRequest(options);
  // }

    
    
  // @override
  // Future onResponse(Response response) {
  //   // TODO: implement onResponse
  //   if (response != null) {
  //     LogUtil.v('response: ${response.toString()} \n');
  //   }
  //   return super.onResponse(response);
  // }

  // @override
  // Future onError(DioError err) {
  //   // TODO: implement onError
  //   LogUtil.v('request error: ${err.toString()} \n');
  //   LogUtil.v('request error info: ${err.response?.toString() ?? ""} \n');
  //   return super.onError(err);
  // }

  addHeadersParams(String url, RequestOptions options) async {}
}
