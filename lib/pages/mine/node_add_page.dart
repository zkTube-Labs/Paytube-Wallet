import 'package:flutter/cupertino.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/eventbus/eventclass.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/widgets/custom_alert.dart';

import '../../public.dart';

class NodeAddPage extends StatefulWidget {
  NodeAddPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _NodeAddPageState createState() => _NodeAddPageState();
}

class _NodeAddPageState extends State<NodeAddPage> {
  int chainType = 0;
  List<NodeModel> customDatas = [];
  NodeModel? defaultMainnet;
  NodeModel? defaultTestnet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.params != null) {
      chainType = int.parse(widget.params!["chainType"][0]);
    }
    _getNodes(MCoinType.MCoinType_ETH.index);
  }

  Future<List<NodeModel>?> _getNodes(int chainType) async {
    customDatas =
        (await NodeModel.queryNodeByIsDefaultAndChainType(false, chainType)) ??
            [];
    List<NodeModel> defaultDatas =
        (await NodeModel.queryNodeByIsDefaultAndChainType(true, chainType)) ??
            [];
    defaultDatas.forEach((element) {
      if (element.isDefault == true) {
        if (element.isMainnet == true) {
          defaultMainnet = element;
        } else {
          defaultTestnet = element;
        }
      }
    });
    setState(() {});
    return customDatas;
  }

  Future<String?> _getIpPingValue(String url) async {
    return ChannelWallet.getAvgRTT(url);
  }

  Widget _buildNodeWidget(String nodeType, NodeModel? model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _clickAt(model),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: OffsetWidget.setSc(27),
              right: OffsetWidget.setSc(27),
            ),
            height: OffsetWidget.setSc(40),
            child: Text(
              nodeType,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: OffsetWidget.setSp(14),
                  fontWeight: FontWightHelper.regular),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: OffsetWidget.setSc(70),
            decoration: BoxDecoration(
              color: ColorUtils.rgba(73, 73, 73, 0.29),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(
              left: OffsetWidget.setSc(11),
              right: OffsetWidget.setSc(11),
            ),
            padding: EdgeInsets.only(
              left: OffsetWidget.setSc(15),
              right: OffsetWidget.setSc(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: OffsetWidget.setSc(180),
                  child: Text(
                    model?.content ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorUtils.rgba(153, 153, 153, 1),
                        fontSize: OffsetWidget.setSp(14),
                        fontWeight: FontWightHelper.regular),
                  ),
                ),
                FutureBuilder(
                  future: _getIpPingValue(model?.content ?? ""),
                  initialData: "0",
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    String ping = snapshot.data;
                    return Text(ping + "ms",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: OffsetWidget.setSp(12),
                            fontWeight: FontWightHelper.semiBold,
                            color: Colors.white));
                  },
                ),
                Container(
                  width: OffsetWidget.setSc(22),
                  child: Visibility(
                    visible: model?.isChoose ?? false,
                    child: LoadAssetsImage(
                        Constant.ASSETS_IMG + "icon/icon_node_choose.png",
                        width: 18,
                        height: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(NodeModel nodeModel) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _clickAt(nodeModel),
      },
      child: Container(
        alignment: Alignment.center,
        height: OffsetWidget.setSc(70),
        decoration: BoxDecoration(
          color: ColorUtils.rgba(73, 73, 73, 0.29),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(
            left: OffsetWidget.setSc(16),
            right: OffsetWidget.setSc(16),
            top: OffsetWidget.setSc(15)),
        padding: EdgeInsets.only(
          left: OffsetWidget.setSc(11),
          right: OffsetWidget.setSc(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: OffsetWidget.setSc(180),
              child: Text(
                nodeModel.content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xFFACBBCF),
                    fontSize: OffsetWidget.setSp(14),
                    fontWeight: FontWightHelper.regular),
              ),
            ),
            FutureBuilder(
              future: _getIpPingValue(nodeModel.content),
              initialData: "0",
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                String ping = snapshot.data;
                return Text(ping + "ms",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(16),
                        fontWeight: FontWightHelper.semiBold,
                        color: Colors.white));
              },
            ),
            Container(
              width: OffsetWidget.setSc(22),
              child: Visibility(
                visible: nodeModel.isChoose,
                child: LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_node_choose.png",
                    width: 18,
                    height: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNode() {
    ShowCustomAlert.showCustomAlertType(
      context,
      alertType: AlertType.node,
      title: "node_add_custom".local(),
      rightButtonColor: ColorUtils.fromHex("#FD5852"),
      confirmPressed: (map) async {
        String str = map['str'];
        String chainId = map['chainId'];

        if (!StringUtil.isValidIp(str.replaceAll("https://", "")) &&
            !StringUtil.isValidIpAndPort(str.replaceAll("https://", "")) &&
            !StringUtil.isValidUrl(str)) {
          HWToast.showText(text: "node_error".local());
          return;
        }
        HWToast.showLoading();
        ChainServices.requestETHRpc(
            chainType: MCoinType.MCoinType_ETH.index,
            url: str,
            paramas: [
              {
                "jsonrpc": "2.0",
                "method": "net_version",
                "params": [],
                "id": "v"
              }
            ],
            block: (result, code) async {
              HWToast.hiddenAllToast();
              if (code == 200 && result is List) {
                for (var element in result) {
                  if (element is Map == true) {
                    Map params = element;
                    if (params.keys.contains("result")) {
                      String? id = params["id"] as String?;
                      String? netversion = params["result"] as String?;
                      if (chainId == netversion) {
                        if (StringUtil.isNotEmpty(str) && str != "https://") {
                          List<NodeModel>? nodes =
                              await NodeModel.queryNodeByContentAndChainType(
                                  str, chainType);
                          if (nodes != null && nodes.length > 0) {
                            HWToast.showText(text: "node_exists".local());
                          } else {
                            bool isMain = netversion == "1" ? true : false;
                            NodeModel node = NodeModel(str, chainType, false,
                                false, isMain, int.parse(chainId));
                            bool flag = await NodeModel.insertNodeData(node);
                            if (flag) {
                              Navigator.pop(context);
                              setState(() {});
                            }
                          }
                        } else {
                          HWToast.showText(text: "node_add_input".local());
                        }
                      } else {
                        HWToast.showText(text: "node_chainiderr".local());
                      }
                    }
                  }
                }
              } else {
                HWToast.showText(text: "node_chainiderr".local());
              }
            });
      },
    );
  }

  _clickAt(NodeModel? nodeModel) async {
    List<NodeModel> cacheDatas = [];
    cacheDatas.addAll(customDatas);
    if (defaultTestnet != null) {
      cacheDatas.add(defaultTestnet!);
    }
    if (defaultMainnet != null) {
      cacheDatas.add(defaultMainnet!);
    }
    cacheDatas.forEach((element) {
      element.isChoose = false;
      if (element.content == nodeModel?.content &&
          element.chainType == nodeModel?.chainType) {
        element.isChoose = true;
      }
    });

    if (cacheDatas.length > 0) {
      bool flag = await NodeModel.updateNodes(cacheDatas);
      if (flag) {
        setState(() {});
      }
    }
    Constant.eventBus.fire(NodeSwitch());
    Provider.of<MNodeState>(context, listen: false).updateNode(nodeModel!);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenScrollView: true,
      hiddenResizeToAvoidBottomInset: false,
      title: CustomPageView.getDefaultTitle(titleStr: "nodelist_title".local()),
      child: Column(
        children: [
          _buildNodeWidget("Mainnet", defaultMainnet),
          _buildNodeWidget("Testnet", defaultTestnet),
          Container(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(50),
                left: OffsetWidget.setSc(27),
                right: OffsetWidget.setSc(27)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Custon Node",
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(14),
                      color: Colors.white),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _addNode();
                  },
                  child: LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/icon_node_add.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customDatas.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCell(customDatas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
