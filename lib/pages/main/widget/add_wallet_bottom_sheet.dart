import 'package:flutter/material.dart';
import 'package:flutter_coinid/public.dart';

class AddWalletBottomSheet extends StatelessWidget {
  const AddWalletBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: OffsetWidget.setSc(357),
      child: Column(
        children: [
          OffsetWidget.vGap(21),
          _title(),
          OffsetWidget.vGap(56),
          _createWallet(context, "create".local()),
          OffsetWidget.vGap(14),
          _lineView(),
          OffsetWidget.vGap(20),
          _createWallet(context, "import".local()),
          OffsetWidget.vGap(15),
          _lineView(),
          OffsetWidget.vGap(62),
          _createWallet(context, "dialog_cancel".local()),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      height: OffsetWidget.setSc(24),
      child: Text(
        "ethereum_wallet".local(),
        style: TextStyle(
          color: Colors.white,
          fontSize: OffsetWidget.setSp(20),
        ),
      ),
    );
  }

  Widget _createWallet(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
         Navigator.pop(context);
        if (title == "create".local()) {
          Routers.push(context, Routers.createPage);
        } else if (title == "import".local()) {
          String mcoinType =
              Constant.getChainSymbol(MCoinType.MCoinType_ETH.index);
          Routers.push(context, Routers.importPage,
              params: {"coinType": mcoinType});
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: OffsetWidget.setSc(24),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: OffsetWidget.setSp(20),
            fontWeight: title == "dialog_cancel".local()
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _lineView() {
    return Container(
      padding: EdgeInsets.only(
        left: OffsetWidget.setSc(59),
        right: OffsetWidget.setSc(59),
      ),
      alignment: Alignment.center,
      height: 1,
      color: ColorUtils.fromHex('#313452'),
    );
  }
}
