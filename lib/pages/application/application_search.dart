import 'package:flutter_coinid/net/wallet_services.dart';
import '../../public.dart';
import 'widget/list_item_widget.dart';
import 'dart:ui';

class ApplicationSearch extends StatefulWidget {
  //判断跳转到交易所 'exchange' ;'currency'币种
  final String type;

  ApplicationSearch({Key? key, required this.type}) : super(key: key);

  @override
  _ApplicationSearchState createState() => _ApplicationSearchState();
}

class _ApplicationSearchState extends State<ApplicationSearch> {
  TextEditingController _searchEC = TextEditingController();
  bool isSearch = true;
  double _height = MediaQueryData.fromWindow(window).size.height;
  double _topBarH = MediaQueryData.fromWindow(window).padding.top;
  double _botBarH = MediaQueryData.fromWindow(window).padding.bottom;

  List _exploreModelList = [];

  @override
  void initState() {
    print('type = ' + widget.type);

    HWToast.showLoading();
    WalletServices.getExploreData(widget.type).then((value) {
      HWToast.hiddenAllToast();
      if (value != null) {
        print(value);
        setState(() {
          _exploreModelList = value[widget.type];
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenAppBar: true,
      hiddenLeading: true,
      hiddenScrollView: false,
      child: Container(
        padding: EdgeInsets.only(
          right: OffsetWidget.setSc(16),
          left: OffsetWidget.setSc(16),
        ),
        child: Column(
          children: [
            getCustomAppBar(),
            OffsetWidget.vGap(28),
            _listView(),
          ],
        ),
      ),
    );
  }

  //列表
  Widget _listView() {
    return Container(
      height: (_height - _topBarH - _botBarH - 30 - 40),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _exploreModelList.length,
          itemBuilder: (context, index) {
            return ListItemView(
                imagePath: _exploreModelList[index]['avatar_url'],
                title: _exploreModelList[index]['title'],
                subtitle: _exploreModelList[index]['subtitle'],
                openUrl: _exploreModelList[index]['open_url']);
          }),
    );
  }

  //返回按钮  搜索框先去掉
  Widget getCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => {
            Routers.goBack(context),
          },
          child: Container(
            // height: OffsetWidget.setSc(30),
            padding: EdgeInsets.only(right: 5, top: OffsetWidget.setSc(20)),
            alignment: Alignment.centerLeft,
            child: LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_goback.png",
              scale: 2,
            ),
          ),
        ),
      ],
    );
  }
}
