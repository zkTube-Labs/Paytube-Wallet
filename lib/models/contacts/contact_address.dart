import 'package:floor/floor.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../public.dart';
import '../base_model.dart';

const String tableName = "contactAddress_table";

// @JsonSerializable()
@Entity(tableName: tableName)
class ContactAddress {
  @primaryKey
  String address;
  int coinType;
  String name;
  ContactAddress(this.address, this.coinType, this.name);

  Map<String, dynamic> toJson() {
    return {
      "address": this.address,
      "coinType": this.coinType,
      "name": this.name,
    };
  }

  static ContactAddress fromJson(Map<String, dynamic> json) {
    return ContactAddress(
      json['address'] as String,
      json['coinType'] as int,
      json['name'] as String,
    );
  }

  static Future<List<ContactAddress>> findAddressType(int coinType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<ContactAddress>? datas =
          await database?.addressDao.findAddressType(coinType);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static void insertAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      await database?.addressDao.insertAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return;
    }
  }

  static void deleteAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());

      await database?.addressDao.deleteAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());

      await database?.addressDao.updateAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }
}

@dao
abstract class ContactAddressDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE coinType = :coinType')
  Future<List<ContactAddress>> findAddressType(int coinType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAddress(ContactAddress model);

  @delete
  Future<void> deleteAddress(ContactAddress model);

  @update
  Future<void> updateAddress(ContactAddress model);
}
