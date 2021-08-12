import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../public.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _nameEC = new TextEditingController();
  final TextEditingController _passwordEC = new TextEditingController();
  final TextEditingController _againPasswordEC = new TextEditingController();
  final TextEditingController _passwordTipEC = new TextEditingController();
  bool eyeisOpen1 = true; //密码框是否显示密码
  bool eyeisOpen2 = true; //重复密码框是否显示密码
  bool isAgreement = false;

  String _passwordHideIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_hide_light.png';
  String _passwordLightIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_light.png';

  TapGestureRecognizer? _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = jumpToAgreement;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tapGestureRecognizer!.dispose();
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

  void _createAction() {
    final String walletName = _nameEC.text;
    final String password = _passwordEC.text;
    final String againPwd = _againPasswordEC.text;
    final String pwdTip = _passwordTipEC.text;
    FocusScope.of(context).requestFocus(FocusNode());
    if (walletName.length == 0) {
      HWToast.showText(text: "input_name".local());
      return;
    }
    if (password.length == 0 || password.length == 0) {
      HWToast.showText(text: "input_pwd".local());
      return;
    }
    if (password != againPwd) {
      HWToast.showText(text: "input_pwd_wrong".local());
      return;
    }
    // if (password.checkPassword() == false) {
    //   HWToast.showText(text: "input_pwd_regexp".local());
    //   return;
    // }

    if (isAgreement == false) {
      HWToast.showText(text: "import_readagreement".local());
      return;
    }
    Map<String, dynamic> object = Map();
    object["walletName"] = walletName;
    object["password"] = password;
    object["pwdTip"] = pwdTip;
    object["memoCount"] = MemoCount.MemoCount_12;
    Routers.push(context, Routers.backupMemosPage, params: object);
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
                    color: Color(Constant.valueTextColor),
                    fontSize: OffsetWidget.setSp(16),
                    fontWeight: FontWightHelper.regular,
                  ),
                  decoration: CustomTextField.getBorderLineDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: ColorUtils.fromHex(Constant.hintTextColor),
                      fontSize: OffsetWidget.setSp(16),
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
                            controller == _passwordEC
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
                              if (controller == _passwordEC) {
                                eyeisOpen1 = !eyeisOpen1;
                              } else if (controller == _againPasswordEC) {
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

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(
        titleStr: "create_wallet".local(),
      ),
      child: Container(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(16),
            right: OffsetWidget.setSc(16),
            top: OffsetWidget.setSc(20)),
        child: Column(
          children: <Widget>[
            _getInputTextField(
                controller: _nameEC,
                helpText: "import_walletname".local(),
                hintText: "wallet_name".local(),
                titleText: "wallet_name".local(),
                padding: EdgeInsets.only(top: 14)),
            _getInputTextField(
              controller: _passwordEC,
              obscureText: eyeisOpen1,
              // helpText: "import_pwddetail".local(),
              hintText: "import_pwd".local(),
              titleText: "import_pwd".local(),
              isPasswordText: true,
            ),
            _getInputTextField(
              controller: _againPasswordEC,
              obscureText: eyeisOpen2,
              hintText: "import_pwdagain".local(),
              titleText: "import_pwdagain".local(),
              isPasswordText: true,
            ),
            _getInputTextField(
              controller: _passwordTipEC,
              hintText: "import_pwddesc".local(),
              titleText: "wallet_update_tip_title".local(),
            ),
            Container(
              padding: EdgeInsets.only(
                top: OffsetWidget.setSc(34),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  GestureDetector(
                    onTap: updateAgreement,
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: OffsetWidget.setSc(300)),
                      child: RichText(
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'readagrementinfo'.local(),
                          style: TextStyle(
                            color: Color(0xFF999EA5),
                            fontSize: OffsetWidget.setSp(14),
                            fontWeight: FontWightHelper.regular,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'agrementinfo'.local(),
                                recognizer: _tapGestureRecognizer,
                                style: TextStyle(
                                  color: Color(0xFF586883),
                                  fontSize: OffsetWidget.setSp(14),
                                  fontWeight: FontWightHelper.regular,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _createAction,
              child: Container(
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(36),
                    top: OffsetWidget.setSc(70),
                    right: OffsetWidget.setSc(36)),
                height: OffsetWidget.setSc(46),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorUtils.rgba(78, 108, 220, 1)),
                child: Text(
                  "create_wallet".local(),
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
