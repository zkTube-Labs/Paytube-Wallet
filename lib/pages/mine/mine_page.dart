import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/widgets/custom_alert.dart';
// import 'package:flutter_coinid/pages/shared/shared_sheet_page.dart';
import '../../public.dart';
import 'package:share_plus/share_plus.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  static String _kImageName = "kImageName";
  static String _kContent = "kContent";

  List<Map> get _datas => [
        {
          _kImageName: "menu_wallet.png",
          _kContent: "wallet_contact".local(context: context)
        },
        {
          _kImageName: "menu_set.png",
          _kContent: "system_settings".local(context: context)
        },
        {
          _kImageName: "menu_recommended.png",
          _kContent: "recommend_friends".local(context: context)
        },
        {
          _kImageName: "menu_about.png",
          _kContent: "about_us".local(context: context)
        },
      ];

  Future<void> _shared() async {
    _sharedImage();
  }

  _sharedImage() async {
    final filename = "share_app.png";
    String a = Constant.ASSETS_IMG + "icon/share_app.png";
    var filebd = await rootBundle.load(a);
    File documentsDir = await Constant.getAppFile();
    String documentsPath = documentsDir.absolute.path;
    File file = File('$documentsPath/$filename');
    final buffer = filebd.buffer;
    File toFile = await file.writeAsBytes(
        buffer.asUint8List(filebd.offsetInBytes, filebd.lengthInBytes));

    Share.shareFiles([toFile.path]);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _getCellWidget(int index) {
    Map map = _datas[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        _cellTap(index),
      },
      child: Container(
        padding: EdgeInsets.only(
          right: OffsetWidget.setSc(16),
        ),
        margin: EdgeInsets.only(
          left: OffsetWidget.setSc(16),
          right: OffsetWidget.setSc(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorUtils.rgba(73, 73, 73, 0.29),
        ),
        height: OffsetWidget.setSc(45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                OffsetWidget.hGap(6),
                Container(
                  padding: EdgeInsets.all(6),
                  width: OffsetWidget.setSc(28),
                  height: OffsetWidget.setSc(28),
                  child: LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/" + map[_kImageName],
                  ),
                ),
                OffsetWidget.hGap(2),
                Text(
                  map[_kContent],
                  style: TextStyle(
                    color: ColorUtils.rgba(255, 255, 255, 1),
                    fontWeight: FontWightHelper.regular,
                    fontSize: OffsetWidget.setSp(14),
                  ),
                ),
              ],
            ),
            LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/arrow_dian_whiteright.png",
              width: 6,
              height: 6,
              // scale: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _cellTap(int index) async {
    if (index == 0) {
      Routers.push(context, Routers.mineContactPage);
    } else if (index == 1) {
      Routers.push(context, Routers.systemSetPage);
    } else if (index == 2) {
      _shared();
    } else if (index == 3) {
      Routers.push(context, Routers.aboutUsPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)!.delegates;
    return CustomPageView(
      hiddenLeading: true,
      hiddenResizeToAvoidBottomInset: false,
      title: CustomPageView.getDefaultTitle(titleStr: "my".local()),
      child: Column(
        children: [
          Container(
            height: OffsetWidget.setSc(164),
            margin: EdgeInsets.only(
              left: OffsetWidget.setSc(16),
              right: OffsetWidget.setSc(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LoadAssetsImage(
                Constant.ASSETS_IMG + "background/bg_mine_1.png",
                height: 164,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: OffsetWidget.setSc(9)),
            child: _getCellWidget(0),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: OffsetWidget.setSc(12),
            ),
            child: _getCellWidget(1),
          ),
          Padding(
            padding: EdgeInsets.only(top: OffsetWidget.setSc(12)),
            child: _getCellWidget(2),
          ),
          Padding(
            padding: EdgeInsets.only(top: OffsetWidget.setSc(12)),
            child: _getCellWidget(3),
          ),
        ],
      ),
    );
  }
}
