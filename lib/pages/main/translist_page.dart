import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:event_bus/event_bus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';
import 'package:flutter_coinid/utils/timer_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../public.dart';

EventBus eventBus = EventBus();

class MTransListEvent {
  bool? isRefresh;
  MTransListEvent(this.isRefresh);
  void refresh() {}
}

class MTransListPageIndex {
  int? selectIndex;
  MTransListPageIndex(this.selectIndex);
}

class TransListPage extends StatefulWidget {
  TransListPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _TransListPageState createState() => _TransListPageState();
}

class _TransListPageState extends State<TransListPage>
    with SingleTickerProviderStateMixin {
  double? tokenPrice = 0;
  // String chainType;
  // String token;
  // String decimals;
  // String contract;
  // String walletAddress;
  TabController? _tabController;
  String? balance;
  late String total;
  final List<Tab> _myTabs = <Tab>[
    Tab(text: 'wallets_all'.local()),
    Tab(text: 'payment_transtout'.local()),
    Tab(text: 'wallets_transin'.local()),
    Tab(text: 'wallets_transerr'.local()),
  ];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TimerUtil? timer;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 4, vsync: this);

    super.initState();

    MHWallet wallets =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    String walletAddress = wallets.walletAaddress!;

    int? amountType =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currencyType
            ?.index;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens!;
    String assets = "≈" + (amountType == 0 ? "￥" : "\$");
    total = assets + tokens.assets;
    balance = StringUtil.dataFormat(tokens.balance!.toDouble(), tokens.digits!);
    int chainID = Provider.of<MNodeState>(context, listen: false).chainID ?? 4;

    if (timer == null) {
      timer = TimerUtil(mInterval: 10000);
      timer!.setOnTimerTickCallback((millisUntilFinished) async {
        _initData();
        List rpcs = [];
        List<TransRecordModel> mdoels = await TransRecordModel.queryTrxList(
            walletAddress, tokens.token!, chainID);
        for (var item in mdoels) {
          if (item.transStatus == MTransState.MTransState_Pending.index) {
            String method = "eth_getTransactionReceipt";
            Map params = {
              "jsonrpc": "2.0",
              "method": method,
              "params": [item.txid],
              "id": item.txid
            };
            rpcs.add(params);
          }
        }
        if (rpcs.length > 0) {
          ChainServices.requestETHRpc(
              chainType: MCoinType.MCoinType_ETH.index,
              url: ChainServices.currentNode!.content,
              paramas: rpcs,
              block: (result, code) async {
                if (code == 200 && result is List) {
                  for (var element in result) {
                    if (element is Map == true) {
                      Map params = element;
                      if (params.keys.contains("result")) {
                        String? id = params["id"] as String?;
                        TransRecordModel mdoel =
                            (await TransRecordModel.queryTrxFromTrxid(id!))
                                .first;
                        mdoel.transStatus =
                            MTransState.MTransState_Success.index;
                        TransRecordModel.updateTrxList(mdoel);
                        eventBus.fire(MTransListEvent(true));
                      }
                    }
                  }
                }
              });
        }
      });
    }
    if (timer!.isActive() == false) {
      timer!.startTimer();
    }
    _initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  _initData() async {
    MHWallet wallets =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens!;
    int? amountType =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currencyType
            ?.index;
    String walletAddress = wallets.walletAaddress!;
    String? contract = tokens.contract;
    String? token = tokens.token;
    int? decimals = tokens.decimals;
    String coinType = Constant.getChainSymbol(wallets.chainType);
    String assets = "≈" + (amountType == 0 ? "￥" : "\$");
    ChainServices.requestAssets(
        chainType: wallets.chainType!,
        from: walletAddress,
        contract: contract,
        token: token,
        tokenDecimal: decimals,
        block: (result, code) {
          LogUtil.v("_initData $result $code");
          if (code == 200 && result is MainAssetResult && mounted) {
            String? newValue = result.c;
            newValue ??= "0";
            num price = result.mainUsdPrice ?? 0.0;
            if (amountType == 0) {
              price = (result.usdConversionCny ?? 0.0) * price;
            }
            LogUtil.v("_initData111 $result $code");
            setState(() {
              balance = StringUtil.dataFormat(
                  double.tryParse(newValue!) ?? 0, tokens.digits!);
              total = assets +
                  StringUtil.dataFormat(
                      (double.tryParse(newValue)! * price), 2);
              LogUtil.v("_initData setState $newValue");
            });
          }
        });
  }

  void _walletCategoryClick(int page) async {
    eventBus.fire(MTransListPageIndex(page));

    // _refreshTransList(page);
    // selectIndex = page;
  }

  void _receiveClick() {
    Map<String, dynamic> params = HashMap();
    // params["walletAddress"] = walletAddress;
    // params["contract"] = contract;
    // params["token"] = token;
    // params["decimals"] = decimals;
    // params["chainType"] = chainType;
    // params["onlyAddress"] = 0;
    Routers.push(context, Routers.recervePaymentPage, params: params);
  }

  void _paymentClick() {
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens!;

    Map<String, dynamic> params = Map();
    params["contract"] = tokens.contract;
    params["token"] = tokens.token;
    params["decimals"] = tokens.decimals;
    params["decimals"] = tokens.decimals;
    params["hiddenTokens"] = true;
    Routers.push(context, Routers.paymentPage, params: params).then((value) => {
          LogUtil.v("_scaffoldKeycurrentContext"),
          _tabController?.animateTo(0),
          eventBus.fire(MTransListEvent(true)),
          // DefaultTabController.of(_scaffoldKey.currentContext!)!.index = 1,
          Future.delayed(Duration(seconds: 3)).then((value) => {
                _initData(),
                LogUtil.v("_initData start"),
              }),
        });
  }

  Widget _headerBuilder() {
    String? walletAddress = Provider.of<CurrentChooseWalletState>(context)
        .currentWallet!
        .walletAaddress;
    walletAddress ??= "";
    return GestureDetector(
      onTap: () {},
      child: Container(
          // color: Color,
          child: Column(
        children: [
          OffsetWidget.vGap(25),
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
          OffsetWidget.vGap(9),
          Container(
            alignment: Alignment.center,
            width: OffsetWidget.setSc(300),
            child: Text(
              balance!,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: OffsetWidget.setSc(300),
            child: Text(
              total,
              style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: OffsetWidget.setSp(14)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    MHWallet wallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet!;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context).chooseTokens!;
    return DefaultTabController(
      length: _myTabs.length,
      key: _scaffoldKey,
      child: CustomPageView(
        hiddenScrollView: true,
        title: CustomPageView.getDefaultTitle(
          titleStr: tokens.token!,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Text(""),
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: OffsetWidget.setSc(120),
                  padding: EdgeInsets.only(
                      left: OffsetWidget.setSc(65),
                      right: OffsetWidget.setSc(65)),
                  child: _headerBuilder(),
                ),
                Material(
                    color: Color(Constant.main_color),
                    child: Theme(
                      data: ThemeData(
                          splashColor: Color.fromRGBO(0, 0, 0, 0),
                          highlightColor: Color.fromRGBO(0, 0, 0, 0)),
                      child: TabBar(
                        tabs: _myTabs,
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        indicatorWeight: 1,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: OffsetWidget.setSp(16),
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelColor: ColorUtils.rgba(153, 153, 153, 1),
                        unselectedLabelStyle: TextStyle(
                          fontSize: OffsetWidget.setSp(16),
                          fontWeight: FontWeight.w600,
                          // color: Colors.red,
                        ),
                        onTap: (page) => {
                          _walletCategoryClick(page),
                        },
                      ),
                    )),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(), //禁止左右滑动
                children: [
                  MTransListPage(
                    selectIndex: MTransListType.MTransListType_All,
                    tokenPrice: tokenPrice,
                    refreshBack: () => {
                      _initData(),
                    },
                  ),
                  MTransListPage(
                    selectIndex: MTransListType.MTransListType_Out,
                    tokenPrice: tokenPrice,
                    refreshBack: () => {
                      _initData(),
                    },
                  ),
                  MTransListPage(
                    selectIndex: MTransListType.MTransListType_In,
                    tokenPrice: tokenPrice,
                    refreshBack: () => {
                      _initData(),
                    },
                  ),
                  MTransListPage(
                    selectIndex: MTransListType.MTransListType_Err,
                    tokenPrice: tokenPrice,
                    refreshBack: () => {
                      _initData(),
                    },
                  )
                ],
              ),
            ),
            Container(
              height: OffsetWidget.setSc(86),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _paymentClick,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorUtils.rgba(59, 65, 89, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: OffsetWidget.setSc(46),
                      width: OffsetWidget.setSc(160),
                      child: Text(
                        "wallet_payment".local(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: OffsetWidget.setSp(20),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  OffsetWidget.hGap(12),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _receiveClick,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorUtils.rgba(78, 220, 152, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: OffsetWidget.setSc(46),
                      width: OffsetWidget.setSc(160),
                      child: Text(
                        "payment_toaddress".local(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: OffsetWidget.setSp(20),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MTransListPage extends StatefulWidget {
  MTransListPage(
      {Key? key, this.tokenPrice, this.selectIndex, this.refreshBack})
      : super(key: key);
  final double? tokenPrice;
  final MTransListType? selectIndex;
  // final String contract;
  // final String walletAddress;
  // final String token;
  // final String chainType;
  final VoidCallback? refreshBack;

  @override
  _MTransListPageState createState() => _MTransListPageState();
}

class _MTransListPageState extends State<MTransListPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );
  List<TransRecordModel> _datas = [];
  int _page = 1;
  StreamSubscription? _sEvent, _indexEvent;

  int selectIndex = MTransListType.MTransListType_All.index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _sEvent = eventBus.on<MTransListEvent>().listen((event) {
      if (event.isRefresh == true) {
        _requestTransListWithNet(1);
      }
    });
    _indexEvent = eventBus.on<MTransListPageIndex>().listen((event) {
      selectIndex = event.selectIndex ?? 0;
      _requestTransListWithNet(1);
    });
    LogUtil.v("_MTransListPageState ");
    _requestTransListWithNet(_page);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sEvent?.cancel();
    _sEvent = null;
    _indexEvent?.cancel();
    _indexEvent = null;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _requestTransListWithNet(int page) async {
    _page = page;
    MHWallet mhWallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens!;
    MTransListType index = MTransListType.MTransListType_All;
    if (selectIndex == MTransListType.MTransListType_Out.index) {
      index = MTransListType.MTransListType_Out;
    }
    if (selectIndex == MTransListType.MTransListType_In.index) {
      index = MTransListType.MTransListType_In;
    }
    if (selectIndex == MTransListType.MTransListType_Err.index) {
      index = MTransListType.MTransListType_Err;
    }

    int chainType = mhWallet.chainType!;
    String from = mhWallet.walletAaddress!;
    String? token = tokens.token;
    int chainID = Provider.of<MNodeState>(context, listen: false).chainID ?? 4;
    LogUtil.v(
        "_requestTransListWithNet $from chainType $chainType  selectIndex $selectIndex _page $_page");
    HWToast.showLoading(clickClose: true);
    ChainServices.requestTransRecord(chainType, index, from, token, page,
        (result, code) async {
      HWToast.hiddenAllToast();
      _refreshController.loadComplete();
      _refreshController.refreshCompleted(resetFooterState: true);
      List<TransRecordModel> dbs =
          await TransRecordModel.queryTrxList(from, token ?? "ETH", chainID);
      List<TransRecordModel> cacheDatas = [];
      //需要判断是转入查找还是转出等
      for (var item in dbs) {
        //本地可能跟主网链上重复
        if (index == MTransListType.MTransListType_All) {
          cacheDatas.add(item);
        } else {
          if (item.transType == selectIndex) {
            cacheDatas.add(item);
          }
        }
      }

      if (code == 200 && mounted) {
        setState(() {
          _datas.clear();
          _datas.addAll(cacheDatas);
        });
      }
    });
  }

  void _cellContentSelectRowAt(int index) {
    LogUtil.v("点击钱包整体");
    TransRecordModel transModel = _datas[index];
    Map<String, dynamic> params = {
      "txid": transModel.txid,
      "price": widget.tokenPrice.toString()
    };
    NodeModel? node =
        Provider.of<MNodeState>(context, listen: false).currentNode;
    String url = "";
    if (node?.isMainnet == true) {
      url = "https://cn.etherscan.com/tx/" + transModel.txid!;
    } else {
      url = "https://rinkeby.etherscan.io/tx/" + transModel.txid!;
    }
    Routers.push(context, Routers.transDetailPage, params: params);
    // launch(url);
  }

  Widget _cellBuilder(int index) {
    TransRecordModel transModel = _datas[index];
    String logoPath;
    String to = transModel.txid!;
    String date = transModel.date!;
    String amount = "";
    String remarks = transModel.remarks ??= "";
    Color txtColor;
    MHWallet wallets =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    if (transModel.transType == MTransListType.MTransListType_Out.index) {
      logoPath = Constant.ASSETS_IMG + "icon/trans_out.png";
      txtColor = Color(0xFF586883);
      amount = "-";
    } else {
      logoPath = Constant.ASSETS_IMG + "icon/trans_in.png";
      txtColor = Color(0xFF586883);
      amount = "+";
    }
    if (transModel.transStatus == MTransState.MTransState_Success.index) {
      remarks = "translist_transoutsuccess".local();
    } else if (transModel.transStatus ==
        MTransState.MTransState_Pending.index) {
      remarks = "translist_transPending".local();
    } else if (transModel.transStatus ==
        MTransState.MTransState_Failere.index) {
      remarks = "translist_transFailere".local();
    }
    amount += transModel.amount! + " ${transModel.symbol}";
    return GestureDetector(
      onTap: () => _cellContentSelectRowAt(index),
      child: Container(
        height: OffsetWidget.setSc(60),
        width: OffsetWidget.setSc(300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white12,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: OffsetWidget.setSc(200),
                  child: Text(
                    to,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(14),
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                OffsetWidget.vGap(3),
                Container(
                  child: Text(
                    date,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(10),
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9B9B9B)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            OffsetWidget.hGap(5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      amount,
                      style: TextStyle(
                          fontSize: OffsetWidget.setSp(16),
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  OffsetWidget.vGap(3),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      remarks,
                      style: TextStyle(
                          fontSize: OffsetWidget.setSp(10),
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF33D371)),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 25),
      alignment: Alignment.center,
      child: CustomRefresher(
        refreshController: _refreshController,
        onRefresh: () {
          _requestTransListWithNet(1);
          widget.refreshBack!();
        },
        onLoading: () {
          _requestTransListWithNet(_page + 1);
        },
        child: _datas.length == 0
            ? EmptyDataPage(
                emptyTip: "empay_datano",
                refreshAction: () => {
                  // _requestTransListWithNet(1),
                },
              )
            : ListView.builder(
                itemCount: _datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return _cellBuilder(index);
                },
              ),
      ),
    );
  }
}
