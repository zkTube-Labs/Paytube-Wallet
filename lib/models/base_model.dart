import 'dart:convert';

import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/db/database_config.dart';

class BaseModel {
  static Future<FlutterDatabase?> getDataBae() {
    return DataBaseConfig.openDataBase();
  }
}
