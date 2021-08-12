import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';

import '../../public.dart';

class ModifiySetPage extends StatefulWidget {
  ModifiySetPage({
    Key? key,
    this.setType = 0,
  }) : super(key: key);

  final int setType;

  @override
  _ModifiySetPageState createState() => _ModifiySetPageState();
}

class _ModifiySetPageState extends State<ModifiySetPage> {
  static String kName = "kName";
  static String kState = "kState";

  List datas = [];

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  void getDatas() async {
    int setType = widget.setType;
    List data = [];
    int datastate = 0;
    if (setType == 0) {
      datastate = await getAmountValue();
      data = [
        {
          kName: "USD",
          kState: false.toString(),
        },
        {
          kName: "CNY",
          kState: false.toString(),
        },
      ];
    } else {
      datastate = await getLanguageValue();
      data = [
        {
          kName: "system_en".local(context: context),
          kState: false.toString(),
        },
        {
          kName: "system_zh_hans".local(context: context),
          kState: false.toString(),
        },
      ];
    }
    data.forEach((element) {
      if (data[datastate] == element) {
        data[datastate][kState] = true.toString();
      }
    });
    setState(() {
      datas = data;
    });
  }

  void _cellTap(int index) {
    datas.forEach((element) {
      element[kState] = false.toString();
      if (datas[index] == element) {
        element[kState] = true.toString();
        LogUtil.v("_cellTap  " + element.toString());
      }
    });
    setState(() {});
    if (widget.setType == 0) {
      Provider.of<CurrentChooseWalletState>(context, listen: false)
          .updateCurrencyType(
              index == 0 ? MCurrencyType.USD : MCurrencyType.CNY);
    } else {
      updateLanguageValue(index);
      if (index == 0) {
        context.setLocale(Locale('en', 'US'));
      } else {
        context.setLocale(Locale('zh', 'CN'));
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    return CustomPageView(
        hiddenScrollView: true,
        title: CustomPageView.getDefaultTitle(
            titleStr: widget.setType == 0
                ? "system_currencychoose".local(context: context)
                : "system_languagechoose".local(context: context)),
        child: ListView.builder(
          itemCount: datas.length,
          itemBuilder: (BuildContext context, int index) {
            Map map = datas[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                _cellTap(index),
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
                      map[kName],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: OffsetWidget.setSp(12),
                          fontWeight: FontWightHelper.regular),
                    ),
                    LoadAssetsImage(
                      map[kState] == true.toString()
                          ? Constant.ASSETS_IMG + "icon/menu_select.png"
                          : Constant.ASSETS_IMG + "icon/menu_normal.png",
                      width: OffsetWidget.setSc(21),
                      height: OffsetWidget.setSc(21),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
