import 'package:flutter_coinid/models/node/node_model.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';

import '../../public.dart';

class SystemSetPage extends StatefulWidget {
  SystemSetPage({Key? key}) : super(key: key);

  @override
  _SystemSetPageState createState() => _SystemSetPageState();
}

class _SystemSetPageState extends State<SystemSetPage> {
  int amount = 0;
  int language = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSetType();
  }

  void getSetType() async {
    int newamount = await getAmountValue();
    int newlanguage = await getLanguageValue();
    LogUtil.v("newamount $newamount newlanguage $newlanguage");
    setState(() {
      amount = newamount;
      language = newlanguage;
    });
  }

  Future<void> _cellTap(int index) async {
    if (index == 0 || index == 1) {
      Routers.push(context, Routers.modifiySetPage, params: {"settype": index})
          .then((value) => {
                getSetType(),
              });
    } else {
      Routers.push(context, Routers.nodeListPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        title: CustomPageView.getDefaultTitle(
            titleStr: "system_settings".local(context: context)),
        child: Column(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                _cellTap(0),
              },
              child: Container(
                alignment: Alignment.center,
                height: OffsetWidget.setSc(46),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(73, 73, 73, 0.29),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(16),
                    right: OffsetWidget.setSc(16),
                    top: OffsetWidget.setSc(15)),
                padding: EdgeInsets.only(
                  left: OffsetWidget.setSc(11),
                  right: OffsetWidget.setSc(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "system_currency".local(context: context),
                      style: TextStyle(
                          color: ColorUtils.rgba(153, 153, 153, 1),
                          fontSize: OffsetWidget.setSp(14),
                          fontWeight: FontWightHelper.regular),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          amount == 0 ? "USD" : "CNY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: OffsetWidget.setSp(14),
                              fontWeight: FontWightHelper.semiBold),
                        ),
                        OffsetWidget.hGap(11),
                        LoadAssetsImage(
                          Constant.ASSETS_IMG +
                              "icon/arrow_dian_whiteright.png",
                          width: 6,
                          height: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                _cellTap(1),
              },
              child: Container(
                alignment: Alignment.center,
                height: OffsetWidget.setSc(46),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(73, 73, 73, 0.29),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(16),
                    right: OffsetWidget.setSc(16),
                    top: OffsetWidget.setSc(15)),
                padding: EdgeInsets.only(
                  left: OffsetWidget.setSc(11),
                  right: OffsetWidget.setSc(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "language".local(context: context),
                      style: TextStyle(
                        color: ColorUtils.rgba(153, 153, 153, 1),
                        fontSize: OffsetWidget.setSp(14),
                        fontWeight: FontWightHelper.regular,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          language == 0
                              ? "system_en".local(context: context)
                              : "system_zh_hans".local(context: context),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: OffsetWidget.setSp(14),
                              fontWeight: FontWightHelper.semiBold),
                        ),
                        OffsetWidget.hGap(11),
                        LoadAssetsImage(
                          Constant.ASSETS_IMG +
                              "icon/arrow_dian_whiteright.png",
                          width: 6,
                          height: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                _cellTap(2),
              },
              child: Container(
                alignment: Alignment.center,
                height: OffsetWidget.setSc(46),
                decoration: BoxDecoration(
                  color: ColorUtils.rgba(73, 73, 73, 0.29),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                    left: OffsetWidget.setSc(16),
                    right: OffsetWidget.setSc(16),
                    top: OffsetWidget.setSc(15)),
                padding: EdgeInsets.only(
                  left: OffsetWidget.setSc(11),
                  right: OffsetWidget.setSc(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "nodelist_title".local(context: context),
                      style: TextStyle(
                          color: ColorUtils.rgba(153, 153, 153, 1),
                          fontSize: OffsetWidget.setSp(14),
                          fontWeight: FontWightHelper.regular),
                    ),
                    LoadAssetsImage(
                      Constant.ASSETS_IMG + "icon/arrow_dian_whiteright.png",
                      width: 6,
                      height: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
