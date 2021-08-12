import '../../public.dart';

class MsgSystemDetailPage extends StatefulWidget {
  MsgSystemDetailPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _MsgSystemDetailPageState createState() => _MsgSystemDetailPageState();
}

class _MsgSystemDetailPageState extends State<MsgSystemDetailPage> {
  String? title;
  String? content;
  String? team;
  String? date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.params != null) {
      title = widget.params!["title"][0];
      content = widget.params!["content"][0];
      team = widget.params!["team"][0];
      date = widget.params!["date"][0];
    }
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      title: Text("msg_title".local(),
          style: TextStyle(
              fontSize: OffsetWidget.setSp(17), color: Color(0xFF4A4A4A))),
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              OffsetWidget.setSc(12),
              OffsetWidget.setSc(19),
              OffsetWidget.setSc(15),
              OffsetWidget.setSc(8)),
          width: OffsetWidget.setSc(322),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFF6F9FC),
          ),
          child: Column(
            children: [
              Container(
                width: OffsetWidget.setSc(290),
                child: Text(title!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(13),
                        color: Color(0xFF586883))),
              ),
              OffsetWidget.vGap(9),
              Text(content!,
                  style: TextStyle(
                      fontSize: OffsetWidget.setSp(10),
                      color: Color(0xFF586883))),
              OffsetWidget.vGap(21),
              Container(
                width: OffsetWidget.setSc(290),
                child: Text(team!,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(10),
                        color: Color(0xFF586883))),
              ),
              OffsetWidget.vGap(4),
              Container(
                width: OffsetWidget.setSc(290),
                child: Text(DateUtil.formatDateMs(int.parse(date!)),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(8),
                        color: Color(0xFFACBBCF))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
