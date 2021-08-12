import 'package:flutter/material.dart';
import '../public.dart';

class NodeUrlAlertCenterView extends StatefulWidget {
  final Function(String text) nodeControllerCallBack1;
  final Function(String text) nodeControllerCallBack2;
  const NodeUrlAlertCenterView(
      {Key? key,
      required this.nodeControllerCallBack1,
      required this.nodeControllerCallBack2})
      : super(key: key);

  @override
  _NodeUrlAlertCenterViewState createState() => _NodeUrlAlertCenterViewState();
}

class _NodeUrlAlertCenterViewState extends State<NodeUrlAlertCenterView> {
  TextEditingController _nodeController1 =
      TextEditingController(text: 'https://');
  TextEditingController _nodeController2 = TextEditingController();

  @override
  void initState() {
    _nodeController1.addListener(() {
      widget.nodeControllerCallBack1(_nodeController1.text);
    });
    _nodeController2.addListener(() {
      widget.nodeControllerCallBack2(_nodeController2.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _nodeUrl();
  }

  ///node Url  widget
  Widget _nodeUrl() {
    return Container(
      child: Column(
        children: [
          _customTextField(_nodeController1),
          OffsetWidget.vGap(11),
          _customTextField(_nodeController2),
        ],
      ),
    );
  }

  Widget _customTextField(TextEditingController controller) {
    return CustomTextField(
      controller: controller,
      maxLines: 1,
      style: TextStyle(
        color: ColorUtils.rgba(222, 224, 223, 1),
        fontSize: OffsetWidget.setSp(16),
        fontWeight: FontWightHelper.regular,
      ),
      decoration: CustomTextField.getBorderLineDecoration(
        hintText: "chainId".local(),
        fillColor: ColorUtils.fromHex('#262449'),
        borderColor: ColorUtils.fromHex('#4D5CB2'),
        contentPadding: EdgeInsets.only(
            left: OffsetWidget.setSc(10),
            right: OffsetWidget.setSc(10),
            top: OffsetWidget.setSc(8)),
        helperStyle: TextStyle(
          color: ColorUtils.rgba(222, 224, 223, 1),
          fontWeight: FontWightHelper.regular,
          fontSize: OffsetWidget.setSp(14),
        ),
        hintStyle: TextStyle(
            color: ColorUtils.rgba(222, 224, 223, 1),
            fontWeight: FontWightHelper.regular,
            fontSize: OffsetWidget.setSp(16)),
      ),
    );
  }
}
