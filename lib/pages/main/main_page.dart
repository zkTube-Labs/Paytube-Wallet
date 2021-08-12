import 'dart:async';
import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coinid/channel/channel_scan.dart';
import 'package:flutter_coinid/models/eventbus/eventclass.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'widget/custom_menu_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../public.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  StreamSubscription? _sEvent;
  @override
  void initState() {
    super.initState();

    // _sEvent = eventBus.on<NodeSwitch>().listen((event) {
    //   Provider.of<CurrentChooseWalletState>(context, listen: false)
    //       .requestAssets(true);
    // });
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .requestAssets(true);
  }

  @override
  void dispose() {
    super.dispose();
    _sEvent?.cancel();
    _sEvent = null;
  }

  _receive() {
    Routers.push(context, Routers.recervePaymentPage);
  }

  _payment() {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateTokenChoose(0);
    Routers.push(
      context,
      Routers.paymentPage,
    );
  }

  _scan() async {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .updateTokenChoose(0);
    MHWallet mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    Map<String, dynamic> params = Map();
    params["contract"] = "";
    params["token"] = "ETH";
    params["decimals"] = Constant.getChainDecimals(mwallet.chainType);
    String? result = await (ChannelScan.scan());
    params["to"] = result;
    Routers.push(context, Routers.paymentPage, params: params);
  }

  Widget _buildWalletView() {
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    String total = Provider.of<CurrentChooseWalletState>(context).totalAssets;
    String currencySymbolStr =
        Provider.of<CurrentChooseWalletState>(context).currencySymbolStr;
    String fimg = Constant.ASSETS_IMG + "icon/icon_new_blacketh.png";
    String bgPath = Constant.ASSETS_IMG + "background/bg_ethlayer3.png";
    String bgPath2 = Constant.ASSETS_IMG + "background/bg_ethlayer2.png";
    String fimg2 = Constant.ASSETS_IMG + "icon/icon_new_ethl2.png";
    String chain = "";
    String descName = mwallet?.descName ?? "";
    String name = "ETHL1/" + descName;
    String name2 = "PaytubeL2/" + descName;
    String l2status = "unlock";
    String total2 = "0.00";

    return Column(
      children: [
        CustomMenuButton(),

        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (mwallet != null) {
              Map<String, dynamic> params = HashMap();
              params["walletID"] = mwallet.walletID;
              Routers.push(context, Routers.walletManagerPage, params: params);
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              left: OffsetWidget.setSc(15),
              right: OffsetWidget.setSc(15),
              bottom: OffsetWidget.setSc(13),
              top: OffsetWidget.setSc(20),
            ),
            padding: EdgeInsets.fromLTRB(
              OffsetWidget.setSc(12),
              OffsetWidget.setSc(19),
              OffsetWidget.setSc(40),
              OffsetWidget.setSc(33),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(bgPath),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              LoadAssetsImage(
                                fimg,
                                width: OffsetWidget.setSc(16),
                                height: OffsetWidget.setSc(26),
                                fit: BoxFit.contain,
                              ),
                              OffsetWidget.hGap(6),
                              Text(
                                name,
                                style: TextStyle(
                                    fontWeight: FontWightHelper.regular,
                                    fontSize: OffsetWidget.setSp(12),
                                    color: Color(0xFFFFFFFF)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: OffsetWidget.setSc(11),
                                margin: EdgeInsets.only(left: 4),
                                padding: EdgeInsets.only(left: 9, right: 9),
                                decoration: BoxDecoration(
                                  color: ColorUtils.fromHex('#FFFFFF'),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  Provider.of<MNodeState>(context)
                                      .nodeTypeStr(),
                                  style: TextStyle(
                                      color: ColorUtils.fromHex('#102F32'),
                                      fontSize: OffsetWidget.setSp(8),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (mwallet != null) {
                              Map<String, dynamic> params = HashMap();
                              params["walletID"] = mwallet.walletID;
                              Routers.push(context, Routers.walletManagerPage,
                                  params: params);
                            }
                          },
                          child: LoadAssetsImage(
                            Constant.ASSETS_IMG +
                                "icon/arrow_white_forward.png",
                            width: 21,
                            height: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: OffsetWidget.setSc(22),
                        right: OffsetWidget.setSc(35),
                        top: OffsetWidget.setSc(3),
                      ),
                      child: RichText(
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: total,
                            style: TextStyle(
                                fontWeight: FontWightHelper.regular,
                                fontSize: OffsetWidget.setSp(20),
                                color: Color(0xFFFFFFFF)),
                            children: [
                              TextSpan(
                                text: currencySymbolStr,
                                style: TextStyle(
                                    fontWeight: FontWightHelper.regular,
                                    fontSize: OffsetWidget.setSp(10),
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                _buildItemBar(),
              ],
            ),
          ),
        ),
        //L2
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(
              left: OffsetWidget.setSc(15),
              right: OffsetWidget.setSc(15),
              bottom: OffsetWidget.setSc(9),
            ),
            padding: EdgeInsets.fromLTRB(
              OffsetWidget.setSc(12),
              OffsetWidget.setSc(19),
              OffsetWidget.setSc(20),
              OffsetWidget.setSc(33),
            ),
            decoration: BoxDecoration(
              color: ColorUtils.fromHex('#2855F2'),
              borderRadius: BorderRadius.circular(10),
            ),
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
                              LoadAssetsImage(
                                fimg2,
                                width: OffsetWidget.setSc(22),
                                height: OffsetWidget.setSc(22),
                                fit: BoxFit.contain,
                              ),
                              OffsetWidget.hGap(6),
                              Text(
                                name2,
                                style: TextStyle(
                                    fontWeight: FontWightHelper.regular,
                                    fontSize: OffsetWidget.setSp(12),
                                    color: Color(0xFFFFFFFF)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: OffsetWidget.setSc(11),
                                margin: EdgeInsets.only(left: 4),
                                padding: EdgeInsets.only(left: 9, right: 9),
                                decoration: BoxDecoration(
                                  color: ColorUtils.fromHex('#FFFFFF'),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  Provider.of<MNodeState>(context)
                                      .nodeTypeStr(),
                                  style: TextStyle(
                                      color: ColorUtils.fromHex('#102F32'),
                                      fontSize: OffsetWidget.setSp(8),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: OffsetWidget.setSc(20),
                          ),
                          child: LoadAssetsImage(
                            Constant.ASSETS_IMG +
                                "icon/arrow_white_forward.png",
                            width: 21,
                            height: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: OffsetWidget.setSc(22),
                                right: OffsetWidget.setSc(35),
                                top: OffsetWidget.setSc(3),
                              ),
                              child: RichText(
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: total2,
                                    style: TextStyle(
                                        fontWeight: FontWightHelper.regular,
                                        fontSize: OffsetWidget.setSp(20),
                                        color: Color(0xFFFFFFFF)),
                                    children: [
                                      TextSpan(
                                        text: currencySymbolStr,
                                        style: TextStyle(
                                            fontWeight: FontWightHelper.regular,
                                            fontSize: OffsetWidget.setSp(10),
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              child: LoadAssetsImage(
                                Constant.ASSETS_IMG + "icon/icon_unlock.png",
                                width: 14,
                                height: 14,
                              ),
                            ),
                            Text(
                              l2status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: OffsetWidget.setSp(12),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: LoadAssetsImage(
                                Constant.ASSETS_IMG + "icon/icon_q.png",
                                width: 13,
                                height: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                //item
                buildItem2Bar(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///L1view上的三个按钮
  Widget _buildItemBar() {
    return Container(
      padding: EdgeInsets.only(
        top: OffsetWidget.setSc(38),
        left: OffsetWidget.setSc(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _receive(),
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_recevice.png",
                    width: OffsetWidget.setSc(30),
                    height: OffsetWidget.setSc(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "trans_receive".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _payment(),
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_payment.png",
                    width: OffsetWidget.setSp(30),
                    height: OffsetWidget.setSp(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "wallet_payment".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _scan(),
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_bigscan.png",
                    width: OffsetWidget.setSp(30),
                    height: OffsetWidget.setSp(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "wallet_scans".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem2Bar() {
    return Container(
      padding: EdgeInsets.only(
        top: OffsetWidget.setSc(38),
        left: OffsetWidget.setSc(15),
        right: OffsetWidget.setSc(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            // onTap: () => _receive(),
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_deposit.png",
                    width: OffsetWidget.setSc(30),
                    height: OffsetWidget.setSc(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "wallet_Deposit".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_transfer.png",
                    width: OffsetWidget.setSc(30),
                    height: OffsetWidget.setSc(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "wallet_Transfer".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              child: Column(
                children: [
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_withdraw.png",
                    width: OffsetWidget.setSc(30),
                    height: OffsetWidget.setSc(30),
                  ),
                  OffsetWidget.vGap(9),
                  Text(
                    "wallet_Withdraw".local(context: context),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)!.delegates;
    MHWallet? stateWallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    String total = Provider.of<CurrentChooseWalletState>(context).totalAssets;
    String currencySymbolStr =
        Provider.of<CurrentChooseWalletState>(context).currencySymbolStr;
    String totalBtcAssets =
        Provider.of<CurrentChooseWalletState>(context).totalBtcAssets() + "BTC";
    String value = total + currencySymbolStr;
    String aboutbtc = "≈$totalBtcAssets";
    return CustomPageView(
      hiddenScrollView: true,
      hiddenLeading: true,
      hiddenAppBar: true,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 33, right: 33),
                child: Stack(
                  children: [
                    Positioned(
                      // top: OffsetWidget.setSc(110),
                      child: Container(
                        alignment: Alignment.center,
                        // color: Colors.amber,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: OffsetWidget.setSp(22),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              aboutbtc,
                              style: TextStyle(
                                color: ColorUtils.rgba(153, 153, 153, 1),
                                fontSize: OffsetWidget.setSp(10),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // alignment: Alignment.,
                    Positioned(
                      ///350卡片的高度，82状态栏的高度，34是菜单栏的高度，25是间距，34是字体的高度
                      top: (OffsetWidget.getScreenHeight()! -
                              OffsetWidget.setSc(350) -
                              OffsetWidget.setSc(82) -
                              OffsetWidget.setSc(34) -
                              OffsetWidget.setSc(25) -
                              OffsetWidget.setSc(34) -
                              OffsetWidget.setSc(56) -
                              OffsetWidget.getStatusBarHeight()!) /
                          2, //OffsetWidget.setSc(110),
                      left: OffsetWidget.setSc(15),
                      right: OffsetWidget.setSc(15),
                      bottom: OffsetWidget.setSc(10),
                      // width: OffsetWidget.setSc(375),
                      child: Container(
                        // color: Colors.red,
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          Constant.ASSETS_IMG + "background/bg_ethlayer4.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildWalletView(),
          ],
        ),
      ),
    );
  }
}
