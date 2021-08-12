import 'package:flutter/material.dart';
import '../../public.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  String _exchangeImagePath = Constant.ASSETS_IMG + 'explore/logo1.png';
  String _currencyImagePath = Constant.ASSETS_IMG + 'explore/logo2.png';

  String _exchangeTitle = "exchangeTitle".local();
  String _currencyTitle = "currencyTitle".local();

  String _exchangeSubtitle = "exchangeSubtitle".local();
  String _currencySubtitle = "currencySubtitle".local();

  String _exchangeButtonTitle = "exchangeButtonTitle".local();
  String _currencyButtonTitle = "currencyButtonTitle".local();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      hiddenScrollView: false,
      hiddenLeading: true,
      hiddenAppBar: true,
      child: Container(
        padding: EdgeInsets.only(
            left: OffsetWidget.setSc(17),
            top: OffsetWidget.setSc(10),
            right: OffsetWidget.setSc(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageGroup(_exchangeImagePath),
            OffsetWidget.vGap(19),
            _exchangeText(
                _exchangeTitle, _exchangeSubtitle, _exchangeButtonTitle),
            OffsetWidget.vGap(70),
            _imageGroup(_currencyImagePath),
            OffsetWidget.vGap(19),
            _exchangeText(
                _currencyTitle, _currencySubtitle, _currencyButtonTitle),
            OffsetWidget.vGap(60),
          ],
        ),
      ),
    );
  }

  Widget _imageGroup(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        height: imagePath == _currencyImagePath
            ? OffsetWidget.setSc(204)
            : OffsetWidget.setSc(225),
        color: ColorUtils.rgba(73, 73, 73, 0.3),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _exchangeText(String title, String subtitle, String buttonTitle) {
    return Container(
      padding: EdgeInsets.only(right: OffsetWidget.setSc(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: OffsetWidget.setSp(14),
                ),
              ),
              OffsetWidget.vGap(15),
              Container(
                width: OffsetWidget.setSc(196),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: ColorUtils.fromHex('#999999'),
                    fontSize: OffsetWidget.setSp(10),
                    height: 1.5,
                  ),
                  maxLines: 2,
                ),
              )
            ],
          ),
          _jumpButton(buttonTitle),
        ],
      ),
    );
  }

  Widget _jumpButton(String title) {
    return GestureDetector(
      onTap: () {
        String type = title == _exchangeButtonTitle ? 'exchange' : 'currency';
        _jumpToNextPage(type);
      },
      child: Container(
        alignment: Alignment.center,
        width: OffsetWidget.setSc(90),
        height: OffsetWidget.setSc(30),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex('#4E6CDC'),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: OffsetWidget.setSp(12),
          ),
        ),
      ),
    );
  }

  void _jumpToNextPage(String type) {
    Routers.push(context, Routers.appListSearch, params: {"type": type});
  }
}
