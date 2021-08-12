import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../public.dart';

showAlertView({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback cancelPressed,
  required VoidCallback confirmPressed,
}) {}

showMHAlertView({
  required BuildContext context,
  String? title,
  String? content,
  TextStyle contentStyle = const TextStyle(
    color: Color(0xFF161D2D),
    fontSize: 16,
    fontWeight: FontWightHelper.regular,
  ),
  VoidCallback? cancelPressed,
  VoidCallback? confirmPressed,
}) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title == null
              ? null
              : Text(
                  title,
                ),
          content: Column(
            children: [
              Text(
                content!,
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "dialog_cancel".local(),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (cancelPressed != null) {
                  cancelPressed();
                }
              },
            ),
            CupertinoDialogAction(
                child: Text(
                  "dialog_confirm".local(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (confirmPressed != null) {
                    confirmPressed();
                  }
                }),
          ],
        );
      });
}

showMHInputAlertView({
  required BuildContext context,
  String? title,
  TextStyle titleStyle = const TextStyle(
    color: Color(0xFF161D2D),
    fontSize: 20,
    fontWeight: FontWightHelper.semiBold,
  ),
  String placeholder = "",
  String placeValue = "",
  String? content,
  bool obscureText = true,
  TextStyle contentStyle = const TextStyle(
    color: Color(0xFF161D2D),
    fontSize: 16,
    fontWeight: FontWightHelper.regular,
  ),
  VoidCallback? cancelPressed,
  Function(String value)? confirmPressed,
}) {
  TextEditingController controller = TextEditingController(text: placeValue);

  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title!,
          ),
          content: Column(
            children: [
              CupertinoTextField(
                maxLines: 1,
                controller: controller,
                obscureText: obscureText,
                autofocus: true,
                placeholder: placeholder,
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "dialog_cancel".local(),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (cancelPressed != null) {
                  cancelPressed();
                }
              },
            ),
            CupertinoDialogAction(
                child: Text(
                  "dialog_confirm".local(),
                ),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (confirmPressed != null) {
                    confirmPressed(controller.text);
                  }
                }),
          ],
        );
      });
}

showInputNodeAlertView({
  required BuildContext context,
  String? title,
  TextStyle titleStyle = const TextStyle(
    color: Color(0xFF161D2D),
    fontSize: 20,
    fontWeight: FontWightHelper.semiBold,
  ),
  String placeholder = "",
  String placeValue = "",
  String? content,
  bool obscureText = true,
  TextStyle contentStyle = const TextStyle(
    color: Color(0xFF161D2D),
    fontSize: 16,
    fontWeight: FontWightHelper.regular,
  ),
  VoidCallback? cancelPressed,
  Function(String value, String chainid)? confirmPressed,
}) {
  TextEditingController controller = TextEditingController(text: placeValue);
  TextEditingController controller2 = TextEditingController();

  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title!,
          ),
          content: Column(
            children: [
              CupertinoTextField(
                maxLines: 1,
                controller: controller,
                obscureText: obscureText,
                autofocus: true,
                placeholder: placeholder,
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              ),
              OffsetWidget.vGap(5),
              CupertinoTextField(
                maxLines: 1,
                controller: controller2,
                obscureText: obscureText,
                autofocus: true,
                placeholder: "chainid",
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "dialog_cancel".local(),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (cancelPressed != null) {
                  cancelPressed();
                }
              },
            ),
            CupertinoDialogAction(
                child: Text(
                  "dialog_confirm".local(),
                ),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (confirmPressed != null) {
                    confirmPressed(controller.text, controller2.text);
                  }
                }),
          ],
        );
      });
}
