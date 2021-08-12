import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_coinid/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import '../public.dart';

class ChannelScan {
  static const MethodChannel _channel =
      const MethodChannel(Constant.CHANNEL_Scans);

  static Future<String?> scan() async {
    if (await PermissionUtils.checkCamera() == true) {
      String? result = await _channel.invokeMethod('scan');
      result = result?.replaceAll("ethereum:", "");
      result ??= "";
      return result;
    }
    return "";
  }
}
