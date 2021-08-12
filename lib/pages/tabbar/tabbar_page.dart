import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/pages/application/application_page.dart';
import 'package:flutter_coinid/pages/main/main_page.dart';
import 'package:flutter_coinid/pages/mine/mine_page.dart';
import 'package:provider/provider.dart';
import '../../public.dart';

class TabbarPage extends StatefulWidget {
  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  //底部导航栏的图标
  final List<List<String>> _imageList = [
    [
      '${Constant.ASSETS_IMG}tabbar/tabbar_wallet_unselect.png',
      '${Constant.ASSETS_IMG}tabbar/tabbar_wallet_select.png'
    ],
    [
      '${Constant.ASSETS_IMG}tabbar/tabbar_app_unselect.png',
      '${Constant.ASSETS_IMG}tabbar/tabbar_app_select.png'
    ],
    [
      '${Constant.ASSETS_IMG}tabbar/tabbar_mine_unselect.png',
      '${Constant.ASSETS_IMG}tabbar/tabbar_mine_select.png'
    ],
  ];
  //底部导航栏的名称
  // final List<String> _titles = [
  //   '${"main_assets".local}',
  //   '${"application".local}',
  //   '${"my".local}'
  // ];
  //底部导航栏对应的页面
  final List<Widget> _pagesList = [MainPage(), ApplicationPage(), MinePage()];
  PageController? _pageController;
  int _currentIndex = 0;
  int _exitTime = 0;

  @override
  void initState() {
    this._pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
    Provider.of<CurrentChooseWalletState>(context, listen: false).loadWallet();
    Provider.of<MNodeState>(context, listen: false).loadNode();
    super.initState();
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    EasyLocalization.of(context)!.delegates;
    return WillPopScope(
      onWillPop: () async {
        if (DateUtil.getNowDateMs() - _exitTime > 2000) {
          HWToast.showText(text: 'exit_hint'.local());
          _exitTime = DateUtil.getNowDateMs();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return true;
      },
      child: CustomPageView(
        hiddenScrollView: true,
        hiddenAppBar: true,
        safeAreaTop: false,
        hiddenLeading: true,
        bottomNavigationBar: _bottomAppBar(),
        child: PageView(
          children: _pagesList,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  BottomAppBar _bottomAppBar() {
    double width = MediaQuery.of(context).size.width;
    double height = OffsetWidget.setSc(82);

    return BottomAppBar(
      color: Colors.transparent,
      child: Container(
        //设置背景
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            image: AssetImage(Constant.ASSETS_IMG + "tabbar/tabbar_bg.png"),
          ),
        ),
        width: width,
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _customItems(),
        ),
      ),
    );
  }

  /*获取tab图片*/
  Widget getTabIcon(int index) {
    if (_currentIndex == index) {
      return Image.asset(
        _imageList[index][1],
        width: OffsetWidget.setSc(58),
        height: OffsetWidget.setSc(58),
      );
    }
    return Image.asset(
      _imageList[index][0],
      width: OffsetWidget.setSc(30),
      height: OffsetWidget.setSc(30),
    );
  }

  /*获取tabbatItem*/
  List<BottomNavigationBarItem> getItems() {
    return [
      BottomNavigationBarItem(
        icon: getTabIcon(0),
      ),
      BottomNavigationBarItem(icon: getTabIcon(1)),
      BottomNavigationBarItem(icon: getTabIcon(2)),
      BottomNavigationBarItem(icon: getTabIcon(3)),
    ];
  }

  List<Widget> _customItems() {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = width / _imageList.length;
    return _imageList.map((img) {
      int index = _imageList.indexOf(img);
      return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _pageController!.jumpToPage(index);
          });
        },
        child: Container(
          color: Colors.transparent,
          width: itemWidth * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getTabIcon(index),
            ],
          ),
        ),
      );
    }).toList();
  }
}
