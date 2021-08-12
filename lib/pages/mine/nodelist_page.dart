import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/node/node_model.dart';

import '../../public.dart';

class NodeListPage extends StatefulWidget {
  @override
  _NodeListPageState createState() => _NodeListPageState();
}

class _NodeListPageState extends State<NodeListPage> {
  static const String _kImageName = "_kImageName";
  static const String _kIp = "_kIp";
  static const String _kChainType = "_kChainType";
  static const String _kPingValue = "_kPingValue";

  List<Map> _datas = [];

  @override
  void initState() {
    super.initState();
    _getAllNodes();
  }

  _getAllNodes() async {
    List<NodeModel>? nodes = await NodeModel.queryNodeByIsChoose(true);
    if (nodes != null && nodes.length > 0) {
      _datas.clear();
      nodes.forEach((element) {
        String symbol = Constant.getChainSymbol(element.chainType);
        Map map = {
          _kImageName: "wallet/" + "wallet_$symbol.png",
          _kIp: element.content,
          _kChainType: symbol,
          _kPingValue: "-1",
        };
        _datas.add(map);
      });
      setState(() {});
      _getIpPingValue();
    }
  }

  _getIpPingValue() {
    Future.wait(_datas.map((e) => ChannelWallet.getAvgRTT(e[_kIp])).toList())
        .then((value) {
      LogUtil.v("value $value");
      int i = 0;
      for (i = 0; i < value.length; i++) {
        _datas[i][_kPingValue] = value[i]! + "ms";
      }
      setState(() {});
    });
  }

  Widget _getCellWidget(int index) {
    Map map = _datas[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _cellTap(Constant.getCoinType(map[_kChainType])!.index),
      },
      child: Container(
        alignment: Alignment.center,
        height: OffsetWidget.setSc(45) ,
        decoration: BoxDecoration(
          color: ColorUtils.rgba(73, 73, 73, 0.29),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(
            left: OffsetWidget.setSc(16) ,
            right: OffsetWidget.setSc(16) ,
            top: OffsetWidget.setSc(15) ),
        padding: EdgeInsets.only(
          left: OffsetWidget.setSc(11) ,
          right: OffsetWidget.setSc(18) ,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: OffsetWidget.setSc(27) ),
              child: Text(
                map[_kChainType],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: OffsetWidget.setSp(14) ,
                    fontWeight: FontWightHelper.regular),
              ),
            ),
            Container(
              width: OffsetWidget.setSc(180) ,
              child: Text(
                map[_kIp],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ColorUtils.rgba(153, 153, 153, 1),
                    fontSize: OffsetWidget.setSp(14) ,
                    fontWeight: FontWightHelper.regular),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      map[_kPingValue],
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: OffsetWidget.setSp(12) ,
                          fontWeight: FontWightHelper.semiBold),
                    ),
                  ),
                  OffsetWidget.hGap(7),
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/arrow_dian_whiteright.png",
                    width: 6,
                    height: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cellTap(int chainType) {
    Map<String, dynamic> params = {};
    params["chainType"] = chainType;
    Routers.push(context, Routers.nodeAddPage, params: params).then((value) => {
          _getAllNodes(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenScrollView: true,
      title: CustomPageView.getDefaultTitle(titleStr: "nodelist_title".local()),
      child: Container(
        padding: EdgeInsets.only(top: OffsetWidget.setSc(15) ),
        child: ListView.builder(
          itemCount: _datas.length,
          itemBuilder: (BuildContext context, int index) {
            return _getCellWidget(index);
          },
        ),
      ),
    );
  }
}
