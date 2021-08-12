import 'package:flutter_coinid/models/wallet/mh_wallet.dart';

import '../../public.dart';

class WalletsMangerList extends StatefulWidget {
  WalletsMangerList({Key? key}) : super(key: key);

  @override
  _WalletsMangerListState createState() => _WalletsMangerListState();
}

class _WalletsMangerListState extends State<WalletsMangerList> {
  List<MHWallet> datas = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    datas = await MHWallet.findAllWallets();
    setState(() {});
  }

  void _cellContentSelectRowAt(MHWallet wallet) async {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateChoose(wallet);

    Navigator.pop(context);
  }

  void sheetClose() {
    Navigator.pop(context);
  }

  Widget _itemBuilder(int index) {
    MHWallet model = datas[index];
    String name = model.descName ?? "";
    name = "ETHL1/" + name;
    String address = model.walletAaddress ?? "";

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _cellContentSelectRowAt(model),
      },
      child: Container(
        alignment: Alignment.center,
        height: OffsetWidget.setSc(80),
        decoration: BoxDecoration(
          color: Color(Constant.main_color),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.only(
          left: OffsetWidget.setSc(15),
          right: OffsetWidget.setSc(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoadAssetsImage(
                  Constant.ASSETS_IMG + "icon/icon_eth.png",
                  color: ColorUtils.rgba(108, 139, 252, 1),
                  width: 15,
                  height: 24,
                ),
                OffsetWidget.hGap(6),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: OffsetWidget.setSp(14),
                          fontWeight: FontWeight.w400),
                    ),
                    OffsetWidget.vGap(3),
                    Container(
                      width: OffsetWidget.setSc(150),
                      child: Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorUtils.rgba(153, 153, 153, 1),
                            fontSize: OffsetWidget.setSp(12),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: model.isChoose == true ? true : false,
              child: LoadAssetsImage(
                Constant.ASSETS_IMG + "icon/icon_walletchoose.png",
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return Container(
      height: OffsetWidget.setSc(423),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: ColorUtils.rgba(38, 36, 73, 1),
      ),
      margin: EdgeInsets.only(
          left: OffsetWidget.setSc(15), right: OffsetWidget.setSc(15)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(31), bottom: OffsetWidget.setSc(34)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "".local(),
                ),
                Text(
                  "wallet_switchpurse".local(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: OffsetWidget.setSp(16),
                      fontWeight: FontWeight.w600),
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
            child: ListView.separated(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return _itemBuilder(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 20,
                    color: Colors.transparent,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
