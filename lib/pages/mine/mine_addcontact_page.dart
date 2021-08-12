import 'package:flutter_coinid/channel/channel_scan.dart';
import 'package:flutter_coinid/models/contacts/contact_address.dart';

import '../../public.dart';

class MineAddContact extends StatefulWidget {
  MineAddContact({Key? key}) : super(key: key);

  @override
  _MineAddContactState createState() => _MineAddContactState();
}

class _MineAddContactState extends State<MineAddContact> {
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _addEC = TextEditingController();

  void tapNewAdds() {
    String _name = _nameEC.text.trim();
    String _add = _addEC.text.trim();
    if (_name.length == 0) {
      HWToast.showText(text: "wallet_inputname".local());
      return;
    }
    if (_add.length == 0) {
      HWToast.showText(text: "wallet_inputaddress".local());
      return;
    }

    ContactAddress model =
        ContactAddress(_add, MCoinType.MCoinType_ETH.index, _name);
    ContactAddress.insertAddress(model);
    HWToast.showText(text: "wallet_inputok".local());
    Routers.goBackWithParams(context, {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenScrollView: true,
      title:
          CustomPageView.getDefaultTitle(titleStr: "wallet_newcontact".local()),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            String? value = await ChannelScan.scan();
            _addEC.text = value ?? "";
          },
          child: Container(
            padding: EdgeInsets.only(right: 15),
            height: 45,
            width: 45,
            alignment: Alignment.centerRight,
            child: LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_scan.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            CustomTextField(
              controller: _nameEC,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              style: TextStyle(
                color: ColorUtils.rgba(153, 153, 153, 1),
                fontSize: OffsetWidget.setSp(12) ,
                fontWeight: FontWightHelper.regular,
              ),
              decoration: CustomTextField.getBorderLineDecoration(
                hintText: "name",
                hintStyle: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12) ,
                  fontWeight: FontWightHelper.regular,
                ),
              ),
            ),
            CustomTextField(
              controller: _addEC,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              style: TextStyle(
                color: ColorUtils.rgba(153, 153, 153, 1),
                fontSize: OffsetWidget.setSp(12) ,
                fontWeight: FontWightHelper.regular,
              ),
              decoration: CustomTextField.getBorderLineDecoration(
                hintText: "address",
                hintStyle: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12) ,
                  fontWeight: FontWightHelper.regular,
                ),
              ),
            ),
          ]),
          GestureDetector(
            onTap: tapNewAdds,
            child: Container(
              height: OffsetWidget.setSc(46) ,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  bottom: OffsetWidget.setSc(81) ,
                  left: OffsetWidget.setSc(36) ,
                  right: OffsetWidget.setSc(36) ),
              decoration: BoxDecoration(
                color: ColorUtils.rgba(78, 108, 220, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "wallet_complete".local(),
                style: TextStyle(
                    fontWeight: FontWightHelper.semiBold,
                    fontSize: OffsetWidget.setSp(20) ,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
