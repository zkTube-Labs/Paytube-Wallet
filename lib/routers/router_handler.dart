//空视图
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coinid/pages/application/application_search.dart';
import 'package:flutter_coinid/pages/choose/choose_type_page.dart';
import 'package:flutter_coinid/pages/create/creatememo/backup_memovalues_page.dart';
import 'package:flutter_coinid/pages/create/creatememo/create_page.dart';
import 'package:flutter_coinid/pages/create/creatememo/verify_memovalues_page.dart';
import 'package:flutter_coinid/pages/guide/guide_page.dart';
import 'package:flutter_coinid/pages/create/import/import_page.dart';
import 'package:flutter_coinid/pages/main/add_assets_page.dart';
import 'package:flutter_coinid/pages/main/payment_page.dart';
import 'package:flutter_coinid/pages/main/receive_payment_page.dart';
import 'package:flutter_coinid/pages/main/transdetail_page.dart';
import 'package:flutter_coinid/pages/main/translist_page.dart';
import 'package:flutter_coinid/pages/main/wallet_manager_page.dart';
import 'package:flutter_coinid/pages/mine/about_us_page.dart';
import 'package:flutter_coinid/pages/mine/mine_addcontact_page.dart';
import 'package:flutter_coinid/pages/mine/mine_contact_page.dart';
import 'package:flutter_coinid/pages/mine/modifiy_set_page.dart';
import 'package:flutter_coinid/pages/mine/msg_system_detail_page.dart';
import 'package:flutter_coinid/pages/mine/node_add_page.dart';
import 'package:flutter_coinid/pages/mine/nodelist_page.dart';
import 'package:flutter_coinid/pages/mine/mymsg_page.dart';
import 'package:flutter_coinid/pages/mine/system_set_page.dart';
import 'package:flutter_coinid/pages/mine/version_log_page.dart';
import 'package:flutter_coinid/pages/pdf_screen.dart';
import 'package:flutter_coinid/pages/create/restore/restore_page.dart';
import 'package:flutter_coinid/pages/tabbar/tabbar_page.dart';
import 'package:flutter_coinid/pages/wallet_info/wallet_export_prvkey_keystore_page.dart';
import 'package:flutter_coinid/pages/wallet_info/wallet_info_page.dart';
import 'package:flutter_coinid/pages/wallet_info/wallet_show_pubkey_page.dart';
import 'package:flutter_coinid/pages/wallet_info/wallet_update_name_page.dart';
import 'package:flutter_coinid/pages/wallet_info/wallet_update_tips_page.dart';
import 'package:flutter_coinid/utils/log_util.dart';
import 'package:flutter_coinid/widgets/custom_pageview.dart';

var emptyHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return CustomPageView(
    child: Center(
      child: Text("page not found"),
    ),
  );
});

//欢迎页面
var guidePageHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return GuidePage();
});

//选择类型
var chooseTypeHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  print(params);
  bool isHideBack = true;
  if (params.length > 0) {
    isHideBack = params['isHideBack']?[0] == 'true' ? true : false;
  }
  return ChooseTypePage(isHideBack: isHideBack);
});

//选择创建钱包类型
// var chooseCreateTypeHandler = new Handler(
//     handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//   return ChooseCreateTypePage();
// });

//创建
var createTypeHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return CreatePage();
});

//恢复钱包
var restoreHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return RestorePage();
});

// var chooseCountHandler =
//     Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//   LogUtil.v("ChooseCountPage接收的参数+$params");
//   return ChooseCountPage(
//     params: params,
//   );
// });

var backMemoValuesHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("BackupMemoPage接收的参数+$params");
  return BackupMemoPage(
    params: params,
  );
});

var verifyMemoHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("VerifyMemoPage接收的参数+$params");
  return VerifyMemoPage(
    params: params,
  );
});

var importHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ImportPage接收的参数+$params");
  return ImportPage(
    params: params,
  );
});

var walletManagerHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return WalletManagerPage(
      // params: params,
      );
});

var modifiySetPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return ModifiySetPage(
    setType: int.parse(params["settype"][0]),
  );
});

var transListPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return TransListPage(params: params);
});

var transDetailPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("transDetailPage" + "接收的参数+$params");
  return TransDetailPage(
    params: params,
  );
});

var tabbarPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return TabbarPage();
});

var walletInfoPagePageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return WalletInfoPage(params: params);
});

var walletUpdateNamePageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return WalletUpdateNamePage(params: params);
});

var walletUpdateTipsPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return WalletUpdateTipsPage(params: params);
});

var walletShowPubKeyPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return WalletShowPubKeyPage(params: params);
});

var walletExportPrikeyKeystorePageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return WalletExportPrikeyKeystorePage(params: params);
});

var addAssetsPagePageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("ModifiySetPage" + "接收的参数+$params");
  return AddAssetsPage(params: params);
});

var paymentPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  LogUtil.v("PaymentPage" + "接收的参数+$params");
  return PaymentPage(params: params);
});

var recervePaymentPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return RecervePaymentPage(params: params);
});

var pdfScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  String? pathPDF = params["path"][0];
  return PDFScreen(
    pathPDF: pathPDF,
  );
});

var assetsListPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return PDFScreen(
      // params: params,
      );
});

var systemSetPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return SystemSetPage();
});

var nodeListPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return NodeListPage();
});

var aboutUsPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return AboutUsPage();
});

var versionLogPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return VersionLogPage();
});

var msgSystemDetailPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return MsgSystemDetailPage(params: params);
});

var mineContactHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  String state = "";
  if (params.length > 0) {
    state = params["state"][0];
  }
  return MineContact(state: state);
});

var nodeAddPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return NodeAddPage(params: params);
});

var systemPageHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return MyMsgPage();
  // return MsgTransPage();
});

var appListSearchHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  String type = params['type']?[0];

  return ApplicationSearch(type: type);
});

var mineAddContactHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return MineAddContact();
});
