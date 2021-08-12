import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../public.dart';

class WalletExportPrikeyKeystorePage extends StatefulWidget {
  WalletExportPrikeyKeystorePage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _WalletExportPrikeyKeystorePageState createState() =>
      _WalletExportPrikeyKeystorePageState();
}

class _WalletExportPrikeyKeystorePageState
    extends State<WalletExportPrikeyKeystorePage> {
  bool show2Code = false;
  int exportType = 0; //0:prvKey 1:keystore
  String? content = "";

  List<Tab> _myTabs = <Tab>[];

  @override
  void initState() {
    super.initState();
    if (widget.params != null) {
      exportType = int.parse(widget.params!["exportType"][0]);
      content = '${widget.params!["content"][0]}';
    }
    if (exportType == 1) {
      _myTabs.add(Tab(text: "Keystore".local()));
    } else {
      content = "0x" + content!;
      _myTabs.add(Tab(text: "import_prv".local()));
    }
    _myTabs.add(Tab(text: "qr_code".local()));

    setState(() {});
  }

  void _clickCopy(String value) {
    print("_clickCopy " + value);
    if (value.isValid() == false) return;
    Clipboard.setData(ClipboardData(text: value));
    HWToast.showText(text: "copy_success".local());
  }

  Widget _getPageViewWidget(int page) {
    if (page == 1) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            build2CodePage(),
            GestureDetector(
              onTap: () {
                show2Code = !show2Code;
                setState(() {});
              },
              child: Container(
                height: OffsetWidget.setSc(46),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    bottom: OffsetWidget.setSc(36),
                    left: OffsetWidget.setSc(36),
                    right: OffsetWidget.setSc(36)),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(78, 108, 220, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  // "export_copy".local() +
                  //     (exportType == 1 ? " Keystore" : "Private key"),
                  "wallet_display".local(),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(20),
                      color: Colors.white),
                ),
              ),
            )
          ]);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTxtPage(),
            GestureDetector(
              onTap: () => {
                _clickCopy(content!),
              },
              child: Container(
                height: OffsetWidget.setSc(46),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    bottom: OffsetWidget.setSc(36),
                    left: OffsetWidget.setSc(36),
                    right: OffsetWidget.setSc(36)),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(78, 108, 220, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "export_copy".local() +
                      (exportType == 1 ? " Keystore" : "Private key"),
                  style: TextStyle(
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(20),
                      color: Colors.white),
                ),
              ),
            ),
          ]);
    }
  }

  Widget buildTxtPage() {
    return Column(
      children: [
        OffsetWidget.vGap(16),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorUtils.rgba(73, 73, 73, 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(
            left: OffsetWidget.setSc(15),
            right: OffsetWidget.setSc(15),
          ),
          padding: EdgeInsets.only(
              left: OffsetWidget.setSc(7),
              top: OffsetWidget.setSc(19),
              right: OffsetWidget.setSc(7),
              bottom: OffsetWidget.setSc(19)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "export_tip1".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              OffsetWidget.vGap(4),
              Text(
                "export_tip2".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(10),
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.rgba(153, 153, 153, 1)),
              ),
              OffsetWidget.vGap(18),
              Text(
                "export_tip3".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              OffsetWidget.vGap(5),
              Text(
                "export_tip4".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(10),
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.rgba(153, 153, 153, 1)),
              ),
              OffsetWidget.vGap(18),
              Text(
                "export_tip5".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              OffsetWidget.vGap(5),
              Text(
                "export_tip6".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(10),
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.rgba(153, 153, 153, 1)),
              ),
            ],
          ),
        ),
        OffsetWidget.vGap(16),
        Container(
          margin: EdgeInsets.only(
            left: OffsetWidget.setSc(15),
            right: OffsetWidget.setSc(15),
          ),
          decoration: BoxDecoration(
            color: ColorUtils.rgba(73, 73, 73, 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.only(
              left: OffsetWidget.setSc(7),
              top: OffsetWidget.setSc(23),
              right: OffsetWidget.setSc(7),
              bottom: OffsetWidget.setSc(23)),
          child: Text(
            content!,
            style: TextStyle(
                fontSize: OffsetWidget.setSp(11), color: Color(0xFF586883)),
          ),
        ),
      ],
    );
  }

  Widget build2CodePage() {
    return Column(
      children: [
        OffsetWidget.vGap(16),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorUtils.rgba(73, 73, 73, 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(
            left: OffsetWidget.setSc(15),
            right: OffsetWidget.setSc(15),
          ),
          padding: EdgeInsets.only(
              left: OffsetWidget.setSc(7),
              top: OffsetWidget.setSc(19),
              right: OffsetWidget.setSc(7),
              bottom: OffsetWidget.setSc(19)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "export_tip7".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              OffsetWidget.vGap(4),
              Text(
                "export_tip8".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(10),
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.rgba(153, 153, 153, 1)),
              ),
              OffsetWidget.vGap(18),
              Text(
                "export_tip9".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              OffsetWidget.vGap(4),
              Text(
                "export_tip10".local(),
                style: TextStyle(
                    fontSize: OffsetWidget.setSp(10),
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.rgba(153, 153, 153, 1)),
              ),
            ],
          ),
        ),
        OffsetWidget.vGap(35),
        Container(
            width: OffsetWidget.setSc(173),
            height: OffsetWidget.setSc(173),
            child: Stack(
              children: [
                Positioned(
                  child: Visibility(
                    child: QrImage(
                      data: content!,
                      size: OffsetWidget.setSc(173),
                      backgroundColor: Colors.white,
                    ),
                    visible: show2Code,
                  ),
                ),
                Positioned(
                  child: Visibility(
                    child: LoadAssetsImage(
                      Constant.ASSETS_IMG + "icon/icon_hidden_2code.png",
                      width: OffsetWidget.setSc(173),
                      height: OffsetWidget.setSc(173),
                      fit: BoxFit.contain,
                      color: ColorUtils.rgba(153, 153, 153, 0.1),
                    ),
                    visible: !show2Code,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
        hiddenScrollView: true,
        hiddenResizeToAvoidBottomInset: false,
        title: CustomPageView.getDefaultTitle(
          titleStr: exportType == 1
              ? "export_keystore".local()
              : "export_prv".local(),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                    color: Color(Constant.main_color),
                    child: Theme(
                      data: ThemeData(
                          splashColor: Color.fromRGBO(0, 0, 0, 0),
                          highlightColor: Color.fromRGBO(0, 0, 0, 0)),
                      child: TabBar(
                        tabs: _myTabs,
                        indicatorColor: ColorUtils.rgba(196, 196, 196, 1),
                        indicatorWeight: 1,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: OffsetWidget.setSp(14),
                          fontWeight: FontWeight.w400,
                        ),
                        unselectedLabelColor: ColorUtils.rgba(153, 153, 153, 1),
                        unselectedLabelStyle: TextStyle(
                          fontSize: OffsetWidget.setSp(14),
                          fontWeight: FontWeight.w400,
                        ),
                        onTap: (page) => {},
                      ),
                    )),
              ],
            )),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(), //禁止左右滑动
          children: _myTabs.map((Tab tab) {
            return _getPageViewWidget(
              _myTabs.indexOf(tab),
            );
          }).toList(),
        ),
      ),
    );
  }
}
