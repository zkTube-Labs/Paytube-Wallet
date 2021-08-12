import 'package:flutter_coinid/models/assets/currency_list.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/widgets/custom_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class AddAssetsPage extends StatefulWidget {
  AddAssetsPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _AddAssetsPageState createState() => _AddAssetsPageState();
}

class _AddAssetsPageState extends State<AddAssetsPage> {
  List<MCollectionTokens> allDatas = [];
  TextEditingController searchEC = TextEditingController();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  _getAssets() {
    Future.delayed(Duration(seconds: 2)).then((value) => {
          refreshController.loadComplete(),
          refreshController.refreshCompleted(resetFooterState: true),
        });
    initData();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    List<MCollectionTokens> datas =
        await MCollectionTokens.findTokens(mwallet?.walletAaddress ?? "");
    int chainID = Provider.of<MNodeState>(context, listen: false).chainID ?? 4;
    List<MCollectionTokens> cachedatas = [];
    if (chainID == 1) {
      for (var item in datas) {
        if (item.token == "ETH") {
          //  || item.token == "ZKTR"
          continue;
        }
        cachedatas.add(item);
      }
    }
    setState(() {
      allDatas = cachedatas;
    });
    // searchToken("0x5fb9a09501111df2d5771b6107bfa4bcca09fa98");
  }

  void _collectToken(int index) {
    MCollectionTokens map = allDatas[index];
    map.state = map.state == 0 ? 1 : 0;
    MCollectionTokens.insertToken(map);
    setState(() {});
  }

  void searchToken(String contract) {
    MHWallet? mwallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    LogUtil.v("searchToken $contract");
    if (contract.length == 0) {
      initData();
      return;
    } else {
      setState(() {
        allDatas = [];
      });
    }

    ChainServices.requestTokenInfo(
        chainType: MCoinType.MCoinType_ETH.index,
        contract: contract,
        from: mwallet?.walletAaddress ?? "",
        block: (result, code) {
          if (code == 200 && result is MCollectionTokens) {
            MCollectionTokens token = result;
            setState(() {
              allDatas = [token];
            });
          }else{
            
          }
        });
  }

  Widget getCustomAppBar() {
    return Padding(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(16), right: OffsetWidget.setSc(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                Routers.goBack(context),
              },
              child: Container(
                height: OffsetWidget.setSc(30),
                padding: EdgeInsets.only(right: 5),
                alignment: Alignment.centerLeft,
                child: LoadAssetsImage(
                  Constant.ASSETS_IMG + "icon/icon_goback.png",
                  scale: 2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: OffsetWidget.setSc(36),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(31, 30, 62, 1),
                  borderRadius: BorderRadius.circular(
                    OffsetWidget.setSc(8),
                  ),
                ),
                child: Row(
                  children: [
                    LoadAssetsImage(
                      Constant.ASSETS_IMG + "icon/icon_search.png",
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: searchEC,
                        maxLines: 1,
                        onSubmitted: (value) {},
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: OffsetWidget.setSp(12),
                          fontWeight: FontWightHelper.regular,
                        ),
                        onChange: (value) {
                          searchToken(value);
                        },
                        decoration: CustomTextField.getBorderLineDecoration(
                          fillColor: ColorUtils.rgba(31, 30, 62, 1),
                          hintText: "wallet_inputtoken".local(),
                          borderColor: Colors.transparent,
                          hintStyle: TextStyle(
                              fontSize: OffsetWidget.setSp(12),
                              fontWeight: FontWightHelper.medium,
                              color: Color(0xFF929695)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildCell(int index) {
    MCollectionTokens map = allDatas[index];
    String contract = map.contract ?? "";
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: OffsetWidget.setSc(11),
              left: OffsetWidget.setSc(33),
              right: OffsetWidget.setSc(31),
              bottom: OffsetWidget.setSc(10)),
          height: OffsetWidget.setSc(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: LoadAssetsImage(
                        '${Constant.ASSETS_IMG}currencyIcon/icon_${map.token!}.png',
                        width: 36,
                        height: 36, errorBuilder: (BuildContext context,
                            Object exception, StackTrace? stackTrace) {
                      return LoadAssetsImage(
                          Constant.ASSETS_IMG + "icon/icon_eth.png",
                          width: 36,
                          height: 36);
                    }),
                  ),
                  OffsetWidget.hGap(9),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: OffsetWidget.setSc(200),
                        child: Text(
                          map.token ?? "",
                          style: TextStyle(
                              fontSize: OffsetWidget.setSp(16),
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      OffsetWidget.vGap(5),
                      Visibility(
                        visible: contract.isValid() == true ? true : false,
                        child: Container(
                          width: OffsetWidget.setSc(200),
                          child: Text(
                            contract,
                            style: TextStyle(
                                fontSize: OffsetWidget.setSp(10),
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.rgba(171, 171, 171, 1)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  OffsetWidget.hGap(9),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _collectToken(index);
                },
                child: Container(
                  height: OffsetWidget.setSc(48),
                  child: LoadAssetsImage(
                    map.state == 0
                        ? Constant.ASSETS_IMG + "icon/icon_asset_unseleted.png"
                        : Constant.ASSETS_IMG + "icon/icon_asset_seleted.png",
                    width: OffsetWidget.setSc(14),
                    height: OffsetWidget.setSc(14),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        // OffsetWidget.vGap(11),
        Container(
          margin: EdgeInsets.only(
            left: OffsetWidget.setSc(74),
            right: OffsetWidget.setSc(30),
          ),
          height: 1,
          color: Colors.white10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenAppBar: true,
      hiddenScrollView: true,
      hiddenResizeToAvoidBottomInset: false,
      child: Column(
        children: [
          getCustomAppBar(),
          Container(
            width: OffsetWidget.setSc(360),
            margin: EdgeInsets.only(
                left: OffsetWidget.setSc(22),
                top: OffsetWidget.setSc(25),
                bottom: OffsetWidget.setSc(10)),
            child: Text(
              "search_token_title".local(),
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: CustomRefresher(
              refreshController: refreshController,
              onRefresh: () {
                _getAssets();
              },
              enableHeader: false,
              child: ListView.builder(
                itemCount: allDatas.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCell(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
