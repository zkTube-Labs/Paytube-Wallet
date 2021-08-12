/// 引导页

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_coinid/public.dart';

class GuidePage extends StatefulWidget {
  GuidePage({Key? key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int exitTime = 0;
  int currentIndex = 0;
  List<Widget> slides = [];
  List<Color> pointColors = [
    ColorUtils.rgba(250, 28, 28, 1),
    ColorUtils.rgba(81, 26, 235, 1),
    ColorUtils.rgba(36, 255, 84, 1),
  ];
  @override
  void initState() {
    super.initState();
  }

  List<Widget> buildWidget() {
    slides.clear();
    slides.add(
      Container(
        color: Color(Constant.main_color),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            LoadAssetsImage(
              Constant.ASSETS_IMG + "guide/img1.png",
              height: OffsetWidget.setSc(313),
            ),
            Text(
              "guide_txt_1".local(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16.0)),
            ),
            OffsetWidget.vGap(14),
            Text(
              "guide_txt_4".local(),
              style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(12.0)),
            ),
            OffsetWidget.vGap(43 + 9 + 48 + 46 + 63),
          ],
        ),
      ),
    );
    slides.add(
      Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        color: Color(Constant.main_color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            LoadAssetsImage(
              Constant.ASSETS_IMG + "guide/img2.png",
              height: OffsetWidget.setSc(313),
              // fit: BoxFit.cover,
            ),
            // OffsetWidget.vGap(66),
            Text(
              "guide_txt_2".local(),
                textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16.0)),
            ),
            OffsetWidget.vGap(14),
            Text(
              "guide_txt_5".local(),
                textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(12.0)),
            ),
            OffsetWidget.vGap(43 + 9 + 48 + 46 + 63),
          ],
        ),
      ),
    );
    slides.add(
      Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        color: Color(Constant.main_color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            LoadAssetsImage(
              Constant.ASSETS_IMG + "guide/img3.png",
              height: OffsetWidget.setSc(313),
              fit: BoxFit.cover,
            ),
            // OffsetWidget.vGap(0),
            Text(
              "guide_txt_3".local(),
                textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(16.0)),
            ),
            OffsetWidget.vGap(14),
            Text(
              "guide_txt_6".local(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: OffsetWidget.setSp(12.0)),
            ),
            OffsetWidget.vGap(43 + 9),
            GestureDetector(
              onTap: () => {
                onDonePress(),
              },
              child: Container(
                height: OffsetWidget.setSc(46),
                width: OffsetWidget.setSc(200),
                margin: EdgeInsets.only(
                  top: OffsetWidget.setSc(48),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.rgba(44, 47, 204, 1)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                child: Text(
                  "comfirm_trans_payment".local(),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: OffsetWidget.setSp(20),
                      color: ColorUtils.rgba(35, 32, 200, 1)),
                ),
              ),
            ),
            OffsetWidget.vGap(63),
          ],
        ),
      ),
    );
    return slides;
  }

  void onDonePress() {
    print("onDonePress");
    updateSkin();
  }

  Widget _buildPoint() {
    return Container(
      width: OffsetWidget.setSc(61),
      height: OffsetWidget.setSc(9),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(pointColors.length, (int index) {
          return _pointWidget(index);
        }).toList(),
      ),
    );
  }

  Widget _pointWidget(int index) {
    return Container(
      width: OffsetWidget.setSc(9),
      height: OffsetWidget.setSc(9),
      decoration: BoxDecoration(
        color: currentIndex == index
            ? pointColors[currentIndex]
            : Color(Constant.main_color),
        borderRadius: BorderRadius.all(Radius.circular(OffsetWidget.setSc(9))),
        border: Border.all(width: 1, color: Colors.white),
      ),
    );
  }

  void updateSkin() async {
    final fres = await SharedPreferences.getInstance();
    // if (Constant.inProduction == false) {
    fres.setBool("skip", true);
    // }
    Routers.push(context, Routers.chooseTypePage,
        params: {'isHideBack': false});
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return WillPopScope(
      onWillPop: () async {
        //0x1AFFFFFF
        if (DateUtil.getNowDateMs() - exitTime > 2000) {
          HWToast.showText(text: 'exit_hint'.local());
          exitTime = DateUtil.getNowDateMs();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return true;
      },
      child: CustomPageView(
        hiddenAppBar: true,
        hiddenScrollView: true,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              children: buildWidget(),
              // pageSnapping: false,
            ),
            Positioned(
                left:
                    (OffsetWidget.getScreenWidth()! - OffsetWidget.setSc(61)) /
                        2,
                bottom: OffsetWidget.setSc(48 + 46 + 63),
                child: _buildPoint()),
          ],
        ),
      ),
    );
  }
}
