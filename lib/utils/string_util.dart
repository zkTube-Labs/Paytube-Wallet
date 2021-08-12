import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public.dart' as ez;
import 'package:flutter_coinid/public.dart';

class StringUtil {
  static int compare(String str1, String str2) {
    final minCount = min(str1.length, str2.length);
    for (var i = 0; i < minCount; i++) {
      final l1 = str1.codeUnitAt(i);
      final l2 = str2.codeUnitAt(i);
      if (l1 > l2) {
        return 1;
      } else if (l1 < l2) {
        return -1;
      } else {
        continue;
      }
    }
    if (str1.length > str2.length) {
      return 1;
    } else if (str1.length < str2.length) {
      return -1;
    } else {
      return 0;
    }
  }

  static bool isNotEmpty(String? string) {
    if (string != null && string.length > 0 && string != "null") {
      return true;
    } else {
      return false;
    }
  }

  static bool eosAccountAvailable(String acccount) {
    String regStr = "^[1-5a-z]{12}\$";
    RegExp reg = new RegExp(regStr);
    return reg.hasMatch(acccount);
  }

  //是否是可用IP
  static bool isValidIp(String ip) {
    String regStr =
        "^((2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\$";
    RegExp reg = new RegExp(regStr);
    return reg.hasMatch(ip);
  }

  //是否是可用IP和端口
  static bool isValidIpAndPort(String ip) {
    String regStr =
        "^((2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\\:([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-6][0-5][0-5][0-3][0-5])\$";
    RegExp reg = new RegExp(regStr);
    return reg.hasMatch(ip);
  }

  //是否是可用域名
  static bool isValidUrl(String ip) {
    String regStr =
        "^([hH][tT]{2}[pP]:\\/\\/|[hH][tT]{2}[pP][sS]:\\/\\/|www\\.)(([A-Za-z0-9-~]+)\\.)+([A-Za-z0-9-~\\/])+\$";
    RegExp reg = new RegExp(regStr);
    return reg.hasMatch(ip);
  }

  static String dataFormat(double number, int decimalPlaces) {
    var result = number.toStringAsFixed(decimalPlaces + 1);
    String subStr =
        result.substring(0, result.indexOf(".") + decimalPlaces + 1);
    if (decimalPlaces == 0) {
      subStr = subStr.replaceAll(".", "");
    }
    return subStr;
  }
}

extension StringTranslateExtension on String {
  /// {@macro tr}
  String local(
          {BuildContext? context,
          List<String>? args,
          Map<String, String>? namedArgs,
          String? gender}) =>
      ez.tr(this, args: args, namedArgs: namedArgs, gender: gender);

  /// {@macro plural}
  String plural(num value, {NumberFormat? format}) =>
      ez.plural(this, value, format: format);

  bool checkPassword() {
    return true;
    //密码长度8位数以上，建议使用英文字母、数字和标点符号组成，不采用特殊字符。
    if (this.length < 8) {
      return false;
    }
    String symbols = "\\s\\p{P}\n\r=+\$￥<>^`~|,./;'!@#^&*()_+"; //符号Unicode 编码
    String zcCharNumber = "^(?![$symbols]+\$)[a-zA-Z\\d$symbols]+\$";
    try {
      RegExp reg = RegExp(zcCharNumber);
      return reg.hasMatch(this);
    } catch (e) {
      LogUtil.v("checkPassword $e");
      return false;
    }
  }

  bool checkPrv(MCoinType? mCoinType) {
    int len = 0;
    switch (mCoinType) {
      case MCoinType.MCoinType_ETH:
        len = 64;
        break;
      default:
    }
    String regex = "^[0-9A-Fa-f]{$len}\$";
    try {
      RegExp reg = RegExp(regex);
      print("checkPrv $this hasMatch${reg.hasMatch(this)} regex $regex");
      return reg.hasMatch(this);
    } catch (e) {
      LogUtil.v("checkPassword $e");
      return false;
    }
  }

  bool checkAmount(int decimals) {
    String amount = '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$';
    RegExp reg = RegExp(amount);
    return reg.hasMatch(this);
  }

  bool isValid() {
    return StringUtil.isNotEmpty(this);
  }
}

extension TenthousandToYuan on double {
  String tenthousandToYuan() {
    if (this < 1000) {
      return this.toString();
    }
    if (this > 100000000) {
      double bd = this / 100000000;
      String price = bd.toString();
      if (price.length >= 8) {
        price = price.substring(0, 7);
      }
      return price + "亿";
    } else if (this > 10000) {
      double bd = this / 10000;
      String price = bd.toString();
      if (price.length >= 6) {
        price = price.substring(0, 5);
      }
      return price + "万";
    } else {
      double bd = this / 1000;
      String price = bd.toString();
      if (price.length >= 6) {
        price = price.substring(0, 5);
      }
      return price + "千";
    }
  }
}
