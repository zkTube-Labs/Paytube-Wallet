import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/net/wallet_services.dart';
import 'package:flutter_coinid/upgrade/app_upgrade.dart';
import 'package:flutter_coinid/upgrade/download_status.dart';
import 'package:flutter_coinid/upgrade/flutter_upgrade.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../public.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  static String _kImageName = "kImageName";
  static String _kContent = "kContent";
  static String _kValue = "kValue";
  String? _imei = "";
  bool isLastVersion = false;
  AppInfo _appInfo = AppInfo(versionName: "");
  Map<String, dynamic>? updateMap = Map();

  List<Map> _datas = [
    {
      _kImageName: "about_WEB.png",
      _kContent: "Web",
      _kValue: "https://paytube.io"
    },
    {
      _kImageName: "about_Medium.png",
      _kContent: "Medium",
      _kValue: "https://zktube.medium.com/"
    },
    {
      _kImageName: "about_twitter.png",
      _kContent: "Twitter",
      _kValue: "http://twitter.com/zktubeofficial",
    },
    {
      _kImageName: "about_facebook.png",
      _kContent: "Facebook",
      _kValue: "http://www.fackebook.com/zkTube.io/",
    },
    {
      _kImageName: "about_telegram.png",
      _kContent: "Telegram",
      _kValue: "https://t.me/zkTubeProtocol",
    },
    {
      _kImageName: "about_Discord.png",
      _kContent: "Discord",
      _kValue: "https://discord.gg/ZhcSuxhX4S",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  void _getAppInfo() async {
    var appInfo = await FlutterUpgrade.appInfo;
    _imei = await ChannelWallet.deviceImei();
    setState(() {
      _appInfo = appInfo;
      _getUpdateInfo();
    });
  }

  void _getUpdateInfo() {
    String appType = "android";
    if (Constant.isAndroid) {
      appType = "android";
    } else if (Constant.isIOS) {
      appType = "ios";
    }
    WalletServices.requestUpdateInfo(
        _imei, _appInfo.versionName, _appInfo.packageName, appType, null,
        (result, code) {
      if (code == 200 && mounted) {
        setState(() {
          updateMap = result;
          if (StringUtil.compare(
                  updateMap!["version"], _appInfo.versionName!) >=
              0) {
            isLastVersion = true;
          } else {
            isLastVersion = false;
          }
        });
      }
    });
  }

  void _showUpdateDialog() {
    AppUpgrade.appUpgrade(
      context,
      _checkAppInfo(),
      iosAppId: '1524891382',
      onCancel: () {},
      onOk: () {},
      downloadProgress: (count, total) {},
      downloadStatusChange: (DownloadStatus status, {dynamic error}) {},
    );
  }

  Future<AppUpgradeInfo> _checkAppInfo() async {
    return AppUpgradeInfo(
      title: "about_new_version".local() + updateMap!["version"],
      contents: [
        updateMap!["description"],
      ],
      force: updateMap!["alwaysUpdate"],
      gotoWeb: true,
      apkDownloadUrl: updateMap!["downloadURl"],
    );
  }

  Widget _buildCell(int index) {
    Map map = _datas[index];
    return GestureDetector(
      onTap: () {
        String values = map[_kValue];
        launch(values);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorUtils.rgba(73, 73, 73, 0.29),
        ),
        height: OffsetWidget.setSc(45),
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(
            OffsetWidget.setSc(11),
            OffsetWidget.setSc(0),
            OffsetWidget.setSc(18),
            OffsetWidget.setSc(0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/" + map[_kImageName],
              width: OffsetWidget.setSc(25),
              height: OffsetWidget.setSc(25),
              fit: BoxFit.contain,
            ),
            OffsetWidget.hGap(11),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(map[_kContent],
                    style: TextStyle(
                        fontSize: OffsetWidget.setSp(12),
                        fontWeight: FontWightHelper.regular,
                        color: ColorUtils.rgba(153, 153, 153, 1))),
                Text(map[_kValue],
                    style: TextStyle(
                      fontSize: OffsetWidget.setSp(12),
                      fontWeight: FontWightHelper.regular,
                      color: Colors.white,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(titleStr: "about_title".local()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadAssetsImage(
            Constant.ASSETS_IMG + "icon/icon_app.png",
            width: 137,
            height: 61,
          ),
          OffsetWidget.vGap(8),
          Text("Paytube" + " V" + _appInfo.versionName!,
              style: TextStyle(
                  fontSize: OffsetWidget.setSp(14),
                  fontWeight: FontWightHelper.regular,
                  color: ColorUtils.rgba(153, 153, 153, 1))),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Routers.push(context, Routers.versionLogPage);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorUtils.rgba(73, 73, 73, 0.29),
              ),
              height: OffsetWidget.setSc(45),
              padding: EdgeInsets.fromLTRB(
                  OffsetWidget.setSc(11),
                  OffsetWidget.setSc(0),
                  OffsetWidget.setSc(18),
                  OffsetWidget.setSc(0)),
              margin: EdgeInsets.fromLTRB(
                  OffsetWidget.setSc(16),
                  OffsetWidget.setSc(36),
                  OffsetWidget.setSc(16),
                  OffsetWidget.setSc(0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("about_ver_log".local(),
                      style: TextStyle(
                          fontSize: OffsetWidget.setSp(12),
                          fontWeight: FontWightHelper.regular,
                          color: ColorUtils.rgba(153, 153, 153, 1))),
                  LoadAssetsImage(
                    Constant.ASSETS_IMG + "icon/arrow_dian_whiteright.png",
                    width: 6,
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(36),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(0),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(8),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(1),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(38),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(2),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(8),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(3),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(8),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(4),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: OffsetWidget.setSc(8),
                left: OffsetWidget.setSc(16),
                right: OffsetWidget.setSc(16)),
            child: _buildCell(5),
          )
        ],
      ),
    );
  }
}
