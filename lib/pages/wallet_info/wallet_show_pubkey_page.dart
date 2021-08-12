import '../../public.dart';

class WalletShowPubKeyPage extends StatefulWidget {
  WalletShowPubKeyPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _WalletShowPubKeyPageState createState() => _WalletShowPubKeyPageState();
}

class _WalletShowPubKeyPageState extends State<WalletShowPubKeyPage> {
  String? active = "";
  String? owner = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.params != null) {
      active = widget.params!["active"][0];
      owner = widget.params!["owner"][0];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      hiddenResizeToAvoidBottomInset: false,
      title: Text(
        "wallet_show_pub".local(),
        style: TextStyle(
            fontSize: OffsetWidget.setSp(17), color: Color(0xFF4A4A4A)),
      ),
      child: Column(
        children: [
          Container(
            width: OffsetWidget.setSc(360),
            margin: EdgeInsets.fromLTRB(
                OffsetWidget.setSc(32),
                OffsetWidget.setSc(22),
                OffsetWidget.setSc(32),
                OffsetWidget.setSc(8)),
            child: Text(
              "wallet_owner".local(),
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(12), color: Color(0xFF586883)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              color: Color(0xFFFFFBC8),
              width: OffsetWidget.setSc(322),
              height: OffsetWidget.setSc(53),
              padding: EdgeInsets.fromLTRB(
                  OffsetWidget.setSc(13),
                  OffsetWidget.setSc(11),
                  OffsetWidget.setSc(13),
                  OffsetWidget.setSc(12)),
              child: Text(
                owner!,
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(11), color: Color(0xFF586883)),
              ),
            ),
          ),
          Container(
            width: OffsetWidget.setSc(360),
            margin: EdgeInsets.fromLTRB(
                OffsetWidget.setSc(32),
                OffsetWidget.setSc(22),
                OffsetWidget.setSc(32),
                OffsetWidget.setSc(8)),
            child: Text(
              "wallet_active".local(),
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(12), color: Color(0xFF586883)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              color: Color(0xFFFFFBC8),
              width: OffsetWidget.setSc(322),
              height: OffsetWidget.setSc(53),
              padding: EdgeInsets.fromLTRB(
                  OffsetWidget.setSc(13),
                  OffsetWidget.setSc(11),
                  OffsetWidget.setSc(13),
                  OffsetWidget.setSc(12)),
              child: Text(
                active!,
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(11), color: Color(0xFF586883)),
              ),
            ),
          ),
          OffsetWidget.vGap(29),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              color: Color(0xFFF6F9FC),
              width: OffsetWidget.setSc(322),
              padding: EdgeInsets.only(
                  left: OffsetWidget.setSc(13),
                  top: OffsetWidget.setSc(6),
                  right: OffsetWidget.setSc(13),
                  bottom: OffsetWidget.setSc(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "wallet_pub_description1".local(),
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(11),
                        color: Color(0xFF586883)),
                  ),
                  Text(
                    "wallet_pub_description2".local(),
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(11),
                        color: Color(0xFF586883)),
                  ),
                  Text(
                    "wallet_pub_description3".local(),
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(11),
                        color: Color(0xFFACBBCF)),
                  ),
                  Text(
                    "wallet_pub_description4".local(),
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(11),
                        color: Color(0xFFACBBCF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
