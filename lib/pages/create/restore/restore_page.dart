import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/routers/router_handler.dart';
import 'package:flutter_coinid/utils/date_util.dart';

import '../../../public.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_coinid/widgets/custom_pageview.dart';

class RestorePage extends StatefulWidget {
  RestorePage({Key? key}) : super(key: key);

  @override
  _RestorePageState createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> {
  MLeadType memoType = MLeadType.MLeadType_StandardMemo; //当前默认通用
  final TextEditingController _memoEC = TextEditingController();
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _pwdEC = TextEditingController();
  final TextEditingController _pwdAgantEC = TextEditingController();
  final TextEditingController _pwdTipEC = TextEditingController();
  EdgeInsets padding = EdgeInsets.only(
      left: OffsetWidget.setSc(20) ,
      right: OffsetWidget.setSc(20) ,
      top: OffsetWidget.setSc(20) );
  EdgeInsets contentPadding = EdgeInsets.only(left: 0, right: 0);
  bool eyeisOpen = false;
  bool isAgreement = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _memoEC.dispose();
    _nameEC.dispose();
    _pwdEC.dispose();
    _pwdAgantEC.dispose();
    _pwdTipEC.dispose();
    super.dispose();
  }

  void updateEyesState() {
    setState(() {
      eyeisOpen = !eyeisOpen;
    });
  }

  void updateAgreement() {
    setState(() {
      isAgreement = !isAgreement;
    });
  }

  void jumpToAgreement() async {
    LogUtil.v("jumpToAgreement");
    String? path = await Constant.getAgreementPath();
    Routers.push(context, Routers.pdfScreen, params: {"path": path});
  }

  _restoreWallets() async {
    String content = _memoEC.text.trim();
    String pwd = _pwdEC.text.trim();
    String pwdagain = _pwdAgantEC.text.trim();
    String name = _nameEC.text.trim();
    String tip = _pwdTipEC.text.trim();
    if (content.length == 0) {
      HWToast.showText(text: "input_memos".local());
      return;
    }
    if (name.length == 0) {
      HWToast.showText(text: "input_name".local());
      return;
    }
    if (pwd.length == 0 || pwdagain.length == 0) {
      HWToast.showText(text: "input_pwd".local());
      return;
    }
    if (pwd != pwdagain) {
      HWToast.showText(text: "input_pwd_wrong".local());
      return;
    }
    if (pwd.checkPassword() == false) {
      HWToast.showText(text: "input_pwd_regexp".local());
      return;
    }
    if (isAgreement == false) {
      HWToast.showText(text: "import_readagreement".local());
      return;
    }
    //验证文本内容
    //验证密码  是否一致，是否符合规则
    //验证助记词 CoinID_checkMemoValid

    HWToast.showLoading(
      clickClose: false,
    );
    MStatusCode v = await MHWallet.importWallet(
        content: content,
        pin: pwd,
        pintip: tip,
        walletName: name,
        mCoinType: MCoinType.MCoinType_ETH,
        mLeadType: memoType,
        mOriginType: MOriginType.MOriginType_Restore);
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

  Widget _getInputTextField({
    TextEditingController? controller,
    String? hintText,
    required String titleText,
    bool obscureText = false,
    EdgeInsetsGeometry padding = const EdgeInsets.only(top: 22),
    int? maxLength,
  }) {
    return Padding(
        padding: padding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  titleText,
                  style: TextStyle(
                      color: Color(0xFF161D2D),
                      fontSize: OffsetWidget.setSp(15) ,
                      fontWeight: FontWightHelper.regular),
                ),
              ),
              CustomTextField(
                controller: controller,
                obscureText: obscureText,
                maxLength: maxLength,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: OffsetWidget.setSp(15) ,
                  fontWeight: FontWightHelper.regular,
                ),
                decoration: CustomTextField.getUnderLineDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Color(0xFFACBBCF),
                    fontSize: OffsetWidget.setSp(15) ,
                    fontWeight: FontWightHelper.regular,
                  ),
                ),
              ),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(
        titleStr: "restore_wallet".local(),
      ),
      child: Container(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(20) ,
            right: OffsetWidget.setSc(20) ,
            top: OffsetWidget.setSc(27) ),
        child: Column(
          children: <Widget>[
            Container(
              height: OffsetWidget.setSc(106) ,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF6F8F9),
                border: Border.all(
                  color: Color(0XFFEFF3F5),
                ),
              ),
              child: CustomTextField(
                controller: _memoEC,
                maxLines: 3,
                style: TextStyle(
                  color: Color(0xFF161D2D),
                  fontSize: OffsetWidget.setSp(16) ,
                  fontWeight: FontWightHelper.regular,
                ),
                decoration: CustomTextField.getBorderLineDecoration(
                  hintText: "import_plainmemo".local(),
                  fillColor: Color(0xFFF6F8F9),
                  borderColor: Colors.transparent,
                  contentPadding: EdgeInsets.only(
                    left: OffsetWidget.setSc(10) ,
                    right: OffsetWidget.setSc(10) ,
                    top: OffsetWidget.setSc(8) ,
                  ),
                  helperStyle: TextStyle(
                    color: Color(0xFF171F24),
                    fontWeight: FontWightHelper.regular,
                    fontSize: OffsetWidget.setSp(12) ,
                  ),
                  hintStyle: TextStyle(
                      color: Color(0xFFACBBCF),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(18) ),
                ),
              ),
            ),
            _getInputTextField(
                controller: _nameEC,
                hintText: "import_walletname".local(),
                titleText: "wallet_name".local(),
                maxLength: 25,
                padding: EdgeInsets.only(top: 14)),
            _getInputTextField(
              controller: _pwdEC,
              obscureText: !eyeisOpen,
              hintText: "import_pwddetail".local(),
              titleText: "import_pwd".local(),
            ),
            _getInputTextField(
              controller: _pwdAgantEC,
              obscureText: !eyeisOpen,
              hintText: "confirm_password".local(),
              titleText: "import_pwdagain".local(),
            ),
            _getInputTextField(
              controller: _pwdTipEC,
              hintText: "import_pwddesc".local(),
              titleText: "wallet_update_tip_title".local(),
            ),
            GestureDetector(
              onTap: jumpToAgreement,
              child: Container(
                padding: EdgeInsets.only(
                    top: OffsetWidget.setSc(36) ,
                    // left: OffsetWidget.setSc(20),
                    right: OffsetWidget.setSc(20) ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: updateAgreement,
                      child: Image.asset(
                        isAgreement == false
                            ? Constant.ASSETS_IMG + "icon/icon_unselect.png"
                            : Constant.ASSETS_IMG + "icon/icon_select.png",
                        fit: BoxFit.cover,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    OffsetWidget.hGap(5),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: OffsetWidget.setSc(300) ),
                      child: RichText(
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'readagrementinfo'.local(),
                          style: TextStyle(
                            color: Color(0xFF979797),
                            fontSize: OffsetWidget.setSp(12) ,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'agrementinfo'.local(),
                                style: TextStyle(
                                  color: Color(0xFF4A4A4A),
                                  fontSize: OffsetWidget.setSp(13) ,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            OffsetWidget.vGap(24),
            GestureDetector(
              onTap: _restoreWallets,
              child: Container(
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(42) ,
                    top: OffsetWidget.setSc(36) ,
                    right: OffsetWidget.setSc(42) ),
                height: OffsetWidget.setSc(40) ,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF586883)),
                child: Text(
                  "restore_data".local(),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(15) ,
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
