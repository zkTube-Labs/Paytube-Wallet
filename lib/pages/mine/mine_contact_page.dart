import 'dart:ffi';

import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/contacts/contact_address.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/pages/mine/msg_trans_page.dart';

import '../../public.dart';
import 'msg_system_page.dart';

class MineContact extends StatefulWidget {
  final String? state;

  const MineContact({Key? key, this.state}) : super(key: key);
  @override
  _MineContactState createState() => _MineContactState();
}

class _MineContactState extends State<MineContact> {
  List<ContactAddress> datas = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    datas = await ContactAddress.findAddressType(MCoinType.MCoinType_ETH.index);
    setState(() {});
  }

  void tapNewAdds() {
    Routers.push(context, Routers.mineAddContact).then((value) => {
          initData(),
        });
  }

  Widget _buildCell(int index) {
    ContactAddress model = datas[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.state == "payment") {
          Routers.goBackWithParams(context, model.toJson());
        }
      },
      child: Container(
        height: OffsetWidget.setSc(55),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.name,
              style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12),
                  fontWeight: FontWightHelper.regular),
            ),
            OffsetWidget.vGap(5),
            Row(
              children: <Widget>[
                Text(
                  model.address,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: OffsetWidget.setSp(12),
                      fontWeight: FontWightHelper.semiBold),
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
    return CustomPageView(
      hiddenScrollView: true,
      title: CustomPageView.getDefaultTitle(titleStr: "wallet_contact".local()),
      child: Column(
        children: [
          Expanded(
            child: datas.length == 0
                ? EmptyDataPage(
                    emptyTip: "empay_datano",
                  )
                : ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCell(index);
                    },
                  ),
          ),
          GestureDetector(
            onTap: tapNewAdds,
            child: Container(
              height: OffsetWidget.setSc(46),
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  bottom: OffsetWidget.setSc(81),
                  left: OffsetWidget.setSc(36),
                  right: OffsetWidget.setSc(36)),
              decoration: BoxDecoration(
                color: ColorUtils.rgba(78, 108, 220, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "wallet_addcontact".local(),
                style: TextStyle(
                    fontWeight: FontWightHelper.semiBold,
                    fontSize: OffsetWidget.setSp(20),
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
