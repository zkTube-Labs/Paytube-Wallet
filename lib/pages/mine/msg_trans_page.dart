import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class MsgTransPage extends StatefulWidget {
  @override
  _MsgTransPageState createState() => _MsgTransPageState();
}

class _MsgTransPageState extends State<MsgTransPage> {
  List allDatas = [];
  int page = 1;
  int pageSize = 10;
  List<String?> _accounts = [];

  @override
  void initState() {
    super.initState();
    _getAccounts();
  }

  Future<void> _getAccounts() async {
    List<MHWallet> wallets = await MHWallet.findAllWallets();
    if (wallets != null) {
      wallets.forEach((element) {
        _accounts.add(element.walletAaddress);
      });
      _getDatas();
    }
  }

  _getDatas() {
    WalletServices.requestGetTransferNotice(_accounts, page, pageSize,
        (result, code) {
      refreshController.loadComplete();
      refreshController.refreshCompleted(resetFooterState: true);
      if (code == 200 && mounted) {
        allDatas.addAll(result);
        setState(() {});
      }
    });
  }

  _readMsg(Map map) {
    String? addr = "";
    if (map["type"].endsWith("转账")) {
      addr = map["from"];
    } else {
      addr = map["to"];
    }
    WalletServices.requestClickTransferNotice(addr, map["trxId"],
        (result, code) {
      if (mounted) {}
    });
  }

  Widget _buildCell(int index) {
    Map map = allDatas[index];

    String logoPath;
    String to = map["to"] ??= "";
    String date = map["createTime"];
    String amount = "";
    String remarks = map["mome"] ??= "";
    Color txtColor;
    if (map["type"].endsWith("转账")) {
      logoPath = Constant.ASSETS_IMG + "icon/trans_out.png";
      txtColor = Color(0xFFF42850);
      amount = "-";
    } else {
      logoPath = Constant.ASSETS_IMG + "icon/trans_in.png";
      txtColor = Color(0xFF54A000);
      amount = "+";
    }
    amount += map["value"] + " " + map["token"];

    return Center(
      child: GestureDetector(
        onTap: () {
          _readMsg(map);
        },
        child: Container(
          width: OffsetWidget.setSc(322),
          height: OffsetWidget.setSc(48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFF6F9FC),
          ),
          padding: EdgeInsets.fromLTRB(
              OffsetWidget.setSc(13),
              OffsetWidget.setSc(7),
              OffsetWidget.setSc(13),
              OffsetWidget.setSc(10)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: OffsetWidget.setSc(309),
                  height: OffsetWidget.setSc(54),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: OffsetWidget.setSc(16)),
                        child: LoadAssetsImage(
                          logoPath,
                          width: OffsetWidget.setSc(16),
                          height: OffsetWidget.setSc(12),
                          fit: BoxFit.contain,
                        ),
                      ),
                      OffsetWidget.hGap(9),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: OffsetWidget.setSc(150),
                                  child: Text(
                                    to,
                                    style: TextStyle(
                                        fontSize: OffsetWidget.setSp(16),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0XFF171F24)),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                OffsetWidget.vGap(3),
                                Container(
                                  width: OffsetWidget.setSc(126),
                                  child: Text(
                                    amount,
                                    style: TextStyle(
                                        fontSize: OffsetWidget.setSp(17),
                                        fontWeight: FontWeight.w400,
                                        color: txtColor),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: OffsetWidget.setSc(150),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        fontSize: OffsetWidget.setSp(12),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF9B9B9B)),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                OffsetWidget.vGap(3),
                                Container(
                                  width: OffsetWidget.setSc(126),
                                  child: Text(
                                    remarks,
                                    style: TextStyle(
                                        fontSize: OffsetWidget.setSp(12),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF000000)),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController searchEC = TextEditingController();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return Container(
      child: CustomRefresher(
        refreshController: refreshController,
        onRefresh: () {
          page = 1;
          allDatas.clear();
          _getDatas();
        },
        onLoading: () {
          page++;
          _getDatas();
        },
        child: ListView.builder(
          itemCount: allDatas.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCell(index);
          },
        ),
      ),
    );
  }
}
