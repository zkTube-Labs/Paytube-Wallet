import 'package:flutter_coinid/utils/date_util.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/log_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LANGUAGE_SET = "LANGUAGE_SET";
const String AMOUNT_SET = "AMOUNT_SET";
const String Assets_updateTime = "Assets_updateTime";
const String Assets_OriginAssets = "Assets_OriginAssets";
const String FIRST_INSTALL = "FIRST_INSTALL";

void updateLanguageValue(int value) async {
  final fres = await SharedPreferences.getInstance();
  fres.setInt(LANGUAGE_SET, value);
}

Future<int> getLanguageValue() async {
  final prefs = await SharedPreferences.getInstance();
  int? object = prefs.getInt(LANGUAGE_SET);
  object ??= 0;
  return Future.value(object);
}

///默认cny
void updateAmountValue(bool isCNY) async {
  final fres = await SharedPreferences.getInstance();
  fres.setInt(AMOUNT_SET, isCNY == true ? 0 : 1);
  LogUtil.v("updateAmountValue " + isCNY.toString());
}

///0 cny 1 en
Future<int> getAmountValue() async {
  final prefs = await SharedPreferences.getInstance();
  int? object = prefs.getInt(AMOUNT_SET);
  object ??= 0;
  if (object == 0) {
    return 0;
  }
  return 1;
}

void saveOriginMoney(String cnyAssets, String usdAssets) async {}

Future<String?> getOriginMoney(bool isCny) async {
  final prefs = await SharedPreferences.getInstance();
  String? origin = prefs.getString(Assets_OriginAssets);
  Map? params = JsonUtil.getObj(origin);
  params ??= {"cnyAssets": "0", "usdAssets": "0"};
  return isCny == true ? params["cnyAssets"] : params["usdAssets"];
}

Future<bool> isFirstInstall() async {
  final fres = await SharedPreferences.getInstance();
  bool? status = fres.getBool(FIRST_INSTALL);
  return status == true ? false : true;
}

void updateFirstInstall() async {
  final fres = await SharedPreferences.getInstance();
  fres.setBool(FIRST_INSTALL, true);
}
