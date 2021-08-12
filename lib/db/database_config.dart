import 'package:floor/floor.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/utils/log_util.dart';

class DataBaseConfig {
  static FlutterDatabase? fbase;

  //打开数据库
  // ignore: missing_return
  static Future<FlutterDatabase?> openDataBase() async {
    if (fbase != null) {
      return fbase;
    } else {
      // create migration
      final migration1to2 = Migration(
          dbCurrentVersion, dbCurrentVersion + 1, (migdatabase) async {});
      final callback = Callback(
        onCreate: (database, version) {
          LogUtil.v("数据库创建成功");
        },
        onOpen: (openDB) {
          LogUtil.v("数据库打开成功");
        },
        onUpgrade: (database, startVersion, endVersion) {},
      );

      fbase =
          await $FloorFlutterDatabase.databaseBuilder('zk_database.db').build();
      return fbase;
    }
  }
}
