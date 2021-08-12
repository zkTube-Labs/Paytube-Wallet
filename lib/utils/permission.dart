import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../public.dart';
import 'log_util.dart';

class PermissionUtils {
  static Future<bool> checkBlePermissions() async {
    if (Constant.isAndroid) {
      if (await Permission.location.isGranted == true) {
        LogUtil.v("Permission  true");
        return true;
      }
      PermissionStatus status = await Permission.location.request();
      LogUtil.v("Permission  $status");
      return status == PermissionStatus.granted ? true : false;
    }
    return true;
  }

  static Future<bool> checkCamera() async {
    if (await Permission.camera.isGranted == true) {
      LogUtil.v("Permission  true");
      return true;
    }
    PermissionStatus status = await Permission.camera.request();
    LogUtil.v("Permission  $status");
    if (status != PermissionStatus.granted) {
      //加入权限
      HWToast.showText(text: "permission_err".local());
    }
    return status == PermissionStatus.granted ? true : false;
  }

  static Future<bool> checkStoragePermissions() async {
    if (await Permission.storage.isGranted == true) {
      return true;
    } else {
      PermissionStatus status = await Permission.storage.request();
      LogUtil.v("Permission  $status");
      return status == PermissionStatus.granted ? true : false;
    }
  }

  /// 权限提示对话款
  static showDialog(
      BuildContext cxt, String title, String content, ok(), cancel()) {
    showCupertinoDialog<int>(
        context: cxt,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("去开启"),
                onPressed: () {
                  ok();
                },
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  cancel();
                },
              )
            ],
          );
        });
  }
}
