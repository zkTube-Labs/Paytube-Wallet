import 'dart:async';
import 'dart:isolate';

import 'package:floor/floor.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../public.dart';
import '../base_model.dart';

part 'collection_tokens.g.dart';

const String tableName = "tokens_table";

@JsonSerializable()
@Entity(tableName: tableName, primaryKeys: ["owner", "token"])
class MCollectionTokens {
  String? owner;
  String? contract;
  String? token;
  String? coinType;
  int? state;
  int? decimals;
  double? price;
  double? balance;
  int? digits;

  MCollectionTokens({
    this.owner,
    this.contract,
    this.token,
    this.coinType,
    this.state,
    this.decimals,
    this.price,
    this.balance,
    this.digits,
  });
  factory MCollectionTokens.fromJson(Map<String, dynamic> json) =>
      _$MCollectionTokensFromJson(json);
  Map<String, dynamic> toJson() => _$MCollectionTokensToJson(this);

  static Future<List<MCollectionTokens>> findTokens(String owner) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MCollectionTokens>? datas =
          await database?.tokensDao.findTokens(owner);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<MCollectionTokens>> findStateTokens(
      String s, int i) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MCollectionTokens> datas =
          await database?.tokensDao.findStateTokens(s, i) ?? [];
      for (var item in datas) {
        if (item.token == "ETH") {
          datas.remove(item);
          datas.insert(0, item);
        }
        if (item.token == "ZKTR") {
          datas.remove(item);
          datas.insert(1, item);
        }
      }
      return datas;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static void insertToken(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());

      await database?.tokensDao.insertToken(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void insertTokens(List<MCollectionTokens> models) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      await database?.tokensDao.insertTokens(models);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void deleteTokens(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());

      await database?.tokensDao.deleteTokens(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateTokens(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      await database?.tokensDao.updateTokens(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  String get assets =>
      StringUtil.dataFormat(((price ??= 0) * (balance ??= 0)), 2);

  bool get isToken =>
      coinType?.toLowerCase() == token?.toLowerCase() ? false : true;

  Future<String> tokenBalance() {
    Completer<String> completer = Completer();
    Future<String> future = completer.future;
    ChainServices.requestAssets(
        chainType: MCoinType.MCoinType_ETH.index,
        from: this.owner,
        contract: this.contract,
        token: token,
        tokenDecimal: this.decimals,
        block: (result, code) {
          if (code == 200) {}
        });

    return future;
  }
}

@dao
abstract class MCollectionTokenDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE owner = :owner')
  Future<List<MCollectionTokens>> findTokens(String owner);

  @Query(
      'SELECT * FROM ' + tableName + ' WHERE owner = :owner and state = :state')
  Future<List<MCollectionTokens>> findStateTokens(String owner, int state);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertToken(MCollectionTokens model);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<MCollectionTokens> models);

  @delete
  Future<void> deleteTokens(MCollectionTokens model);

  @update
  Future<void> updateTokens(MCollectionTokens model);
}
