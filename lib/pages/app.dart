import 'package:flutter/material.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/pages/choose/choose_type_page.dart';
import 'package:flutter_coinid/pages/guide/guide_page.dart';
import 'package:flutter_coinid/pages/tabbar/tabbar_page.dart';
import 'package:flutter_coinid/upgrade/app_upgrade.dart';
import 'package:flutter_coinid/upgrade/download_status.dart';
import 'package:flutter_coinid/upgrade/flutter_upgrade.dart';
import 'package:flutter_coinid/widgets/custom_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_coinid/public.dart';

class MyApp extends StatefulWidget {
  //launch
  //tabbar
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int state = 0; //0 load  1 skin, 2 create ,3 tabbar

  @override
  void initState() {
    super.initState();
    super.initState();
    getSkip();
    NodeModel.configNodeList();
    Constant.getAppFile().then((value) => {
          LogUtil.v("app file " + value.absolute.path),
        });
  }

  void getSkip() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isSkip = prefs.getBool("skip");
    if (isSkip != null && isSkip) {
      List<MHWallet> wallets = await MHWallet.findAllWallets();
      if (wallets != null && wallets.length > 0) {
        setState(() {
          state = 3;
        });
      } else {
        setState(() {
          state = 2;
        });
      }
    } else {
      setState(() {
        state = 1;
      });
    }
  }

  Widget buildEmptyView() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: CurrentChooseWalletState()),
          ChangeNotifierProvider.value(value: MCreateWalletState()),
          ChangeNotifierProvider.value(value: MNodeState()),
          ChangeNotifierProvider.value(value: MTransListState()),
        ],
        child: CustomApp(
          child: state == 0
              ? buildEmptyView()
              : state == 3
                  ? TabbarPage()
                  : state == 2
                      ? ChooseTypePage()
                      : GuidePage(),
          // child: ApplicationPage(),
        ));
  }
}
