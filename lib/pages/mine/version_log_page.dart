import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';

import '../../public.dart';

class VersionLogPage extends StatefulWidget {
  @override
  _VersionLogPageState createState() => _VersionLogPageState();
}

class _VersionLogPageState extends State<VersionLogPage> {
  List<Map<String, dynamic>> datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String appType = "android";
    if (Constant.isAndroid) {
      appType = "android";
    } else if (Constant.isIOS) {
      appType = "ios";
    }

    WalletServices.requestVersionLog(appType, (result, code) {
      if (code == 200 && mounted) {
        setState(() {
          datas.addAll(result);
        });
      }
    });
  }

  Widget _buildCell(int index) {
    Map<String, dynamic> map = datas[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Color(0xFFF6F9FC),
      ),
      margin: EdgeInsets.symmetric(horizontal: OffsetWidget.setSc(14)),
      padding: EdgeInsets.symmetric(
          horizontal: OffsetWidget.setSc(14), vertical: OffsetWidget.setSc(14)),
      width: OffsetWidget.setSc(360),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                map["version"],
                style: TextStyle(
                  fontSize: OffsetWidget.setSp(12),
                  color: Color(0xf6f9fc),
                ),
              ),
              // Text(
              //   map["createTime"],
              //   style: TextStyle(
              //     fontSize: OffsetWidget.setSp(12),
              //     color: Color(0x80FFFFFF),
              //   ),
              // ),
            ],
          ),
          OffsetWidget.vGap(10),
          Text(
            map["description"],
            style: TextStyle(
              fontSize: OffsetWidget.setSp(10),
              color: Color(0xFF586883),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      hiddenScrollView: true,
      title: Text("about_ver_log".local(),
          style: TextStyle(
              fontSize: OffsetWidget.setSp(17), color: Color(0xFF4A4A4A))),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _buildCell(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return OffsetWidget.vGap(10);
          },
          itemCount: datas.length),
    );
  }
}
