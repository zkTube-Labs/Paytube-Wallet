import 'package:floor/floor.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/log_util.dart';
import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

part 'trans_record.g.dart';

const String tableName = "translist_table";

@JsonSerializable()
@Entity(tableName: tableName)
class TransRecordModel {
  @primaryKey
  String? txid; //交易ID
  String? toAdd; //to
  String? fromAdd; //from
  String? date; //时间
  String? amount; //金额
  String? remarks; //备注
  String? fee; //手续费
  String? gasPrice;
  String? gasLimit;
  int? transStatus; //0失败 1成功
  String? symbol; //转账符号
  String? coinType;
  //自定义字段
  int? transType; //类型
  int? chainid; //哪条链

  TransRecordModel({
    this.txid,
    this.toAdd,
    this.fromAdd,
    this.date,
    this.amount,
    this.remarks,
    this.fee,
    this.transStatus,
    this.symbol,
    this.coinType,
    this.gasLimit,
    this.gasPrice,
    this.transType,
    this.chainid,
  });

  factory TransRecordModel.fromJson(Map<String, dynamic> json) =>
      _$TransRecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransRecordModelToJson(this);

  static Future<List<TransRecordModel>> queryTrxList(
      String from, String symbol, int chainid) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<TransRecordModel>? datas =
          await database?.transListDao.queryTrxList(from, symbol, chainid);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<TransRecordModel>> queryTrxFromTrxid(String txid) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<TransRecordModel>? datas =
          await database?.transListDao.queryTrxFromTrxid(txid);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static void insertTrxList(TransRecordModel model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.transListDao.insertTrxList(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void insertTrxLists(List<TransRecordModel> models) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.transListDao.insertTrxLists(models);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void deleteTrxList(TransRecordModel model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.transListDao.deleteTrxList(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateTrxList(TransRecordModel model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.transListDao.updateTrxList(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateTrxLists(List<TransRecordModel> models) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.transListDao.updateTrxLists(models);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }
}

@dao
abstract class TransRecordModelDao {
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd or toAdd = :fromAdd)  and symbol = :symbol and chainid = :chainid')
  Future<List<TransRecordModel>> queryTrxList(
      String fromAdd, String symbol, int chainid);

  @Query('SELECT * FROM ' + tableName + ' WHERE txid = :txid')
  Future<List<TransRecordModel>> queryTrxFromTrxid(String txid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTrxList(TransRecordModel model);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTrxLists(List<TransRecordModel> models);

  @delete
  Future<void> deleteTrxList(TransRecordModel model);

  @update
  Future<void> updateTrxList(TransRecordModel model);

  @update
  Future<void> updateTrxLists(List<TransRecordModel> models);
}
