import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_scan.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/pages/main/wallets_manager_lists.dart';
import 'package:flutter_coinid/utils/screenutil.dart';
import 'package:flutter_coinid/utils/ver_upgrade_util.dart';
import 'package:flutter_coinid/widgets/custom_network_image.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../public.dart';

class WalletManagerPage extends StatefulWidget {
  @override
  _WalletManagerPageState createState() => _WalletManagerPageState();
}

class _WalletManagerPageState extends State<WalletManagerPage> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _cellDidSelectRowAt(int index) {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateTokenChoose(index);
    Routers.push(context, Routers.transListPage).then((value) => {
          Provider.of<CurrentChooseWalletState>(context, listen: false)
              .requestAssets(true),
        });
  }

  _receive() {
    Routers.push(context, Routers.recervePaymentPage);
  }

  _addAssetsList() {
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    Map<String, dynamic> params = HashMap();
    // params["account"] = mwallet.walletAaddress;
    // params["symbol"] = mwallet.symbol.toUpperCase();
    Routers.push(context, Routers.addAssetsPagePage, params: params)
        .then((value) => {
              Provider.of<CurrentChooseWalletState>(context, listen: false)
                  .findMyCollectionTokens(),
            });
  }

  Widget buildHeadView() {
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    String total = Provider.of<CurrentChooseWalletState>(context).totalAssets;
    String bgPath = Constant.ASSETS_IMG + "background/bg_wallets.png";
    if (mwallet != null) {}
    String name = "ETHL1/";
    if (mwallet?.descName != null) {
      name += mwallet!.descName!;
    }
    String currencySymbolStr =
        Provider.of<CurrentChooseWalletState>(context).currencySymbolStr;
    total = "≈" + currencySymbolStr + total;
    return Container(
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (mwallet != null) {
                Map<String, dynamic> params = HashMap();
                params["walletID"] = mwallet.walletID;
                Routers.push(context, Routers.walletInfoPagePage,
                    params: params);
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  OffsetWidget.setSc(55),
                  OffsetWidget.setSc(37),
                  OffsetWidget.setSc(49),
                  OffsetWidget.setSc(24)),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    bgPath,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              height: OffsetWidget.setSc(184),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //图片名字编辑
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: LoadAssetsImage(
                                    Constant.ASSETS_IMG + "icon/icon_eth.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                                // OffsetWidget.hGap(4),
                                SizedBox(width: 4,),
                                Expanded(
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWightHelper.semiBold,
                                        fontSize: OffsetWidget.setSp(20),
                                        color: Color(0xFFFFFFFF)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _receive();
                            },
                            child: LoadAssetsImage(
                              Constant.ASSETS_IMG + "icon/icon_qrcode.png",
                              width: 21,
                              height: 21,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: OffsetWidget.setSc(11),
                        margin: EdgeInsets.only(left: 36),
                        padding: EdgeInsets.only(left: 9,right:9),
                        decoration: BoxDecoration(
                          color: ColorUtils.fromHex('#FFFFFF'),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          Provider.of<MNodeState>(context).nodeTypeStr(),
                          style: TextStyle(
                              color: ColorUtils.fromHex('#102F32'),
                              fontSize: OffsetWidget.setSp(8),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      total,
                      style: TextStyle(
                        fontSize: OffsetWidget.setSp(16),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellBuilder(int index) {
    String tokenAssets = "0.00";
    String balance = "0.0000";
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    List<MCollectionTokens> collectionTokens =
        Provider.of<CurrentChooseWalletState>(context).collectionTokens;
    String convert =
        Provider.of<CurrentChooseWalletState>(context).currencySymbolStr;
    MCollectionTokens map = collectionTokens[index];
    tokenAssets = map.assets;
    tokenAssets = "≈$convert" + tokenAssets;
    balance = StringUtil.dataFormat(map.balance!.toDouble(), map.digits!);
    String placeholderPath = "";
    String? token = map.token;
    token ??= "";
    String tokenImage = "currencyIcon/" + "icon_$token.png";
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _cellDidSelectRowAt(index),
      },
      child: Container(
        padding: EdgeInsets.only(
          left: OffsetWidget.setSc(22),
          right: OffsetWidget.setSc(25),
        ),
        margin: EdgeInsets.only(bottom: OffsetWidget.setSc(17)),
        height: OffsetWidget.setSc(49),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadAssetsImage(Constant.ASSETS_IMG + tokenImage,
                    width: 24, height: 24, errorBuilder: (BuildContext context,
                        Object exception, StackTrace? stackTrace) {
                  return LoadAssetsImage(
                      Constant.ASSETS_IMG + "icon/icon_eth.png",
                      width: 24,
                      height: 24);
                }),
                OffsetWidget.hGap(15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: OffsetWidget.setSc(120),
                      child: Text(
                        token,
                        style: TextStyle(
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(16),
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: OffsetWidget.setSc(120),
                      child: Text(
                        token,
                        style: TextStyle(
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(14),
                            color: ColorUtils.rgba(148, 163, 211, 1)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  width: OffsetWidget.setSc(100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        balance,
                        style: TextStyle(
                          fontSize: OffsetWidget.setSp(16),
                          fontWeight: FontWightHelper.semiBold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // OffsetWidget.vGap(11),
                      Text(
                        tokenAssets,
                        style: TextStyle(
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(14),
                            color: ColorUtils.rgba(171, 171, 171, 1)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MHWallet? stateWallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    return CustomPageView(
      hiddenScrollView: true,
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: ColorUtils.rgba(40, 33, 84, 1),
              elevation: 0,
              isDismissible: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              builder: (context) {
                return SafeArea(child: WalletsMangerList());
              });
        },
        child: Container(
          height: OffsetWidget.setSc(24),
          width: OffsetWidget.setSc(102),
          padding: EdgeInsets.only(
            left: OffsetWidget.setSc(26),
            right: OffsetWidget.setSc(26),
          ),
          decoration: BoxDecoration(
            color: ColorUtils.rgba(61, 63, 66, 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              LoadAssetsImage(
                Constant.ASSETS_IMG + "icon/icon_vector.png",
                width: 6,
                height: 6,
              ),
              OffsetWidget.hGap(6),
              Expanded(
                child: Text(
                  stateWallet?.descName ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: OffsetWidget.setSp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: CustomRefresher(
          refreshController: refreshController,
          onRefresh: () {
            Provider.of<CurrentChooseWalletState>(context, listen: false)
                .requestAssets(true);
            Future.delayed(Duration(seconds: 3)).then((value) => {
                  refreshController.loadComplete(),
                  refreshController.refreshCompleted(resetFooterState: true),
                });
          },
          enableFooter: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeadView(),
              Container(
                padding: EdgeInsets.only(
                    top: OffsetWidget.setSc(45),
                    bottom: OffsetWidget.setSc(20),
                    left: OffsetWidget.setSc(25),
                    right: OffsetWidget.setSc(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "main_assets".local(context: context),
                      style: TextStyle(
                          fontSize: OffsetWidget.setSp(16),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Visibility(
                      visible: true,
                      child: GestureDetector(
                        onTap: () => _addAssetsList(),
                        child: Visibility(
                            visible: true,
                            child: LoadAssetsImage(
                              Constant.ASSETS_IMG + "icon/icon_add_token.png",
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: Provider.of<CurrentChooseWalletState>(context)
                      .collectionTokens
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return _cellBuilder(index);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
