import 'package:flutter_coinid/channel/channel_memo.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/screenutil.dart';

class BackupMemoPage extends StatefulWidget {
  BackupMemoPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _BackupMemoPageState createState() => _BackupMemoPageState();
}

// column
//img
//text
//text
//memos
//row 中文助记词 英文助记词
//row 通用助记词 Coinid专用助记词
class _BackupMemoPageState extends State<BackupMemoPage> {
  int memoLanguageType = 1; //当前中文 还是英文
  int memoType = 0; //当前通用 还是专用
  bool isBackUp = false; //是否是备份
  ChannelMemosObjects? memoObjects;
  @override
  void initState() {
    super.initState();
    _getMemosValue();
  }

  Future<void> _getMemosValue() async {
    try {
      if (widget.params!.containsKey("memoCount") == true) {
        String? memoCount = "";
        memoCount = widget.params!["memoCount"][0];
        MemoCount count =
            MemoCount.values.firstWhere((e) => e.toString() == memoCount);
        ChannelMemosObjects objects =
            await ChannelMemos.createWalletMemo(count);
        setState(() {
          isBackUp = false;
          memoObjects = objects;
        });
      } else {
        String? memo = "";
        int? leadType = 0;
        memo = widget.params!["memo"][0];
        leadType = int.tryParse((widget.params!["leadType"][0]));
        ChannelMemosObjects object = ChannelMemosObjects();
        object.enStandMemos = memo!.split(" ");
        memoType = 0;
        setState(() {
          isBackUp = true;
          memoObjects = object;
        });
      }
    } catch (e) {
      print("_getMemosValue " + e.toString());
    }
  }

  List<dynamic> _getMemoContents(int language, int type) {
    LogUtil.v("_getMemoContents language $language type $type");
    LogUtil.v("memoObjects  " + memoObjects!.toJson().toString());
    List? values = [];
    if (memoLanguageType == 0 && memoType == 0) {
      values = memoObjects!.cnStandMemos;
    }
    if (memoLanguageType == 0 && memoType == 1) {
      values = memoObjects!.cnMemos;
    }
    if (memoLanguageType == 1 && memoType == 0) {
      values = memoObjects!.enStandMemos;
    }
    if (memoLanguageType == 1 && memoType == 1) {
      values = memoObjects!.enMemos;
    }
    return values ??= [];
  }

  void _nextPage() {
    Map<String, dynamic> object = Map.from(widget.params!);
    List<dynamic> paramsLists = _getMemoContents(memoLanguageType, memoType);
    object["paramsLists"] = paramsLists;
    object["memoLanguageType"] = memoLanguageType;
    object["memoType"] = memoType;
    object["isBackUp"] = isBackUp;
    Routers.push(context, Routers.verifyMemoPage, params: object);
  }

  Widget _getMemoContentWidget() {
    if (memoObjects == null) {
      return Text("data");
    }
    List values = [];
    values = _getMemoContents(memoLanguageType, memoType);
    List<Widget> singleTexts = [];
    for (String item in values) {
      singleTexts.add(
        Container(
          height: OffsetWidget.setSc(32) ,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorUtils.rgba(222, 224, 223, 1),
                  fontSize: OffsetWidget.setSp(14) ,
                  fontWeight: FontWightHelper.regular,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        LoadAssetsImage(
          Constant.ASSETS_IMG + "icon/icon_backmemo.png",
          width: 32,
          height: 32,
        ),
        OffsetWidget.vGap(3),
        Text(
          "Backup Recovery code",
          style: TextStyle(
            color: ColorUtils.rgba(255, 255, 255, 1),
            fontSize: OffsetWidget.setSp(16) ,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: OffsetWidget.setSc(83) ),
          child: Text(
            "create_backupmemodesc".local(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorUtils.rgba(153, 153, 153, 1),
              fontSize: OffsetWidget.setSp(12) ,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(OffsetWidget.setSc(10) ),
          margin: EdgeInsets.only(top: OffsetWidget.setSc(32) ),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: ColorUtils.rgba(73, 73, 73, 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: singleTexts,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenScrollView: true,
      child: Container(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(16) ,
            right: OffsetWidget.setSc(16) ,
            bottom: OffsetWidget.setSc(83) ,
            top: OffsetWidget.setSc(35) ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _getMemoContentWidget(),
            GestureDetector(
              onTap: _nextPage,
              child: Container(
                height: OffsetWidget.setSc(46) ,
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(20) ,
                    right: OffsetWidget.setSc(20) ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorUtils.rgba(78, 108, 220, 1)),
                child: Text(
                  "comfirm_trans".local(),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(20) ,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
