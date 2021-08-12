// import 'dart:html';

import 'package:floor/floor.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/net/chain_services.dart';

import '../../public.dart';
import '../base_model.dart';

const String tableName = "nodes_table";

@Entity(tableName: tableName, primaryKeys: ["content", "chainType"])
class NodeModel {
  String content;
  int chainType;
  bool isChoose;
  bool isDefault; //0
  bool isMainnet; //类型
  int chainID; //ID

  NodeModel(this.content, this.chainType, this.isChoose, this.isDefault,
      this.isMainnet, this.chainID);

  static Future<bool> insertNodeDatas(List<NodeModel> list) async {
    try {
      FlutterDatabase? database = await BaseModel.getDataBae();
      database?.nodeDao.insertNodeDatas(list);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
    return false;
  }

  static Future<bool> insertNodeData(NodeModel model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.nodeDao.insertNodeData(model);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
    return false;
  }

  static Future<List<NodeModel>?> queryNodeByChainType(int chainType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      return database?.nodeDao.queryNodeByChainType(chainType);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<List<NodeModel>?> queryNodeByIsChoose(bool isChoose) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      return database?.nodeDao.queryNodeByIsChoose(isChoose);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<List<NodeModel>?> queryNodeByContent(String content) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      return database?.nodeDao.queryNodeByContent(content);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<List<NodeModel>?> queryNodeByIsDefaultAndChainType(
      bool isDefault, int chainType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      return database?.nodeDao
          .queryNodeByIsDefaultAndChainType(isDefault, chainType);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<List<NodeModel>?> queryNodeByContentAndChainType(
      String content, int chainType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      return database?.nodeDao
          .queryNodeByContentAndChainType(content, chainType);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<bool> updateNode(NodeModel model) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.nodeDao.updateNode(model);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> updateNodes(List<NodeModel> models) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.nodeDao.updateNodes(models);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static void configNodeList() async {
    List<NodeModel>? nodes = await NodeModel.queryNodeByIsChoose(true);
    if (nodes == null || nodes.length == 0) {
      nodes = [];
      //eth
      nodes.add(NodeModel(
          "https://mainnet.infura.io/v3/0338da10bb39416c8fe2507370eeef8b",
          MCoinType.MCoinType_ETH.index,
          true,
          true,
          true,
          1));
      nodes.add(NodeModel(
          "https://rinkeby.infura.io/v3/0338da10bb39416c8fe2507370eeef8b",
          MCoinType.MCoinType_ETH.index,
          false,
          true,
          false,
          4));
      NodeModel.insertNodeDatas(nodes);
    } else {
      nodes.forEach((element) {
        if (element.chainType == MCoinType.MCoinType_ETH.index &&
            element.isChoose == true) {
          ChainServices.currentNode = element;
        }
      });
    }
  }
}

@dao
abstract class NodeDao {
  @Insert()
  Future<void> insertNodeDatas(List<NodeModel> list);

  @Insert()
  Future<void> insertNodeData(NodeModel model);

  @Query('SELECT * FROM $tableName WHERE isChoose = :isChoose')
  Future<List<NodeModel>> queryNodeByIsChoose(bool isChoose);

  @Query('SELECT * FROM $tableName WHERE chainType = :chainType')
  Future<List<NodeModel>> queryNodeByChainType(int chainType);

  @Query('SELECT * FROM $tableName WHERE content = :content')
  Future<List<NodeModel>> queryNodeByContent(String content);

  @Query(
      'SELECT * FROM $tableName WHERE isDefault = :isDefault And chainType = :chainType')
  Future<List<NodeModel>> queryNodeByIsDefaultAndChainType(
      bool isDefault, int chainType);

  @Query(
      'SELECT * FROM $tableName WHERE content = :content And chainType = :chainType')
  Future<List<NodeModel>> queryNodeByContentAndChainType(
      String content, int chainType);

  @update
  Future<void> updateNode(NodeModel model);

  @update
  Future<void> updateNodes(List<NodeModel> models);
}
