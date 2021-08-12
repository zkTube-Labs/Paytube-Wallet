import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/permission.dart';
import 'package:path_provider/path_provider.dart';

enum MemoCount { MemoCount_12, MemoCount_18, MemoCount_24 }

//导入类型 私钥、keystore 、coinid助记词 、 标准助记词
enum MLeadType {
  MLeadType_Prvkey, //通过私钥
  MLeadType_KeyStore, //通过keystore
  MLeadType_StandardMemo //通过标准助记词
}
//来源类型
enum MOriginType {
  MOriginType_Create, //创建
  MOriginType_Restore, //恢复
  MOriginType_LeadIn, //导入
  MOriginType_Colds, //冷
  MOriginType_NFC, //nfc
  MOriginType_MultiSign, //预留多签
}

enum MCoinType {
  MCoinType_ETH,
}

enum MStatusCode {
  MStatusCode_Success,
  MStatusCode_Failere,
  MStatusCode_BaseFailere,
  MStatusCode_Exist,
  MStatusCode_MemoInvalid,
  MStatusCode_KeystorePwdInvalid,
  MStatusCode_PrvKeyInvalid,
}

enum MQRStatusCode {
  MQRStatusCode_Success, //解析成功
  MQRStatusCode_Type_Err, //链类型错误
  MQRStatusCode_Dispose_Err //解析失败
}

enum MSignType {
  MSignType_Main,
  MSignType_Token,
}

enum MTransListType {
  MTransListType_All,
  MTransListType_Out,
  MTransListType_In,
  MTransListType_Err,
}

enum MTransState {
  MTransState_Failere,
  MTransState_Success,
  MTransState_Pending,
}

enum MNodeNetType {
  MNodeNetType_Main,
  MNodeNetType_Test,
}

enum MURLType { Links, Bancor, VDns, VDai }

enum MButtonState {
  ButtonState_Normal,
  ButtonState_Top,
  ButtonState_Bottom,
}

enum MCurrencyType {
  CNY,
  USD,
}
enum MLanguage {
  zh_hans,
  en,
}

//alert类型
enum AlertType {
  password, //输入密码
  text, //文本提示
  node, //nodeUrl
}

class Constant {
  static const bool inProduction = kReleaseMode;
  static bool isAndroid = Platform.isAndroid;
  static bool isIOS = Platform.isIOS;
  static const String ASSETS_IMG = './assets/images/';
  static const int TextFileld_FocuseCOlor = 0xFFCFCFCF;

  static const String CHANNEL_PATH = 'plugins.coinidwallet';
  static const String CHANNEL_Memos = CHANNEL_PATH + ".memos";
  static const String CHANNEL_Wallets = CHANNEL_PATH + ".wallets";
  static const String CHANNEL_Natives = CHANNEL_PATH + ".natives";
  static const String CHANNEL_Scans = CHANNEL_PATH + ".scans";
  static const String CHANNEL_Dapp = CHANNEL_PATH + ".dapps";

  static const int textfield_border_color = 0xff323755;
  static const int tabbar_select_color = 0xFF494949;
  static const int main_color = 0xff171332; //0xff171332
  static const String hintTextColor = '#585858';
  static const int valueTextColor = 0xffDEE0DF;

  static EventBus eventBus = EventBus();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Future<File> getAppFile() async {
    Directory? documentsDir;
    if (Constant.isAndroid) {
      documentsDir = await getExternalStorageDirectory();
    } else {
      documentsDir = await getApplicationDocumentsDirectory();
    }
    String documentsPath = documentsDir!.absolute.path;
    File file = File('$documentsPath');
    return file;
  }

  static Future<String?> getAgreementPath() async {
    try {
      if (await PermissionUtils.checkStoragePermissions() == false) {
        HWToast.showText(text: "权限未开启");
        return null;
      }
      final filename = "agreementinfo.pdf";
      var filebd = await rootBundle.load("assets/data/agreementinfo.pdf");
      File documentsDir = await getAppFile();
      String documentsPath = documentsDir.absolute.path;
      File file = File('$documentsPath/$filename');
      final buffer = filebd.buffer;
      file.writeAsBytes(
          buffer.asUint8List(filebd.offsetInBytes, filebd.lengthInBytes));
      return file.path;
    } catch (e) {
      LogUtil.v(e);
      return null;
    }
  }

  static String getChainSymbol(int? chainType) {
    String symbol = "";
    if (MCoinType.MCoinType_ETH.index == chainType) {
      symbol = "ETH";
    }
    return symbol;
  }

  static MCoinType? getCoinType(String symbol) {
    MCoinType? coinType;
    if (symbol.toLowerCase() == "eth") {
      coinType = MCoinType.MCoinType_ETH;
    }
    return coinType;
  }

  static String getChainFullName(int? coinType) {
    String fullName = "";
    if (MCoinType.MCoinType_ETH.index == coinType) {
      fullName = "Ethereum";
    }
    return fullName;
  }

  static int? getChainDecimals(int? coinType) {
    int? decimals;
    if (MCoinType.MCoinType_ETH.index == coinType) {
      decimals = 18;
    } else {
      assert(false, "getChainDecimals");
    }
    return decimals;
  }

  static String getChainLogo(int? chainType) {
    String logofile = Constant.ASSETS_IMG + "wallet/logo_";
    logofile = logofile + getChainSymbol(chainType).toLowerCase() + ".png";
    return logofile;
  }
}
