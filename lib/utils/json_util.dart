import 'dart:convert';

import 'package:flutter/foundation.dart';

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Date Util.
 * @Date: 2020/01/06
 */

/// Json Util.
class JsonUtil {
  /// Converts object [value] to a JSON string.
  static String? encodeObj(Object value) {
    return value == null ? null : json.encode(value);
  }

  /// Converts JSON string [source] to object.
  static Map? getObj<T>(String? source) {
    if (source == null || source.isEmpty) return null;
    try {
      Map? map = json.decode(source);
      // return  compute(json.decode,source);
      return map == null ? null : map;
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }

  /// Converts JSON string list [source] to object list.
  static List<T>? getObjList<T>(String source) {
    if (source == null || source.isEmpty) return null;
    try {
      List? list = json.decode(source);
      return list?.map((value) {
        return value;
      }).toList() as List<T>?;
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }
}
