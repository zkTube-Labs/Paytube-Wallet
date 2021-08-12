import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../public.dart';

class RecervePaymentPage extends StatefulWidget {
  RecervePaymentPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _RecervePaymentPageState createState() => _RecervePaymentPageState();
}

class _RecervePaymentPageState extends State<RecervePaymentPage> {
  String? qrCodeStr = "";
  String? walletAddress = "";
  String? contractAddressStr = "";
  String? token;
  String? decimalStr;
  int? chainType;
  int? onlyAddress = 1; //1: 只包含地址信息

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MHWallet? wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    if (wallet != null) {
      walletAddress = wallet.walletAaddress;
      chainType = wallet.chainType;
      if (widget.params!.containsKey("contract")) {
        contractAddressStr = widget.params!["contract"][0];
      }
      if (widget.params!.containsKey("token")) {
        token = widget.params!["token"][0];
      }
      if (widget.params!.containsKey("decimals")) {
        decimalStr = widget.params!["decimals"][0];
      }
      if (widget.params!.containsKey("onlyAddress")) {
        onlyAddress = int.tryParse(widget.params!["onlyAddress"][0]);
      }
      buildRecerveStr();
    }
  }

  void buildRecerveStr() async {
    String? value = "";
    if (onlyAddress == 1) {
      if (chainType == MCoinType.MCoinType_ETH.index) {
        String? eip55add = await (ChannelNative.cvtAddrByEIP55(
            walletAddress!.replaceAll("0x", "")));
        eip55add ??= "";
        value = "0x" + eip55add;
      } else {
        value = walletAddress;
      }
    } else {
      if (chainType == MCoinType.MCoinType_ETH.index) {
        if ("ETH" == token) {
          //例 ethereum:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b&decimal=18&value=0
          String? eip55add = await (ChannelNative.cvtAddrByEIP55(
              walletAddress!.replaceAll("0x", "")));
          eip55add ??= "";
          value = "ethereum:" + "0x" + eip55add + "&decimal=18" + "&value=0";
        } else {
          String? eip55add = await (ChannelNative.cvtAddrByEIP55(
              walletAddress!.replaceAll("0x", "")));
          eip55add ??= "";
          //例 ethereum:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b?contractAddress=0x0f8c45b896784a1e408526b9300519ef8660209c&decimal=8&value=0&token=xmx
          value = "ethereum:" +
              "0x" +
              eip55add +
              "?contractAddress=" +
              contractAddressStr! +
              "&decimal=" +
              decimalStr! +
              "&value=0" +
              "&token=" +
              token!;
        }
      }
    }

    setState(() {
      qrCodeStr = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      color: ColorUtils.rgba(12, 12, 48, 1),
      alignment: Alignment.center,
      width: OffsetWidget.setSc(45),
      height: OffsetWidget.setSc(45),
      child: LoadAssetsImage(
        Constant.ASSETS_IMG + "icon/icon_whitecopy.png",
        width: 13,
        height: 13,
      ),
    );
    return CustomPageView(
      hiddenScrollView: true,
      title: CustomPageView.getDefaultTitle(
        titleStr: "receive_payment".local(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(
              top: OffsetWidget.setSc(50),
            ),
            child: LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_eth.png",
              width: 32,
              height: 32,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: OffsetWidget.setSc(13)),
            child: Text(
              token??"ETH",
              style: TextStyle(
                color: Colors.white,
                fontSize: OffsetWidget.setSp(16),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: OffsetWidget.setSc(12),
            ),
            child: QrImage(
              data: qrCodeStr!,
              size: OffsetWidget.setSc(166),
              backgroundColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (walletAddress!.isValid() == false) return;
              Clipboard.setData(ClipboardData(text: walletAddress));
              HWToast.showText(text: "copy_success".local());
            },
            child: Container(
              padding: EdgeInsets.only(
                left: OffsetWidget.setSc(5),
              ),
              margin: EdgeInsets.only(
                top: OffsetWidget.setSc(35),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorUtils.rgba(73, 73, 73, 0.29),
              ),
              alignment: Alignment.center,
              height: OffsetWidget.setSc(45),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      walletAddress ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: OffsetWidget.setSp(14),
                        fontWeight: FontWightHelper.regular,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  container
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
