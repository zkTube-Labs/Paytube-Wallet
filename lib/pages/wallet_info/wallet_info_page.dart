import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/states/provider_setup.dart';
import 'package:flutter_coinid/utils/instruction_data_format.dart';
import 'package:flutter_coinid/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

import '../../public.dart';

class WalletInfoPage extends StatefulWidget {
  WalletInfoPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _WalletInfoPageState createState() => _WalletInfoPageState();
}

class _WalletInfoPageState extends State<WalletInfoPage> {
  final List<String> _iconList = [
    'Edit_duotone.png',
    'Info.png',
    'Export.png',
    'Upload.png',
    'Cancel.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _modifyDescName() {
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    Map<String, dynamic> params = HashMap();
    params["walletID"] = mwallet.walletID;
    Routers.push(
      context,
      Routers.walletUpdateNamePage,
      params: params,
    );
  }

  void _modifyPinTip() {
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    Map<String, dynamic> params = HashMap();
    params["walletID"] = mwallet.walletID;
    Routers.push(
      context,
      Routers.walletUpdateTipsPage,
      params: params,
    );
  }

  //删除钱包
  void _deleteWallet() async {
    ShowCustomAlert.showCustomAlertType(context,
        alertType: AlertType.text,
        title: "exit_status_tips1".local(),
        subtitleText: "exit_status_tips2".local(),
        rightButtonColor: Colors.white, confirmPressed: (map) async {
      MHWallet mwallet =
          Provider.of<CurrentChooseWalletState>(context, listen: false)
              .currentWallet!;
      bool flag = await MHWallet.deleteWallet(mwallet);
      if (flag) {
        MHWallet? wallet = await MHWallet.findChooseWallet();
        if (wallet == null) {
          List<MHWallet> wallets = await MHWallet.findAllWallets();
          if (wallets.length > 0) {
            wallet = wallets.first;
            wallet.isChoose = true;
            Provider.of<CurrentChooseWalletState>(context, listen: false)
                .updateChoose(wallet);
            HWToast.showText(text: "wallet_delwallet".local());
            Routers.goBackWithParams(context, {});
          } else {
            HWToast.showText(text: "wallet_delwallet".local());
            Routers.push(context, Routers.chooseTypePage, clearStack: true);
          }
        }
      }
    });
  }

  //导出私钥
  void _exportWalletPrv() {
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    Map<String, dynamic> params = HashMap();

    ShowCustomAlert.showCustomAlertType(context,
        alertType: AlertType.password,
        title: "dialog_pwd".local(),
        rightButtonColor: ColorUtils.fromHex("#FD5852"),
        confirmPressed: (map) async {
      String? prv = await mwallet.exportPrv(pin: map['text']!);
      params["exportType"] = 0;
      params["content"] = prv;
      Routers.push(context, Routers.walletExportPrikeyKeystorePage,
          params: params);
    });
  }

  void _exportWalletKeyStore() {
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    Map<String, dynamic> params = HashMap();
    ShowCustomAlert.showCustomAlertType(context,
        alertType: AlertType.password,
        title: "dialog_pwd".local(),
        rightButtonColor: ColorUtils.fromHex("#FD5852"),
        confirmPressed: (map) async {
      String? keyStore = await mwallet.exportKeystore(pin: map['text']!);
      params["exportType"] = 1;
      params["content"] = keyStore;
      Routers.push(context, Routers.walletExportPrikeyKeystorePage,
          params: params);
    });
  }

  Widget getCellWidget(
      {required String leftName, required int iconIndex, Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          right: OffsetWidget.setSc(16),
        ),
        margin: EdgeInsets.only(
          top: OffsetWidget.setSc(12),
          left: OffsetWidget.setSc(16),
          right: OffsetWidget.setSc(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorUtils.rgba(73, 73, 73, 0.29),
        ),
        height: OffsetWidget.setSc(45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(6),
                  child: LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/" + _iconList[iconIndex],
                    width: OffsetWidget.setSc(24),
                    height: OffsetWidget.setSc(24),
                  ),
                ),
                Text(
                  leftName,
                  style: TextStyle(
                    color: ColorUtils.rgba(255, 255, 255, 1),
                    fontWeight: FontWightHelper.regular,
                    fontSize: OffsetWidget.setSp(14),
                  ),
                ),
              ],
            ),
            LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/arrow_dian_whiteright.png",
              width: 6,
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet!;
    String? descName = mwallet.descName;
    descName ??= "";
    String? address = mwallet.walletAaddress;
    address ??= "";
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(
        titleStr: "wallet_management".local(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo
          //eth -ddd
          //地址 copy
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(
                top: OffsetWidget.setSc(30),
                right: OffsetWidget.setSc(15),
                left: OffsetWidget.setSc(15)),
            child: LoadAssetsImage(
              Constant.ASSETS_IMG + "currencyIcon/icon_ETH.png",
              width: 32,
              height: 32,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: OffsetWidget.setSc(9)),
            child: Text(
              "ETHL1/" + descName,
              style: TextStyle(
                color: Colors.white,
                fontSize: OffsetWidget.setSp(16),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (address!.isValid() == false) return;
              Clipboard.setData(ClipboardData(text: address));
              HWToast.showText(text: "copy_success".local());
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: OffsetWidget.setSc(5),
                  right: OffsetWidget.setSc(15),
                  left: OffsetWidget.setSc(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: OffsetWidget.setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OffsetWidget.hGap(4),
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_whitecopy.png",
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
          OffsetWidget.vGap(33),
          getCellWidget(
            leftName: "wallet_update_name".local(),
            iconIndex: 0,
            onTap: () {
              _modifyDescName();
            },
          ),
          getCellWidget(
            leftName: "wallet_pwd_tips".local(),
            iconIndex: 1,
            onTap: () {
              _modifyPinTip();
            },
          ),
          getCellWidget(
            leftName: "export_prv".local(),
            iconIndex: 2,
            onTap: () {
              _exportWalletPrv();
            },
          ),
          getCellWidget(
            leftName: "export_keystore".local(),
            iconIndex: 3,
            onTap: () {
              _exportWalletKeyStore();
            },
          ),
          getCellWidget(
            leftName: "wallet_del".local(),
            iconIndex: 4,
            onTap: () {
              _deleteWallet();
            },
          ),
        ],
      ),
    );
  }
}
