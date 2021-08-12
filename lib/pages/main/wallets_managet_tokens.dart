import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter_coinid/models/assets/currency_list.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/public.dart';

class WalletsTokensPage extends StatefulWidget {
  final Function() back;
  const WalletsTokensPage({Key? key, required this.back}) : super(key: key);

  @override
  _WalletsTokensPageState createState() => _WalletsTokensPageState();
}

class _WalletsTokensPageState extends State<WalletsTokensPage> {
  List<MCollectionTokens> allDatas = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  initData() async {
    List<MCollectionTokens> datas =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .collectionTokens;
    setState(() {
      allDatas = datas;
    });
  }

  void _cellContentSelectRowAt(int index) async {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateTokenChoose(index);
    Navigator.pop(context);
    widget.back();
  }

  void sheetClose() {
    Navigator.pop(context);
  }

  Widget _itemBuilder(int index) {
    MCollectionTokens params = allDatas[index];
    String token = params.token ?? "";
    String balance =
        StringUtil.dataFormat(params.balance ?? 0.0, params.digits!);
    String currencySymbolStr =
        Provider.of<CurrentChooseWalletState>(context).currencySymbolStr;
    String assets = "≈$currencySymbolStr" + params.assets;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _cellContentSelectRowAt(index),
      },
      child: Container(
        alignment: Alignment.center,
        height: OffsetWidget.setSc(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_eth.png",
              color: ColorUtils.rgba(108, 139, 252, 1),
              width: 15,
              height: 24,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 5,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorUtils.rgba(255, 255, 255, 0.08),
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    right: OffsetWidget.setSc(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        token,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: OffsetWidget.setSp(14),
                            fontWeight: FontWeight.w400),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            balance,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: OffsetWidget.setSp(14),
                                fontWeight: FontWeight.w400),
                          ),
                          OffsetWidget.hGap(6),
                          Text(
                            assets,
                            style: TextStyle(
                                color: ColorUtils.rgba(171, 171, 171, 1),
                                fontSize: OffsetWidget.setSp(10),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return Container(
      height: OffsetWidget.setSc(600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorUtils.rgba(38, 36, 73, 1),
      ),
      padding: EdgeInsets.only(left: OffsetWidget.setSc(30)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(17), bottom: OffsetWidget.setSc(54)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "".local(),
                ),
                Text(
                  "wallet_Selecttoken".local(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: OffsetWidget.setSp(16),
                      fontWeight: FontWeight.w400),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => {sheetClose()},
                  child: LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_close.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: allDatas.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemBuilder(index);
            },
          )),
        ],
      ),
    );
  }
}
