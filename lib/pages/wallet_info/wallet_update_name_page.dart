import 'package:flutter_coinid/models/wallet/mh_wallet.dart';

import '../../public.dart';

class WalletUpdateNamePage extends StatefulWidget {
  WalletUpdateNamePage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _WalletUpdateNamePageState createState() => _WalletUpdateNamePageState();
}

class _WalletUpdateNamePageState extends State<WalletUpdateNamePage> {
  TextEditingController nameEC = TextEditingController();
  String? walletID, chain = "", walletName = "Wallet";
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
        chain = Constant.getChainSymbol(wallet.chainType) + " -";
        if (wallet.descName != null && wallet.descName!.length > 0) {
          walletName = wallet.descName;
        }
        setState(() {
          mwallet = wallet;
        });
      }
    }
  }

  _updateWalletName(String name) {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateWalletDescName(name);
    Routers.goBackWithParams(context, {"name": name});
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      hiddenResizeToAvoidBottomInset: false,
      hiddenScrollView: true,
      title: CustomPageView.getDefaultTitle(
        titleStr: "wallet_update_name_title".local(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextField(
            controller: nameEC,
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            style: TextStyle(
              color: ColorUtils.rgba(153, 153, 153, 1),
              fontSize: OffsetWidget.setSp(16),
              fontWeight: FontWightHelper.regular,
            ),
            maxLength: 12,
            decoration: CustomTextField.getBorderLineDecoration(
              counterText: "",
              hintText: "wallet_input_name_hit_err".local(),
              hintStyle: TextStyle(
                color: ColorUtils.rgba(153, 153, 153, 1),
                fontSize: OffsetWidget.setSp(12),
                fontWeight: FontWightHelper.regular,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _updateWalletName(nameEC.text);
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
      ),
    );
  }
}
