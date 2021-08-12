import 'package:flutter/material.dart';
import 'package:flutter_coinid/public.dart';
import 'package:url_launcher/url_launcher.dart';

class ListItemView extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String openUrl;

  const ListItemView(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.openUrl})
      : super(key: key);

  @override
  _ListItemViewState createState() => _ListItemViewState();
}

class _ListItemViewState extends State<ListItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: OffsetWidget.setSc(16),
        right: OffsetWidget.setSc(18),
        bottom: OffsetWidget.setSc(35),
      ),
      child: Row(
        children: [
          _imageView(),
          OffsetWidget.hGap(6),
          _textView(),
          OffsetWidget.hGap(19),
          _openUrlButton(),
        ],
      ),
    );
  }

  //图标
  Widget _imageView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(OffsetWidget.setSc(20)),
      child: Image.network(
        widget.imagePath,
        width: OffsetWidget.setSc(40),
        height: OffsetWidget.setSc(40),
      ),
    );
  }

  Widget _textView() {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            OffsetWidget.vGap(8),
            _subtitle(),
          ],
        ),
      ),
    );
  }

  //标题
  Widget _title() {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: OffsetWidget.setSp(14),
      ),
      textAlign: TextAlign.left,
    );
  }

  //子标题
  Widget _subtitle() {
    return Text(
      widget.subtitle,
      style: TextStyle(
        color: ColorUtils.fromHex('#999999'),
        fontSize: OffsetWidget.setSp(10),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  //跳转按钮
  Widget _openUrlButton() {
    return GestureDetector(
      onTap: () {
        launch(widget.openUrl);
      },
      child: Container(
        alignment: Alignment.center,
        width: OffsetWidget.setSp(64),
        height: OffsetWidget.setSp(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OffsetWidget.setSp(8)),
          border: Border.all(color: ColorUtils.fromHex('#4E6CDC'), width: 1),
        ),
        child: Text(
          'View',
          style: TextStyle(
            color: Colors.white,
            fontSize: OffsetWidget.setSp(12),
          ),
        ),
      ),
    );
  }
}
