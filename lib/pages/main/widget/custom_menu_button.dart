import 'package:flutter/material.dart';
import 'package:flutter_coinid/constant/constant.dart';
import 'package:flutter_coinid/utils/font_weight.dart';
import 'package:flutter_coinid/utils/offset.dart';
import 'package:flutter_coinid/widgets/custom_image.dart';

import '../wallets_manager_lists.dart';
import 'add_wallet_bottom_sheet.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getCustomMenuButton(context);
  }

  ///左右两边按钮
  Widget _getCustomMenuButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _leftButton(context),
        _rightButton(context),
      ],
    );
  }

  ///左边按钮
  Widget _leftButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        showModalBottomSheet(
            context: context,
            backgroundColor: ColorUtils.rgba(40, 33, 84, 1),
            elevation: 0,
            isDismissible: true,
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            builder: (context) {
              return SafeArea(child: WalletsMangerList());
            }),
      },
      child: Container(
        padding: EdgeInsets.only(left: OffsetWidget.setSc(15)),
        alignment: Alignment.centerLeft,
        child: LoadAssetsImage(
          Constant.ASSETS_IMG + "icon/icon_menu.png",
          width: OffsetWidget.setSc(34),
          height: OffsetWidget.setSc(34),
        ),
      ),
    );
  }

  ///右边按钮
  Widget _rightButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: ColorUtils.rgba(40, 33, 84, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            builder: (context) {
              return AddWalletBottomSheet();
            });
      },
      child: Container(
        padding: EdgeInsets.only(right: OffsetWidget.setSc(15)),
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_addwallet.png",
              width: 24,
              height: 24,
            ),
            OffsetWidget.hGap(3),
            Text(
              "Add wallet",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: OffsetWidget.setSp(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
