import 'package:flutter/material.dart';
import '../public.dart';

class DeleteWalletCenterView extends StatefulWidget {
  final String subtitleText;
  const DeleteWalletCenterView({Key? key, required this.subtitleText})
      : super(key: key);

  @override
  _DeleteWalletCenterViewState createState() => _DeleteWalletCenterViewState();
}

class _DeleteWalletCenterViewState extends State<DeleteWalletCenterView> {
  @override
  Widget build(BuildContext context) {
    return _typeWithText();
  }

  ///中间widget为text
  Widget _typeWithText() {
    return Text(
      widget.subtitleText,
      style: TextStyle(
          color: ColorUtils.fromHex('#999999'),
          fontWeight: FontWeight.w400,
          fontSize: OffsetWidget.setSp(14),
          decoration: TextDecoration.none),
      textAlign: TextAlign.center,
    );
  }
}
