import 'package:fluro/fluro.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/routers/app_routers.dart';
import 'package:flutter_coinid/routers/router_handler.dart';

class Routers {
  static String guidePage = '/guidepage';
  static String chooseTypePage = '/choosetypepage';
  static String chooseCreateTypePage = '/ChooseCreateTypePage';
  static String createPage = './createpage';
  static String restorePage = './RestorePage';
  static String chooseCountPage = './choosecountpage';
  static String backupMemosPage = './backupmemospage';
  static String verifyMemoPage = './verifymemospage';
  static String importPage = './importpage';
  static String walletManagerPage = './walletManagerPage';
  static String modifiySetPage = './modifiysetpage';
  static String transListPage = './translistpage';
  static String transDetailPage = './transdetailpage';
  static String tabbarPage = './tabbarPage';
  static String bigBusinessTrackingDetailPage =
      './bigBusinessTrackingDetailPage';
  static String ramDetailPage = './ramDetailPage';
  static String ramTransferPagePage = './ramTransferPagePage';
  static String cpuNetTransferPage = './cpuNetTransferPage';
  static String registerShowKeyPage = './registerShowKeyPage';
  static String registerInputAccoutPage = './registerInputAccoutPage';
  static String registerCreateCodePage = './registerCreateCodePage';
  static String walletInfoPagePage = './walletInfoPagePage';
  static String walletUpdateNamePage = './walletUpdateNamePage';
  static String walletUpdateTipsPage = './walletUpdateTipsPage';
  static String walletShowPubKeyPage = './walletShowPubKeyPage';
  static String walletExportPrikeyKeystorePage =
      './walletExportPrikeyKeystorePage';
  static String addAssetsPagePage = './addAssetsPagePage';
  static String paymentPage = './paymentPage';
  static String recervePaymentPage = './recervePaymentPage';
  static String chooseCoinTypePage = "chooseCoinTypePage";
  static String pdfScreen = "PDFScreen";
  static String assetsListPage = "AssetsListPage";
  static String systemSetPage = "systemSetPage";
  static String nodeListPage = "nodeListPage";
  static String aboutUsPage = "aboutUsPage";
  static String versionLogPage = "versionLogPage";
  static String msgSystemDetailPage = "msgSystemDetailPage";
  static String mineContactPage = "mineContactPage";
  static String nodeAddPage = "nodeAddPage";
  static String currencyMarketInfoPage = "currencyMarketInfoPage";
  static String marketSearchPage = "marketSearchPage";
  static String systemPage = "systemPage";
  static String appListSearch = "appListSearch";
  static String mineAddContact = "mineAddContact";

//配置路由
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = emptyHandler;
    router.define(guidePage, handler: guidePageHandler);
    router.define(chooseTypePage, handler: chooseTypeHandler);
    router.define(createPage, handler: createTypeHandler);
    router.define(restorePage, handler: restoreHandler);
    router.define(backupMemosPage, handler: backMemoValuesHandler);
    router.define(verifyMemoPage, handler: verifyMemoHandler);
    router.define(importPage, handler: importHandler);
    router.define(walletManagerPage, handler: walletManagerHandler);
    router.define(modifiySetPage, handler: modifiySetPageHandler);
    router.define(transListPage, handler: transListPageHandler);
    router.define(transDetailPage, handler: transDetailPageHandler);
    router.define(tabbarPage, handler: tabbarPageHandler);
    router.define(walletInfoPagePage, handler: walletInfoPagePageHandler);
    router.define(walletUpdateNamePage, handler: walletUpdateNamePageHandler);
    router.define(walletUpdateTipsPage, handler: walletUpdateTipsPageHandler);
    router.define(walletShowPubKeyPage, handler: walletShowPubKeyPageHandler);
    router.define(walletExportPrikeyKeystorePage,
        handler: walletExportPrikeyKeystorePageHandler);
    router.define(addAssetsPagePage, handler: addAssetsPagePageHandler);
    router.define(paymentPage, handler: paymentPageHandler);
    router.define(recervePaymentPage, handler: recervePaymentPageHandler);
    router.define(pdfScreen, handler: pdfScreenHandler);
    router.define(assetsListPage, handler: assetsListPageHandler);
    router.define(systemSetPage, handler: systemSetPageHandler);
    router.define(nodeListPage, handler: nodeListPageHandler);
    router.define(aboutUsPage, handler: aboutUsPageHandler);
    router.define(versionLogPage, handler: versionLogPageHandler);
    router.define(msgSystemDetailPage, handler: msgSystemDetailPageHandler);
    router.define(mineContactPage, handler: mineContactHandler);
    router.define(nodeAddPage, handler: nodeAddPageHandler);
    router.define(systemPage, handler: systemPageHandler);
    router.define(appListSearch, handler: appListSearchHandler);
    router.define(mineAddContact, handler: mineAddContactHandler);
  }

  static Future<dynamic> push(BuildContext context, String path,
      {Map<String, dynamic>? params,
      bool replace = false,
      bool clearStack = false}) {
    //构建传输参数
    String query = "";
    if (params != null) {
      query += "?";
      for (var i = 0; i < params.keys.length; i++) {
        String key = params.keys.elementAt(i);
        dynamic value = params[key];
        if (value is String) {
          value = Uri.encodeComponent(value);
          if (i == 0) {
            query += "$key=$value";
          } else {
            query += "&" + "$key=$value";
          }
        } else if (value is List) {
          for (var j = 0; j < value.length; j++) {
            String subVlaue = value.elementAt(j);
            subVlaue = Uri.encodeComponent(subVlaue);
            if (j == 0 && i == 0) {
              query += "$key=$subVlaue";
            } else {
              query += "&" + "$key=$subVlaue";
            }
          }
        } else if (value is Map) {
        } else {
          if (i == 0) {
            query += "$key=$value";
          } else {
            query += "&" + "$key=$value";
          }
        }
      }
    }
    path = path + query;
    LogUtil.v('我是navigateTo传递的参数：$query' + "\n跳转路径path :$path");
    return AppRouters.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  static bool canGoPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// 返回
  static void goBack(BuildContext context, {String? routeName}) {
    unfocus();
    if (canGoPop(context)) {
      AppRouters.router.pop(context);
      // Navigator.popAndPushNamed(context, routeName);
    }
  }

  /// 带参数返回
  static void goBackWithParams(
      BuildContext context, Map<String, dynamic>? result) {
    unfocus();
    AppRouters.router.pop(context, result);
  }

  /// 跳到WebView页
  static void goWebViewPage(BuildContext context, String title, String url) {
    //fluro 不支持传中文,需转换
    // push(context,
    //     '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }

  static void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    // FocusManager.instance.primaryFocus?.unfocus();
  }
}
