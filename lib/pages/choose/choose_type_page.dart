///登录注册页面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../public.dart';

class ChooseTypePage extends StatefulWidget {
  ///是否隐藏返回按钮 //默认显示  只有引导页进入不显示
  final bool isHideBack;
  const ChooseTypePage({Key? key, this.isHideBack = true}) : super(key: key);

  @override
  _ChooseTypePageState createState() => _ChooseTypePageState();
}

class _ChooseTypePageState extends State<ChooseTypePage> {
  int exitTime = 0;

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return WillPopScope(
      onWillPop: () async {
        if (DateUtil.getNowDateMs() - exitTime > 2000) {
          HWToast.showText(text: 'exit_hint'.local());
          exitTime = DateUtil.getNowDateMs();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return true;
      },
      child: CustomPageView(
        hiddenScrollView: true,
        hiddenAppBar: true,
        safeAreaBottom: false,
        safeAreaLeft: false,
        safeAreaRight: false,
        safeAreaTop: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Constant.ASSETS_IMG + "background/create_bg.png",
              ),
            ),
          ),
          child: Column(
            children: [
              OffsetWidget.vGap(144),
              _logoView(),
              Expanded(child: Container()),
              _walletButton("+" + "create_hote".local()),
              OffsetWidget.vGap(14),
              _walletButton(
                "wallet_leadin".local(),
                imagePath: Constant.ASSETS_IMG + "background/btn_linear.png",
              ),
              OffsetWidget.vGap(110),
            ],
          ),
        ),
      ),
    );
  }

  ///logo
  Widget _logoView() {
    return Container(
      height: OffsetWidget.setSc(110),
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: OffsetWidget.setSc(56),
        right: OffsetWidget.setSc(56),
      ),
      padding: EdgeInsets.all(8),
      child: LoadAssetsImage(
        Constant.ASSETS_IMG + "icon/icon_app.png",
        fit: BoxFit.cover,
      ),
    );
  }

  /// 钱包按钮   title:按钮名称，imagePath：按钮背景图片地址
  Widget _walletButton(String title, {String? imagePath}) {
    return GestureDetector(
      onTap: () {
        if (title == "wallet_leadin".local()) {
          //跳转到导入钱包页面
          String mcoinType =
              Constant.getChainSymbol(MCoinType.MCoinType_ETH.index);
          Routers.push(context, Routers.importPage,
              params: {"coinType": mcoinType});
        } else {
          //跳转到创建钱包页面
          Routers.push(context, Routers.createPage);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: OffsetWidget.setSc(51),
          right: OffsetWidget.setSc(51),
        ),
        alignment: Alignment.center,
        height: OffsetWidget.setSc(56),
        decoration: BoxDecoration(
          color: ColorUtils.rgba(78, 108, 220, 0.4),
          borderRadius: BorderRadius.circular(168),
          image: imagePath != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                )
              : null,
          boxShadow: imagePath != null
              ? [
                  BoxShadow(
                    color: ColorUtils.rgba(147, 62, 255, 0.7), //底色,阴影颜色
                    offset: Offset(0, 9), //阴影位置,从什么位置开始
                    blurRadius: 34, // 阴影模糊层度
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: OffsetWidget.setSp(20),
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
