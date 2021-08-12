import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class MyMsgPage extends StatefulWidget {
  @override
  _MyMsgPageState createState() => _MyMsgPageState();
}

class _MyMsgPageState extends State<MyMsgPage> {
  List allDatas = [];
  int page = 1;
  int pageSize = 10;
  String? _imei = "";

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  void _getAppInfo() async {
    _imei = await ChannelWallet.deviceImei();
    _getDatas();
  }

  _getDatas() {
    WalletServices.requestGetSystemMessage(_imei, page, pageSize,
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
    WalletServices.requestClickSystemMessage(_imei, map["id"], (result, code) {
      if (mounted) {
        setState(() {
          map["state"] = 0;
        });
        Map<String, dynamic> params = {};
        params["title"] = map["title"];
        params["content"] = map["message"];
        params["team"] = map["author"];
        params["date"] = map["dataTime"];
        // Routers.push(context, Routers.msgSystemDetailPage, params: params);
      }
    });
  }

  Widget _buildCell(int index) {
    Map map = allDatas[index];
    bool isRead = map["state"] == 1 ? false : true;
    String title = map["title"];
    String dataTime = map["dataTime"];
    String message = map["message"];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _readMsg(map);
      },
      child: Container(
        height: OffsetWidget.setSc(74) ,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEAEFF2), width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: !isRead,
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              color: Color(0xFFE95243),
                            ),
                          ),
                          OffsetWidget.hGap(7),
                        ],
                      ),
                    ),
                    Text(title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: OffsetWidget.setSp(14) ,
                            fontWeight: FontWightHelper.medium,
                            color: isRead
                                ? Color(0xFF676F80)
                                : Color(0xFF161D2D))),
                  ],
                ),
                Text(
                  dataTime,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWightHelper.regular,
                    fontSize: OffsetWidget.setSp(14) ,
                    color: Color(0xFFACBBCF),
                  ),
                ),
              ],
            ),
            OffsetWidget.vGap(3),
            Text(
              message,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(14) ,
                  fontWeight: FontWightHelper.regular,
                  color: Color(0xFFACBBCF)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getBarAction() {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: OffsetWidget.setSc(10) ),
        alignment: Alignment.centerRight,
        height: OffsetWidget.setSc(40) ,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => {_readAll()},
          child: Text("msg_all_read".local(),
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(15) ,
                  fontWeight: FontWightHelper.regular,
                  color: Color(0xFF171F24))),
        ),
      ),
    ];
  }

  _readAll() {
    WalletServices.requestClickSystemMessageAllRead(_imei, (result, code) {
      if (mounted) {
        page = 1;
        allDatas.clear();
        _getDatas();
      }
    });
  }

  TextEditingController searchEC = TextEditingController();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(titleStr: "msg_system".local()),
      hiddenScrollView: true,
      actions: getBarAction(),
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
        child: Container(
          padding: EdgeInsets.only(
              top: OffsetWidget.setSc(15) ,
              left: OffsetWidget.setSc(19) ,
              right: OffsetWidget.setSc(17) ),
          child: ListView.builder(
            itemCount: allDatas.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCell(index);
            },
          ),
        ),
      ),
    );
  }
}
