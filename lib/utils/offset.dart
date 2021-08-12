import 'package:flutter_coinid/utils/screenutil.dart';

import '../public.dart';
import 'package:flutter/material.dart';

/// 间隔
class OffsetWidget {
  static const Widget line = Divider();

  static const Widget empty = SizedBox.shrink();

  static Widget vLine(double dimens) {
    return SizedBox(
      height: dimens,
      child: VerticalDivider(),
    );
  }

  static Widget vLineWhitColor(double h, Color color) {
    return Container(
      height: h,
      color: color,
    );
  }

  static Widget hLineWhitColor(double w, Color color) {
    return Container(
      width: w,
      color: color,
    );
  }

  ///垂直间隔
  static Widget vGap(double dimens) {
    return SizedBox(height: setSc(dimens));
  }

  ///水平间隔
  static Widget hGap(double dimens) {
    return SizedBox(width: setSc(dimens));
  }

  //界面基准初始化
  static void screenInit(BuildContext context, double width) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
  }

  /// 高度。宽度适配
  static double setSc(double value) {
    return ScreenUtil().setSc(value) as double;
  }

  ///适配后UI字体数值
  static double setSp(double fontSize) {
    return ScreenUtil().setSp(fontSize) as double;
  }

  ///获取屏幕的宽
  static double? getScreenWidth() {
    return ScreenUtil.screenWidth;
  }

  ///获取屏幕的高
  static double? getScreenHeight() {
    return ScreenUtil.screenHeight;
  }

  ///获取屏幕的高
  static double? getStatusBarHeight() {
    return ScreenUtil.statusBarHeight;
  }
}
