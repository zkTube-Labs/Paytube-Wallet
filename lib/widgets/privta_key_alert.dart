import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_coinid/pages/wallet_info/private_tips_eventbus.dart';
import '../public.dart';

class PrivateKeyAlertCenterView extends StatefulWidget {
  final Function(String text) privateControllerCallBack;
  const PrivateKeyAlertCenterView(
      {Key? key, required this.privateControllerCallBack})
      : super(key: key);

  @override
  _PrivateKeyAlertCenterViewState createState() =>
      _PrivateKeyAlertCenterViewState();
}

class _PrivateKeyAlertCenterViewState extends State<PrivateKeyAlertCenterView> {
  //密码输入框
  TextEditingController _passwordController = TextEditingController(text: "");
  //密码提示
  String? _passwordHint = '';

  //密码提示是否隐藏  默认隐藏
  bool _passwordHintHidden = true;
  //是否显示密码
  bool _obscureText = true;
  StreamSubscription? _privateKeySubscription;

  String _passwordHideIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_hide_light.png';
  String _passwordLightIcon =
      Constant.ASSETS_IMG + "icon/" + 'password_light.png';
  @override
  void initState() {
    _passwordController.addListener(() {
      widget.privateControllerCallBack(_passwordController.text);
      setState(() {
        _passwordHintHidden = true;
      });
    });

    _privateKeySubscription =
        eventBus.on<PrivateTipsEventBus>().listen((event) {
      setState(() {
        _passwordHintHidden = false;
        _passwordHint = event.tipString;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _privateKeySubscription?.cancel();
    _privateKeySubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _enterPassword();
  }

  ///输入密码 widget
  Widget _enterPassword() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomTextField(
                controller: _passwordController,
                maxLines: 1,
                obscureText: _obscureText,
                style: TextStyle(
                  color: ColorUtils.rgba(222, 224, 223, 1),
                  fontSize: OffsetWidget.setSp(16),
                  fontWeight: FontWightHelper.regular,
                ),
                decoration: CustomTextField.getBorderLineDecoration(
                  hintText: "import_pwd".local(),
                  fillColor: ColorUtils.fromHex('#262449'),
                  borderColor: _passwordHintHidden
                      ? ColorUtils.fromHex('#4D5CB2')
                      : Colors.red,
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
              Positioned(
                right: OffsetWidget.setSc(0),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Image.asset(
                    _obscureText ? _passwordHideIcon : _passwordLightIcon,
                    width: OffsetWidget.setSc(16),
                    height: OffsetWidget.setSc(16),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              )
            ],
          ),
          OffsetWidget.vGap(6),
          Offstage(
            offstage: _passwordHintHidden,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "passwordError".local(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: OffsetWidget.setSp(12),
                  ),
                ),
                OffsetWidget.vGap(11),
                Text(
                  '${"passwordTips".local()}: ${_passwordHint!}',
                  style: TextStyle(
                    color: ColorUtils.fromHex('#737373'),
                    fontWeight: FontWeight.w400,
                    fontSize: OffsetWidget.setSp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
