import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:isolate';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_coinid/utils/timer_util.dart';
// import 'package:isolate/isolate.dart';
import '../public.dart';
import 'log_interceptor.dart';

enum Method {
  GET,
  POST,
}

int _connectTimeout = 15 * 1000; //15s
int _receiveTimeout = 15 * 1000; //15s
int _sendTimeout = 10 * 1000; //10s

typedef complationBlock = void Function(dynamic result, int? code);

class HWRequestOptions extends Options {
  HWRequestOptions({
    this.method,
    this.data,
    this.queryParameters,
    this.baseUrl,
    this.back,
  });
  String? method;
  dynamic data;
  Map<String, dynamic>? queryParameters;
  String? baseUrl;
  complationBlock? back;
}

class RequestMethod {
  factory RequestMethod() => _getInstance()!;
  static RequestMethod? get manager => _getInstance();
  static RequestMethod? _manager;
  static Dio? get dio => _dio;
  static Dio? _dio;
  static Map<String, CancelToken> _cancelTMap = Map(); //自管理CancelToken
  static RequestMethod? _getInstance() {
    if (_manager == null) {
      _manager = RequestMethod.init();
    }
    return _manager;
  }

  List requesList = [];
  TimerUtil? timer;

  var _options = BaseOptions(
    connectTimeout: _connectTimeout,
    receiveTimeout: _receiveTimeout,
    sendTimeout: _sendTimeout,
    responseType: ResponseType.json,
  );

  RequestMethod.init() {
    // 初始化
    _dio = Dio(_options);
    _dio!.interceptors.add(LogsInterceptors()); //添加日志拦截器
    if (!Constant.inProduction) {
      _setupPROXY(_dio!); //添加转发代理
    }
  }

  //避免获取交易记录时网站有请求速率限制
  void requestNetwork<T>(
    Method method,
    String url,
    complationBlock complationBlock, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    String m = RequestMethod._getRequestMethod(method);

    HWRequestOptions options = HWRequestOptions();
    options.baseUrl = url;
    options.method = m;
    options.data = data;
    options.queryParameters = queryParameters;
    options.back = complationBlock;
    requesList.add(options);

    if (timer == null) {
      timer = TimerUtil(mInterval: 100);
      timer!.setOnTimerTickCallback((millisUntilFinished) async {
        if (requesList.length > 0) {
          HWRequestOptions op = requesList.first;
          requesList.removeAt(0);
          CancelToken cancelToken = RequestMethod._getCancelToken(op.baseUrl);
          Options option = Options();
          option.method = op.method;
          var result;

          try {
            // Completer completer = Completer();
            // Future future = completer.future;
            Response response = await _dio!.request(op.baseUrl!,
                data: op.data,
                queryParameters: op.queryParameters,
                options: option,
                cancelToken: cancelToken);
            result = response.data;
            if (response.statusCode == 200) {
              // LogUtil.v("完整地址 " + response.request.uri.toString());
              if (op.back != null) {
                op.back!(result, 200);
              }
            } else {
              throw Exception('statusCode:${response.statusCode}');
            }
          } on DioError catch (e) {
            LogUtil.v('请求出错：' + e.toString());
            // LogUtil.v("完整地址 " + e.request.uri.toString());
            if (op.back != null) {
              op.back!(e.toString(), 500);
            }
          }
        } else {
          timer!.cancel();
        }
      });
    }
    if (timer!.isActive() == false) {
      timer!.startTimer();
    }
  }

  Future<dynamic> futureRequestData<T>(
    Method method,
    String url,
    complationBlock? complationBlock, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    String m = RequestMethod._getRequestMethod(method);
    CancelToken cancelToken = RequestMethod._getCancelToken(url);
    Options option = Options();
    option.method = m;
    dynamic result;
    try {
      Response response = await _dio!.request(url,
          data: data,
          queryParameters: queryParameters,
          options: option,
          cancelToken: cancelToken);
      result = response.data;
      if (response.statusCode == 200) {
        // LogUtil.v("完整地址 " + response.request.uri.toString());
        if (complationBlock != null) {
          complationBlock(result, 200);
        }
        return result;
      } else {
        throw Exception('statusCode:${response.statusCode}');
      }
    } on DioError catch (e) {
      LogUtil.v('请求出错：' + e.toString());
      // LogUtil.v("完整地址 " + e.request.uri.toString());
      if (complationBlock != null) {
        complationBlock(null, 500);
      }
      return null;
    }
  }

  Future download<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    ProgressCallback? progress,
    String? savePath,
  }) async {
    CancelToken cancelToken = RequestMethod._getCancelToken(url);
    Response response;
    try {
      response = await _dio!.download(
        url,
        savePath,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: progress,
      );
      if (response.statusCode == 200) {
        // LogUtil.v("完整地址 " + response.request.uri.toString());
        return Future.value(response.data);
      } else {
        throw Exception('statusCode:${response.statusCode}');
      }
    } on DioError catch (e) {
      LogUtil.v('请求出错：' + e.toString());
      // LogUtil.v("完整地址 " + e.request.uri.toString());
    }
  }

  //配置取消token
  static CancelToken _getCancelToken(String? url) {
    CancelToken cancelToken = CancelToken(); //自管理取消码
    _cancelTMap["url"] = cancelToken;
    return cancelToken;
  }

  //取消请求
  static cancelRequest(String url) {
    CancelToken? cancelToken = _cancelTMap[url];
    if (cancelToken != null && cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  //获得请求方法
  static String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.GET:
        m = 'get';
        break;
      case Method.POST:
        m = 'post';
        break;
      default:
        m = 'post';
        break;
    }
    return m;
  }

  //添加代理转发
  _setupPROXY(Dio dio) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        return "PROXY 192.168.0.103:8888";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }
}
