import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/constant/constant.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/upgrade/app_upgrade.dart';
import 'package:flutter_coinid/upgrade/download_status.dart';
import 'package:flutter_coinid/upgrade/flutter_upgrade.dart';

import '../public.dart';

class VerSionUpgradeUtil {
  static String? _imei = "";
  static AppInfo _appInfo = AppInfo(versionName: "");
  static Map<String, dynamic>? updateMap = Map();

  static void getAppInfo(BuildContext context) async {
    _appInfo = await FlutterUpgrade.appInfo;
    _imei = await ChannelWallet.deviceImei();
    _getUpdateInfo(context);
  }

  static void _getUpdateInfo(BuildContext context) {
    String appType = "android";
    if (Constant.isAndroid) {
      appType = "android";
    } else if (Constant.isIOS) {
      appType = "ios";
    }
  }

  static void _showUpdateDialog(BuildContext context) {
    AppUpgrade.appUpgrade(
      context,
      _checkAppInfo(),
      iosAppId: '1524891382',
      onCancel: () {},
      onOk: () {},
      downloadProgress: (count, total) {},
      downloadStatusChange: (DownloadStatus status, {dynamic error}) {},
    );
  }

  static Future<AppUpgradeInfo> _checkAppInfo() async {
    return AppUpgradeInfo(
      title: "新版本" + updateMap!["version"],
      contents: [
        updateMap!["description"],
      ],
      force: updateMap!["alwaysUpdate"],
      gotoWeb: true,
      apkDownloadUrl: updateMap!["downloadURl"],
    );
  }
}
