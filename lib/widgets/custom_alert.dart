import 'package:flutter/material.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/pages/wallet_info/private_tips_eventbus.dart';
import 'package:flutter_coinid/widgets/node_alert.dart';
import 'package:flutter_coinid/widgets/privta_key_alert.dart';
import '../../public.dart';
import 'delete_wallet_alert.dart';

class ShowCustomAlert {
  static showCustomAlertType(
    BuildContext context, {
    required AlertType alertType,
    required String title,
    String subtitleText = "",
    String leftButtonTitle = '',
    String rightButtonTitle = '',
    Color leftButtonColor = Colors.white,
    required Color rightButtonColor,
    VoidCallback? cancelPressed,
    required Function(Map map) confirmPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlert(
          alertType: alertType,
          titleText: title,
          subtitleText: subtitleText,
          leftButtonTitle: leftButtonTitle,
          rightButtonTitle: rightButtonTitle,
          cancelPressed: cancelPressed,
          confirmPressed: confirmPressed,
          rightButtonColor: rightButtonColor,
          leftButtonColor: leftButtonColor,
        );
      },
    );
  }
}

class CustomAlert extends StatefulWidget {
  //弹窗类型
  final AlertType alertType;
  //标题
  final String titleText;
  //文本提示内容
  final String subtitleText;
  //左边按钮名称
  final String leftButtonTitle;
  //右边按钮名称
  final String rightButtonTitle;
  //左边按钮颜色
  final Color leftButtonColor;
  //右边按钮颜色
  final Color rightButtonColor;
  //左边按钮点击回调
  final VoidCallback? cancelPressed;
  //右边按钮点击回调
  final Function(Map map) confirmPressed;
  const CustomAlert({
    Key? key,
    required this.alertType,
    required this.titleText,
    required this.subtitleText,
    required this.rightButtonTitle,
    required this.leftButtonTitle,
    this.cancelPressed,
    required this.confirmPressed,
    required this.leftButtonColor,
    required this.rightButtonColor,
  }) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

///alert弹窗的基本样式
class _CustomAlertState extends State<CustomAlert> {
  //私钥
  String _privateText = '';

  //node
  String _nodeText1 = '';
  String _nodeText2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _alertBgView(),
      ),
    );
  }

  ///alertView bgView
  Widget _alertBgView() {
    return Container(
      constraints: BoxConstraints(
        minHeight: OffsetWidget.setSc(120),
        maxHeight: OffsetWidget.setSc(812),
      ),
      margin: EdgeInsets.only(
        left: OffsetWidget.setSc(45),
        right: OffsetWidget.setSc(45),
      ),
      padding: EdgeInsets.only(
        left: OffsetWidget.setSc(30),
        right: OffsetWidget.setSc(30),
        top: OffsetWidget.setSc(20),
        bottom: OffsetWidget.setSc(5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: ColorUtils.fromHex('#262449'),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(widget.titleText),
          _contextView(),
          _horizontalLine(),
          _bottomActions(),
        ],
      ),
    );
  }

  ///弹窗的title
  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: OffsetWidget.setSp(16),
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    );
  }

  ///弹窗中间的widget
  Widget _contextView() {
    Widget? _child;
    if (widget.alertType == AlertType.text) {
      _child = DeleteWalletCenterView(subtitleText: widget.subtitleText);
    } else if (widget.alertType == AlertType.password) {
      _child = PrivateKeyAlertCenterView(privateControllerCallBack: (text) {
        _privateText = text;
      });
    } else {
      _child = NodeUrlAlertCenterView(nodeControllerCallBack1: (String text) {
        _nodeText1 = text;
      }, nodeControllerCallBack2: (String text) {
        _nodeText2 = text;
      });
    }
    return Container(
      padding: EdgeInsets.only(
        top: OffsetWidget.setSc(16),
        bottom: OffsetWidget.setSc(13),
      ),
      child: _child,
    );
  }

  ///底部横线
  Widget _horizontalLine() {
    return Container(
      height: 1,
      color: ColorUtils.fromHex('#35335B'),
    );
  }

  /// 底部按钮组合
  Widget _bottomActions() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bottomButton('left'),
          Container(
            height: OffsetWidget.setSc(43),
            width: 1,
            color: ColorUtils.fromHex('#35335B'),
          ),
          _bottomButton('right'),
        ],
      ),
    );
  }

  ///底部按钮
  Widget _bottomButton(String btType) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (btType == 'left') {
          widget.cancelPressed ?? Navigator.pop(context);
        } else {
          if (widget.alertType == AlertType.text) {
            //删除钱包
            widget.confirmPressed({});
            widget.cancelPressed ?? Navigator.pop(context);
          } else if (widget.alertType == AlertType.password) {
            //导出私钥  输入密码
            MHWallet mwallet =
                Provider.of<CurrentChooseWalletState>(context, listen: false)
                    .currentWallet!;
            bool isPassword =
                mwallet.lockPin(text: _privateText, ok: null, wrong: null);
            if (isPassword) {
              widget.confirmPressed({'text': _privateText});
              widget.cancelPressed ?? Navigator.pop(context);
            } else {
              String tip = mwallet.pinTip!;
              eventBus.fire(PrivateTipsEventBus(tip));
            }
          } else {
            //添加nodeUrl
            Navigator.pop(context);
            widget.confirmPressed({'str': _nodeText1, 'chainId': _nodeText2});
          }
        }
      },
      child: Container(
        height: OffsetWidget.setSc(45),
        alignment: Alignment.center,
        child: Text(
          btType == 'left'
              ? widget.leftButtonTitle == ''
                  ? "dialog_cancel".local()
                  : widget.leftButtonTitle
              : widget.leftButtonTitle == ''
                  ? "dialog_confirm".local()
                  : widget.leftButtonTitle,
          style: TextStyle(
            color: btType == 'left'
                ? widget.leftButtonColor
                : widget.rightButtonColor,
            fontSize: OffsetWidget.setSp(16),
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
