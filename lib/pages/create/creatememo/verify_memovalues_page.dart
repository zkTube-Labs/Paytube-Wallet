import 'dart:ffi';
import 'dart:math';

import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/date_util.dart';
import 'package:flutter_coinid/utils/screenutil.dart';

class MemoObject {
  String value;
  bool state;

  MemoObject(this.value, this.state);
}

class VerifyMemoPage extends StatefulWidget {
  VerifyMemoPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();
  @override
  _VerifyMemoPageState createState() => _VerifyMemoPageState();
}

class _VerifyMemoPageState extends State<VerifyMemoPage> {
  List<MemoObject> verifiedList = []; //已经验证的
  List<MemoObject> verifingList = []; //正在验证的
  List? walletName = [];
  List? password = [];
  List? pwdTip = [];
  List? memoType = [];
  List<String>? originList = [];
  bool isBackUp = false;
  @override
  void initState() {
    super.initState();
    List list = widget.params!["paramsLists"];
    walletName = widget.params!["walletName"];
    password = widget.params!["password"];
    pwdTip = widget.params!["pwdTip"];
    memoType = widget.params!["memoType"];
    originList = widget.params!["paramsLists"];
    isBackUp = (widget.params!["isBackUp"][0]) == "true" ? true : false;
    verifingList = [];
    verifingList.addAll(list.map((e) => MemoObject(e, false)).toList());
    verifingList.shuffle(Random());
  }

  _createWallets() async {
    bool memoState = false;
    if (originList!.length == verifiedList.length) {
      for (var i = 0; i < originList!.length; i++) {
        MemoObject object = verifiedList[i];
        if (object.value != originList![i]) {
          memoState = false;
          break;
        } else {
          memoState = true;
        }
      }
    }
    if (memoState == false) {
      HWToast.showText(text: "create_verifyerrtip".local());
      return;
    }
    if (isBackUp == true) {
      HWToast.showText(text: "create_verifyok".local());
      Future.delayed(Duration(seconds: 1)).then((value) => {
            Routers.push(context, Routers.tabbarPage, clearStack: true),
          });
      return;
    }
    String content = originList!.join(" ");
    String pwd = password![0];
    String name = walletName![0];
    String tip = pwdTip![0];
    MLeadType leadType = MLeadType.MLeadType_StandardMemo;
    if (name.length == 0) {
      HWToast.showText(text: "input_name".local());
      return;
    }
    // if (pwd.checkPassword() == false) {
    //   HWToast.showText(text: "input_pwd_regexp".local());
    //   return;
    // }
    HWToast.showLoading(
      clickClose: false,
    );
    MStatusCode v = await MHWallet.importWallet(
        content: content,
        pin: pwd,
        pintip: tip,
        walletName: name,
        mCoinType: MCoinType.MCoinType_ETH,
        mLeadType: leadType,
        mOriginType: MOriginType.MOriginType_Create);
    if (v == MStatusCode.MStatusCode_Success) {
      HWToast.hiddenAllToast();
      Routers.push(context, Routers.tabbarPage, clearStack: true);
    } else {
      if (v == MStatusCode.MStatusCode_Exist) {
        HWToast.showText(text: "input_wallet_exist".local());
      } else if (v == MStatusCode.MStatusCode_MemoInvalid) {
        HWToast.showText(text: "input_memo_wrong".local());
      } else {
        HWToast.showText(text: "wallet_create_err".local());
      }
    }
  }

  Widget _getVerifyMemoContentWidget() {
    Map? params = widget.params;
    if (params == null) {
      return Text("data");
    }
    List<Widget> singleTexts = [];
    for (MemoObject item in verifiedList) {
      singleTexts.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _verifyWidgetItemAction(item);
          },
          child: Container(
            height: OffsetWidget.setSc(32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorUtils.rgba(222, 224, 223, 1),
                    fontSize: OffsetWidget.setSp(14),
                    fontWeight: FontWightHelper.regular,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(minHeight: OffsetWidget.setSc(187)),
      padding: EdgeInsets.all(OffsetWidget.setSc(10)),
      margin: EdgeInsets.only(top: OffsetWidget.setSc(32)),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: ColorUtils.rgba(73, 73, 73, 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 12.0,
        children: singleTexts,
      ),
    );
  }

  void _verifyWidgetItemAction(MemoObject item) {
    setState(() {
      verifiedList.remove(item);
      item.state = false;
    });
  }

  Widget _getMemoContentWidget() {
    Map? params = widget.params;
    if (params == null) {
      return Text("data");
    }
    List<Widget> singleTexts = [];
    for (MemoObject memo in verifingList) {
      String value = memo.value;
      bool state = memo.state;
      singleTexts.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (state == false) {
              _contentWidgetItemAction(memo);
            }
          },
          child: Container(
            height: OffsetWidget.setSc(32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state == true
                        ? Colors.transparent
                        : ColorUtils.rgba(222, 224, 223, 1),
                    fontSize: OffsetWidget.setSp(14),
                    fontWeight: FontWightHelper.regular,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return verifingList.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: OffsetWidget.setSc(32)),
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 12.0,
              children: singleTexts,
            ),
          );
  }

  void _contentWidgetItemAction(MemoObject item) {
    setState(() {
      item.state = true;
      verifiedList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      // hiddenScrollView: true,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(16),
            right: OffsetWidget.setSc(16),
            bottom: OffsetWidget.setSc(83),
            top: OffsetWidget.setSc(27)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                LoadAssetsImage(
                  Constant.ASSETS_IMG + "icon/icon_backmemo.png",
                  width: 32,
                  height: 32,
                ),
                OffsetWidget.vGap(3),
                Text(
                  "Confirm Recovery code",
                  style: TextStyle(
                    color: ColorUtils.rgba(255, 255, 255, 1),
                    fontSize: OffsetWidget.setSp(16),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: OffsetWidget.setSc(83)),
                  child: Text(
                    "create_verifymemodesc".local(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontSize: OffsetWidget.setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                _getVerifyMemoContentWidget(),
                _getMemoContentWidget(),
              ],
            ),
            GestureDetector(
              onTap: () => _createWallets(),
              child: Container(
                height: OffsetWidget.setSc(46),
                margin: EdgeInsets.only(
                    top: OffsetWidget.setSc(20),
                    left: OffsetWidget.setSc(20),
                    right: OffsetWidget.setSc(20)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorUtils.rgba(78, 108, 220, 1)),
                child: Text(
                  "wallet_complete".local(),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(20),
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
