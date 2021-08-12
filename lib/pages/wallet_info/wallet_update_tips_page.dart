import 'package:flutter_coinid/models/wallet/mh_wallet.dart';

import '../../public.dart';

class WalletUpdateTipsPage extends StatefulWidget {
  WalletUpdateTipsPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _WalletUpdateTipsPageState createState() => _WalletUpdateTipsPageState();
}

class _WalletUpdateTipsPageState extends State<WalletUpdateTipsPage> {
  bool obscureText = true;
  TextEditingController tipsEC = TextEditingController();
  String? walletID;
  String hitTip = "";
  MHWallet? mwallet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _findWalletByWalletID();
  }

  _findWalletByWalletID() async {
    if (widget.params != null) {
      walletID = widget.params!["walletID"][0];
      MHWallet? wallet = await MHWallet.findWalletByWalletID(walletID!);
      if (wallet != null) {
        setState(() {
          tipsEC.text = wallet.pinTip!;
          mwallet = wallet;
        });
      }
    }
  }

  _updateWalletTip(String tip) async {
    mwallet!.pinTip = tip;
    bool flag = await MHWallet.updateWallet(mwallet!);
    if (flag) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
        hiddenResizeToAvoidBottomInset: false,
        hiddenScrollView: true,
        title: CustomPageView.getDefaultTitle(
          titleStr: "wallet_update_tip_title".local(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              controller: tipsEC,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              style: TextStyle(
                color: ColorUtils.rgba(153, 153, 153, 1),
                fontSize: OffsetWidget.setSp(12),
                fontWeight: FontWightHelper.regular,
              ),
              decoration: CustomTextField.getBorderLineDecoration(),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _updateWalletTip(tipsEC.text);
              },
              child: Container(
                height: OffsetWidget.setSc(46),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    bottom: OffsetWidget.setSc(81),
                    left: OffsetWidget.setSc(36),
                    right: OffsetWidget.setSc(36)),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(78, 108, 220, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "wallet_complete".local(),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(20),
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
