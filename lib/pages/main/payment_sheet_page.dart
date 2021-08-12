import '../../public.dart';

class PaymentSheetText {
  String? title;
  TextStyle? titleStyle;
  String? content;
  TextStyle? contentStyle;

  PaymentSheetText({
    this.title,
    this.content,
    this.contentStyle,
    this.titleStyle,
  });
}

class PaymentSheet extends StatefulWidget {
  PaymentSheet({Key? key, required this.datas, required this.nextAction})
      : super(key: key);

  final List<PaymentSheetText> datas;
  final VoidCallback nextAction;

  @override
  _PaymentSheetState createState() => _PaymentSheetState();

  static List<PaymentSheetText> getTransStyleList(
      {String? from = "",
      String to = "",
      String? amount = "",
      String remark = "",
      String? fee = ""}) {
    TextStyle title = TextStyle(
      color: ColorUtils.rgba(153, 153, 153, 1),
      fontSize: OffsetWidget.setSp(14),
      fontWeight: FontWeight.w400,
    );
    TextStyle content = TextStyle(
      color: Color(0xFFffffff),
      fontSize: OffsetWidget.setSp(14),
      fontWeight: FontWeight.w400,
    );

    List<PaymentSheetText> datas = [
      PaymentSheetText(
          title: "payment_transtype".local(),
          content: "payment_transtout".local(),
          titleStyle: title,
          contentStyle: content),
      PaymentSheetText(
          title: "payment_fromaddress".local(),
          content: from,
          titleStyle: title,
          contentStyle: content),
      PaymentSheetText(
          title: "payment_toaddress".local(),
          content: to,
          titleStyle: title,
          contentStyle: content),
      PaymentSheetText(
          title: "payment_value".local(),
          content: amount,
          titleStyle: title,
          contentStyle: content),
      PaymentSheetText(
          title: "payment_remark".local(),
          content: remark,
          titleStyle: title,
          contentStyle: content),
      PaymentSheetText(
          title: "payment_fee".local(),
          content: fee,
          titleStyle: title,
          contentStyle: content),
    ];

    return datas;
  }
}

class _PaymentSheetState extends State<PaymentSheet> {
  void _next() {
    Navigator.pop(context);
    widget.nextAction();
  }

  void sheetClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return Container(
      height: OffsetWidget.setSc(470),
      padding: EdgeInsets.only(
          top: OffsetWidget.setSc(30),
          left: OffsetWidget.setSc(14),
          right: OffsetWidget.setSc(14),
          bottom: OffsetWidget.setSc(35)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "".local(),
              ),
              Text(
                "paymentsheep_info".local(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: OffsetWidget.setSp(16),
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {sheetClose()},
                child: LoadAssetsImage(
                  Constant.ASSETS_IMG + "icon/icon_close.png",
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          OffsetWidget.vGap(43),
          Expanded(
            child: ListView.builder(
              itemCount: widget.datas.length,
              itemBuilder: (BuildContext context, int index) {
                PaymentSheetText sheet = widget.datas[index];
                return Container(
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    border: Border(
                      bottom: BorderSide(
                        color: ColorUtils.rgba(50, 55, 85, 1),
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  constraints:
                      BoxConstraints(minHeight: OffsetWidget.setSc(58)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: OffsetWidget.setSc(72),
                        child: Text(sheet.title!, style: sheet.titleStyle),
                      ),
                      OffsetWidget.hGap(21),
                      Expanded(
                        child: Text(sheet.content!, style: sheet.contentStyle),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
              onTap: _next,
              child: Container(
                height: OffsetWidget.setSc(46),
                margin: EdgeInsets.only(
                  top: OffsetWidget.setSc(26),
                  left: OffsetWidget.setSc(20),
                  right: OffsetWidget.setSc(20),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorUtils.rgba(78, 108, 220, 1)),
                child: Text(
                  "comfirm_trans".local(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: OffsetWidget.setSp(20),
                      color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
