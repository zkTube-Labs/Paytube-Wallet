// import 'package:flutter_coinid/public.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/constant/constant.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/offset.dart';
import 'package:flutter_coinid/widgets/custom_pageview.dart';
import 'package:flutter_coinid/widgets/custom_textfield.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportPage extends StatefulWidget {
  ImportPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  MLeadType mLeadType = MLeadType.MLeadType_Prvkey; //导入钱包类型
  MCoinType? mcoinType = MCoinType.MCoinType_ETH; //链类型
  TextEditingController contentEC = TextEditingController(text: "");
  TextEditingController nameEC = TextEditingController();
  TextEditingController pwdEC = TextEditingController();
  TextEditingController pwdAganEC = TextEditingController();
  TextEditingController pwdTipEC = TextEditingController();
  EdgeInsets padding = EdgeInsets.only(
      left: OffsetWidget.setSc(20),
      right: OffsetWidget.setSc(20),
      top: OffsetWidget.setSc(20));
  EdgeInsets contentPadding = EdgeInsets.only(left: 0, right: 0);
  List<Tab> _myTabs = [];
  bool eyeisOpen1 = true; //密码框是否显示密码
  bool eyeisOpen2 = true; //重复密码框是否显示密码
  bool isAgreement = false;

  String _passwordHideIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_hide_light.png';
  String _passwordLightIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_light.png';
  @override
  void initState() {
    super.initState();
    mcoinType = Constant.getCoinType(widget.params!["coinType"][0]);
    LogUtil.v("initState coinType $mcoinType");
    _myTabs.add(Tab(text: 'import_prv'.local()));
    _myTabs.add(Tab(text: 'KeyStore'));
    _myTabs.add(Tab(text: 'import_memo'.local()));
    if (Constant.inProduction == false) {
      contentEC.text =
          "40730f5ddc6b492688ce3897b9ff54e582f6ad8243a90ece21b060a46db46b44";
      //contentEC.text =
      //"f335fb8d70f27351a2a20541464f87057112e3245efa8c119fc7a08742622044";
    }
  }

  @override
  void dispose() {
    contentEC.dispose();
    nameEC.dispose();
    pwdEC.dispose();
    pwdAganEC.dispose();
    pwdTipEC.dispose();
    super.dispose();
  }

  void updateAgreement() {
    setState(() {
      isAgreement = !isAgreement;
    });
  }

  void jumpToAgreement() async {
    LogUtil.v("jumpToAgreement");
    String? path = await Constant.getAgreementPath();
    // launch("https://shimo.im/docs/89gqQDXT69qgdkQt/read");
    Routers.push(context, Routers.pdfScreen, params: {"path": path});
  }

  void _importWallets() async {
    // 0 content name password againtext tip
    // 1 content name password
    // 2 content memotype name password again tip
    //agreement
    String content = contentEC.text.trim();
    String walletName = nameEC.text.trim();
    String pwd = pwdEC.text.trim();
    String pwdagain = pwdAganEC.text.trim();
    String tip = pwdTipEC.text.trim();
    if (mLeadType == MLeadType.MLeadType_Prvkey) {
      content = content.replaceFirst("0x", "");
    }
    if (content.length == 0) {
      if (MLeadType.MLeadType_KeyStore == mLeadType) {
        HWToast.showText(text: "input_keystore".local());
      } else if (MLeadType.MLeadType_Prvkey == mLeadType) {
        HWToast.showText(text: "input_prvkey".local());
      } else {
        HWToast.showText(text: "input_memos".local());
      }
      return;
    }
    if (walletName.length == 0) {
      HWToast.showText(text: "input_name".local());
      return;
    }
    if (pwd.length == 0) {
      HWToast.showText(text: "input_pwd".local());
      return;
    }
    if (mLeadType != MLeadType.MLeadType_KeyStore) {
      if (pwdagain.length == 0) {
        HWToast.showText(text: "input_pwd".local());
        return;
      }
      if (pwd != pwdagain) {
        HWToast.showText(text: "input_pwd_wrong".local());
        return;
      }
      // if (pwd.checkPassword() == false) {
      //   HWToast.showText(text: "input_pwd_regexp".local());
      //   return;
      // }

      if (mLeadType == MLeadType.MLeadType_Prvkey &&
          content.checkPrv(mcoinType) == false) {
        HWToast.showText(text: "import_prvwrong".local());
        return;
      }
    } else {
      Map? object = JsonUtil.getObj(content);
      if (object == null) {
        HWToast.showText(text: "input_keystorevalid".local());
        return;
      }
    }

    if (isAgreement == false) {
      HWToast.showText(text: "import_readagreement".local());
      return;
    }

    HWToast.showLoading(
      clickClose: false,
    );
    MStatusCode v = await MHWallet.importWallet(
        content: content,
        pin: pwd,
        pintip: tip,
        walletName: walletName,
        mCoinType: mcoinType,
        mLeadType: mLeadType,
        mOriginType: MOriginType.MOriginType_LeadIn);
    if (v == MStatusCode.MStatusCode_Success) {
      HWToast.hiddenAllToast();
      Routers.push(context, Routers.tabbarPage, clearStack: true);
    } else {
      if (v == MStatusCode.MStatusCode_Exist) {
        HWToast.showText(text: "input_wallet_exist".local());
      } else if (v == MStatusCode.MStatusCode_MemoInvalid) {
        HWToast.showText(text: "input_memo_wrong".local());
      } else if (v == MStatusCode.MStatusCode_KeystorePwdInvalid) {
        HWToast.showText(text: "input_keystoreorpassword".local());
      } else {
        HWToast.showText(text: "wallet_create_err".local());
      }
    }
  }

  _changeLeadType(int value) {
    FocusScope.of(context).requestFocus(FocusNode());
    MLeadType type = mLeadType;
    MLeadType.values.forEach((element) {
      if (element.index == value) {
        type = element;
      }
    });
    Future.delayed(Duration(milliseconds: 500)).then((value) => {
          setState(() {
            mLeadType = type;
            LogUtil.v("点击element $mLeadType");
          }),
        });

    contentEC.clear();
    nameEC.clear();
    pwdEC.clear();
    pwdAganEC.clear();
    pwdTipEC.clear();
  }

  Widget _getInputTextField(
      {TextEditingController? controller,
      String? hintText,
      String? titleText,
      String? helpText,
      bool obscureText = false,
      EdgeInsetsGeometry padding = const EdgeInsets.only(top: 22),
      int? maxLength,
      bool isPasswordText = false}) {
    return Padding(
        padding: padding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                CustomTextField(
                  controller: controller,
                  obscureText: obscureText,
                  maxLength: maxLength,
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWightHelper.regular,
                  ),
                  decoration: CustomTextField.getBorderLineDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: ColorUtils.fromHex(Constant.hintTextColor),
                      fontSize: OffsetWidget.setSp(12),
                      fontWeight: FontWightHelper.regular,
                    ),
                  ),
                ),
                isPasswordText
                    ? Positioned(
                        right: OffsetWidget.setSc(0),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Image.asset(
                            controller == pwdEC
                                ? (eyeisOpen1
                                    ? _passwordHideIcon
                                    : _passwordLightIcon)
                                : (eyeisOpen2
                                    ? _passwordHideIcon
                                    : _passwordLightIcon),
                            width: OffsetWidget.setSc(16),
                            height: OffsetWidget.setSc(16),
                          ),
                          onPressed: () {
                            setState(() {
                              if (controller == pwdEC) {
                                eyeisOpen1 = !eyeisOpen1;
                              } else if (controller == pwdAganEC) {
                                eyeisOpen2 = !eyeisOpen2;
                              }
                            });
                          },
                        ))
                    : Container(),
              ]),
              OffsetWidget.vGap(10),
              Visibility(
                visible: helpText != null,
                child: Text(
                  helpText ??= "",
                  style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWightHelper.regular,
                  ),
                ),
              )
            ]));
  }

  Widget _getPageViewWidget(int leadtype) {
    Widget content;
    Widget name = _getInputTextField(
        controller: nameEC,
        helpText: "import_walletname".local(),
        hintText: "wallet_name".local(),
        titleText: "wallet_name".local(),
        padding: EdgeInsets.only(top: 25));
    Widget password = _getInputTextField(
      controller: pwdEC,
      obscureText: eyeisOpen1,
      // helpText: "import_pwddetail".local(),
      hintText: "import_pwd".local(),
      titleText: "import_pwd".local(),
      isPasswordText: true,
    );
    Widget againPwd = _getInputTextField(
      controller: pwdAganEC,
      obscureText: eyeisOpen2,
      hintText: "import_pwdagain".local(),
      titleText: "import_pwdagain".local(),
      isPasswordText: true,
    );

    Widget passwordTip = _getInputTextField(
      controller: pwdTipEC,
      hintText: "import_pwddesc".local(),
      titleText: "wallet_update_tip_title".local(),
    );

    List<Widget> children = [];
    if (leadtype == MLeadType.MLeadType_Prvkey.index) {
      content = Container(
        height: OffsetWidget.setSc(92),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorUtils.rgba(73, 73, 73, 0.3),
          border: Border.all(
            color: ColorUtils.rgba(73, 73, 73, 0.3),
          ),
        ),
        child: CustomTextField(
          controller: contentEC,
          maxLines: 10,
          style: TextStyle(
            color: ColorUtils.rgba(222, 224, 223, 1),
            fontSize: OffsetWidget.setSp(16),
            fontWeight: FontWightHelper.regular,
          ),
          decoration: CustomTextField.getBorderLineDecoration(
            hintText: "import_plainprv".local(),
            fillColor: ColorUtils.rgba(73, 73, 73, 0.3),
            borderColor: Colors.transparent,
            contentPadding: EdgeInsets.only(
                left: OffsetWidget.setSc(10),
                right: OffsetWidget.setSc(10),
                top: OffsetWidget.setSc(8)),
            helperStyle: TextStyle(
              color: ColorUtils.rgba(222, 224, 223, 1),
              fontWeight: FontWightHelper.regular,
              fontSize: OffsetWidget.setSp(14),
            ),
            hintStyle: TextStyle(
                color: ColorUtils.rgba(222, 224, 223, 1),
                fontWeight: FontWightHelper.regular,
                fontSize: OffsetWidget.setSp(16)),
          ),
        ),
      );

      children.add(content);
      children.add(name);
      children.add(password);
      children.add(againPwd);
      children.add(passwordTip);
    } else if (leadtype == MLeadType.MLeadType_KeyStore.index) {
      content = Container(
        height: OffsetWidget.setSc(92),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorUtils.rgba(73, 73, 73, 0.3),
          border: Border.all(
            color: ColorUtils.rgba(73, 73, 73, 0.3),
          ),
        ),
        child: CustomTextField(
          controller: contentEC,
          maxLines: 10,
          style: TextStyle(
            color: ColorUtils.rgba(222, 224, 223, 1),
            fontSize: OffsetWidget.setSp(12),
            fontWeight: FontWightHelper.regular,
          ),
          decoration: CustomTextField.getBorderLineDecoration(
            hintText: "import_plainkeystore".local(),
            fillColor: ColorUtils.rgba(73, 73, 73, 0.3),
            borderColor: Colors.transparent,
            contentPadding: EdgeInsets.only(
                left: OffsetWidget.setSc(10),
                right: OffsetWidget.setSc(10),
                top: OffsetWidget.setSc(8)),
            helperStyle: TextStyle(
              color: ColorUtils.rgba(222, 224, 223, 1),
              fontWeight: FontWightHelper.regular,
              fontSize: OffsetWidget.setSp(12),
            ),
            hintStyle: TextStyle(
                color: ColorUtils.rgba(222, 224, 223, 1),
                fontWeight: FontWightHelper.regular,
                fontSize: OffsetWidget.setSp(12)),
          ),
        ),
      );
      password = _getInputTextField(
        controller: pwdEC,
        obscureText: eyeisOpen1,
        hintText: "import_pwddetail".local(),
        titleText: "import_pwd".local(),
      );
      children.add(
        Container(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorUtils.rgba(23, 28, 74, 1),
              border: Border.all(
                color: ColorUtils.rgba(23, 28, 74, 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Text(
                  "import_keystoredetail".local(),
                  style: TextStyle(
                    color: ColorUtils.rgba(222, 224, 223, 1),
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                  ),
                )),
              ],
            ),
          ),
        ),
      );
      children.add(content);
      children.add(name);
      children.add(password);
    } else {
      content = Container(
        height: OffsetWidget.setSc(92),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorUtils.rgba(73, 73, 73, 0.3),
          border: Border.all(
            color: ColorUtils.rgba(73, 73, 73, 0.3),
          ),
        ),
        child: CustomTextField(
          controller: contentEC,
          maxLines: 10,
          style: TextStyle(
            color: ColorUtils.rgba(222, 224, 223, 1),
            fontSize: OffsetWidget.setSp(12),
            fontWeight: FontWightHelper.regular,
          ),
          decoration: CustomTextField.getBorderLineDecoration(
            hintText: "import_plainmemo".local(),
            fillColor: ColorUtils.rgba(73, 73, 73, 0.3),
            borderColor: Colors.transparent,
            contentPadding: EdgeInsets.only(
                left: OffsetWidget.setSc(10),
                right: OffsetWidget.setSc(10),
                top: OffsetWidget.setSc(8)),
            helperStyle: TextStyle(
              color: ColorUtils.rgba(222, 224, 223, 1),
              fontWeight: FontWightHelper.regular,
              fontSize: OffsetWidget.setSp(12),
            ),
            hintStyle: TextStyle(
                color: ColorUtils.rgba(222, 224, 223, 1),
                fontWeight: FontWightHelper.regular,
                fontSize: OffsetWidget.setSp(12)),
          ),
        ),
      );
      children.add(content);
      children.add(name);
      children.add(password);
      children.add(againPwd);
      children.add(passwordTip);
    }

    GestureDetector agrmentInfo = GestureDetector(
      onTap: jumpToAgreement,
      child: Container(
        padding: EdgeInsets.only(
            top: OffsetWidget.setSc(39),
            left: OffsetWidget.setSc(0),
            right: OffsetWidget.setSc(0)),
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
              constraints: BoxConstraints(maxWidth: OffsetWidget.setSc(300)),
              child: RichText(
                maxLines: 10,
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'readagrementinfo'.local(),
                  style: TextStyle(
                    color: Color(0xFF979797),
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'agrementinfo'.local(),
                        style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: OffsetWidget.setSp(13),
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    GestureDetector startImportBtn = GestureDetector(
      onTap: _importWallets,
      child: Container(
        margin: EdgeInsets.only(
            left: OffsetWidget.setSc(20),
            top: OffsetWidget.setSc(47),
            bottom: OffsetWidget.setSc(36),
            right: OffsetWidget.setSc(20)),
        height: OffsetWidget.setSc(46),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorUtils.rgba(78, 108, 220, 1)),
        child: Text(
          "import_hote".local(),
          style: TextStyle(
              fontWeight: FontWightHelper.semiBold,
              fontSize: OffsetWidget.setSp(20),
              color: Colors.white),
        ),
      ),
    );

    children.add(agrmentInfo);
    children.add(OffsetWidget.vGap(24));
    children.add(startImportBtn);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(16),
            right: OffsetWidget.setSc(15),
            top: OffsetWidget.setSc(21)),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
        title: CustomPageView.getDefaultTitle(
          titleStr: ("import_page".local() +
              Constant.getChainSymbol(mcoinType!.index) +
              "import_wallet".local()),
        ),
        hiddenScrollView: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Material(
            color: Color(Constant.main_color),
            child: Theme(
              data: ThemeData(
                  splashColor: Color.fromRGBO(0, 0, 0, 0),
                  highlightColor: Color.fromRGBO(0, 0, 0, 0)),
              child: TabBar(
                tabs: _myTabs,
                indicatorColor: Colors.white,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16),
                ),
                unselectedLabelColor: Color(0xFF999999),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16),
                ),
                onTap: (value) {
                  _changeLeadType(value);
                },
              ),
            ),
          ),
        ),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(), //禁止左右滑动
          children: _myTabs.map((Tab tab) {
            int leadType = _myTabs.indexOf(tab);
            return _getPageViewWidget(leadType);
          }).toList(),
        ),
      ),
    );
  }
}
