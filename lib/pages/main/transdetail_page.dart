import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../public.dart';

class TransDetailPage extends StatefulWidget {
  TransDetailPage({Key? key, this.params}) : super(key: key);

  final Map? params;

  @override
  _TransDetailPageState createState() => _TransDetailPageState();
}

class _TransDetailPageState extends State<TransDetailPage> {
  static const String leftKey = "leftKey";
  static const String rightKey = "rightKey";
  TransRecordModel? transMdel;
  List<Map> cellDatas = [];
  String value = "";
  String assets = "";
  String price = "";

  @override
  void initState() {
    super.initState();

    if (widget.params != null) {
      initData();
    }
  }

  void initData() async {
    String txid = widget.params!["txid"][0];
    transMdel = (await TransRecordModel.queryTrxFromTrxid(txid)).first;
    if (transMdel == null) {
      return;
    }
    setState(() {
      value = transMdel!.amount! + " " + transMdel!.symbol!;
      cellDatas = [
        {
          leftKey: "transdetail_fee".local(),
          rightKey: (transMdel?.fee ?? "0.00") + "ETH",
        },
        {
          leftKey: "paymentdetail_fromaddress".local(),
          rightKey: transMdel!.fromAdd ??= "",
        },
        {
          leftKey: "paymentdetail_toaddress".local(),
          rightKey: transMdel!.toAdd ??= "",
        },
        {
          leftKey: "paymentdetail_chaintxid".local(),
          rightKey: transMdel!.txid ??= "",
          "color": 0xFF1308FE
        },
        {
          leftKey: "paymentdetail_time".local(),
          rightKey: transMdel!.date ??= "",
        },
      ];
    });
  }

  Widget buildCell(Map params) {
    return Container(
      height: OffsetWidget.setSc(67),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorUtils.rgba(50, 55, 85, 1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: OffsetWidget.setSc(80),
            child: Text(params[leftKey],
                maxLines: 2,
                style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(14),
                  fontWeight: FontWeight.w400,
                )),
          ),
          OffsetWidget.hGap(22),
          Expanded(
            child: Text(params[rightKey],
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: OffsetWidget.setSp(14),
                  fontWeight: FontWeight.w400,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(
        titleStr: "trans_detail".local(),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: OffsetWidget.setSc(19),
          right: OffsetWidget.setSc(14),
        ),
        child: cellDatas.length == 0
            ? EmptyDataPage(
                emptyTip: "empay_datano",
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: transMdel!.transStatus ==
                            MTransState.MTransState_Success.index
                        ? LoadAssetsImage(
                            Constant.ASSETS_IMG +
                                "icon/trans_state_success.png",
                            width: 30,
                            height: 30,
                          )
                        : transMdel!.transStatus ==
                                MTransState.MTransState_Failere.index
                            ? LoadAssetsImage(
                                Constant.ASSETS_IMG +
                                    "icon/trans_state_failere.png",
                                width: 30,
                                height: 30,
                              )
                            : Text(
                                "transdetail_pending".local(),
                                style: TextStyle(
                                  color: ColorUtils.rgba(254, 163, 28, 1),
                                  fontSize: OffsetWidget.setSp(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: OffsetWidget.setSc(20),
                        bottom: OffsetWidget.setSc(10)),
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: OffsetWidget.setSp(16),
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    children: cellDatas.map((e) => buildCell(e)).toList(),
                  ),
                  OffsetWidget.vGap(28),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NodeModel? node =
                          Provider.of<MNodeState>(context, listen: false)
                              .currentNode;
                      String url = "";
                      if (node?.isMainnet == true) {
                        url = "https://cn.etherscan.com/tx/" +
                            widget.params!["txid"][0];
                      } else {
                        url = "https://rinkeby.etherscan.io/tx/" +
                            widget.params!["txid"][0];
                      }
                      launch(url);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View transaction details",
                          style: TextStyle(
                              color: ColorUtils.rgba(78, 108, 220, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: OffsetWidget.setSp(14)),
                        ),
                        OffsetWidget.hGap(8),
                        LoadAssetsImage(
                          Constant.ASSETS_IMG + "icon/icon_share.png",
                          width: 16,
                          height: 16,
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
