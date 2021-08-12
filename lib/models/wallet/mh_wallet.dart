import 'dart:math';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coinid/channel/channel_memo.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';
import 'package:flutter_coinid/db/database.dart';
import 'package:flutter_coinid/models/assets/currency_list.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/wallet/sign/ethsignparams.dart';
import 'package:flutter_coinid/public.dart';
import 'package:flutter_coinid/utils/date_util.dart';
import 'package:flutter_coinid/utils/instruction_data_format.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_coinid/models/wallet/sign/methsign.dart';
import '../base_model.dart';
part 'mh_wallet.g.dart';

const String tableName = "wallet_table";

@JsonSerializable()
@Entity(tableName: tableName)
class MHWallet extends BaseModel {
  @primaryKey
  String? walletID; //唯一id  coinType|sha(pubKey)
  String? walletAaddress; //钱包地址
  String? pin; //密码
  String? pinTip; // 密码提示
  String? createTime; //钱包创建时间
  String? updateTime; //钱包修改时间
  bool? isChoose; //当前选中
  String? prvKey; //私钥
  String? pubKey; //公钥
  int? chainType; //链类型
  int? leadType; //导入类型
  int? originType; //来源类型
  String? masterPubKey; //主公钥
  String? descName; //自定义描述名称默认空字符

  MHWallet(
    this.walletID,
    this.walletAaddress,
    this.pin,
    this.pinTip,
    this.createTime,
    this.updateTime,
    this.isChoose,
    this.prvKey,
    this.pubKey,
    this.chainType,
    this.leadType,
    this.originType,
    this.masterPubKey,
    this.descName,
  );

  MHWallet.instance(WalletObject object) {
    walletAaddress = object.address;
    pin = "";
    pinTip = "";
    createTime = DateUtil.getNowDateStr();
    updateTime = createTime;
    isChoose = false;
    prvKey = object.prvKey;
    pubKey = object.pubKey;
    chainType = object.coinType;
    leadType = 0; //具体替换
    originType = 0; //具体替换
    masterPubKey = object.masterPubKey;
    descName = "";
    walletID = Constant.getChainSymbol(object.coinType) +
        "|" +
        InstructionDataFormat.SHA1(
            (walletAaddress == null || walletAaddress!.length == 0)
                ? pubKey
                : walletAaddress);

    MHWallet(
      walletID,
      walletAaddress,
      pin,
      pinTip,
      createTime,
      updateTime,
      isChoose,
      prvKey,
      pubKey,
      chainType,
      leadType,
      originType,
      masterPubKey,
      descName,
    );
  }

  String get fullName => Constant.getChainFullName(this.chainType);

  // Map<String, dynamic> toJson() => _$MHWalletToJson(this);

  static Future<MHWallet?> findWalletByWalletID(String walletID) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      MHWallet? wallet =
          await database?.walletDao.findWalletByWalletID(walletID);
      return wallet;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<MHWallet?> findChooseWallet() async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      MHWallet? wallet = await database?.walletDao.findChooseWallet();
      return wallet;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<MHWallet?> finDidChooseWallet() async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      MHWallet? wallet = await database?.walletDao.finDidChooseWallet();
      return wallet;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return null;
    }
  }

  static Future<List<MHWallet>> findWalletsByChainType(int chainType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MHWallet>? wallet =
          await database?.walletDao.findWalletsByChainType(chainType);
      return wallet ??= [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<MHWallet>> findWalletsByType(int originType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MHWallet>? wallet =
          await database?.walletDao.findWalletsByType(originType);
      return wallet ??= [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<MHWallet>> findWalletsByAddress(
      String walletAaddress, int chainType) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MHWallet>? wallet = await database?.walletDao
          .findWalletsByAddress(walletAaddress, chainType);
      return wallet ??= [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<MHWallet>> findAllWallets() async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      List<MHWallet>? wallet = await database?.walletDao.findAllWallets();
      return wallet ??= [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<bool> insertWallet(MHWallet wallet) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.insertWallet(wallet);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> insertWallets(List<MHWallet> wallets) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.insertWallets(wallets);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> updateChoose(MHWallet wallet) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      MHWallet? oldCHoose = await database?.walletDao.findChooseWallet();
      if (oldCHoose != null) {
        oldCHoose.isChoose = false;
        database?.walletDao.updateWallet(oldCHoose);
      }
      wallet.isChoose = true;
      database?.walletDao.updateWallet(wallet);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> updateDIDChoose(MHWallet wallet) async {
    try {
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> updateWallet(MHWallet wallet) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.updateWallet(wallet);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> updateWallets(List<MHWallet> wallets) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.updateWallets(wallets);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> deleteWallet(MHWallet wallet) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.deleteWallet(wallet);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> deleteWallets(List<MHWallet> wallets) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      database?.walletDao.deleteWallets(wallets);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<List<MHWallet>> findWalletsBySymbol(String symbol) async {
    try {
      FlutterDatabase? database = await (BaseModel.getDataBae());
      symbol = "symbol LIKE '%$symbol%'";
      List<MHWallet>? wallet =
          await database?.walletDao.findWalletsBySQL(symbol);
      return wallet ??= [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  void showLockPinDialog({
    required BuildContext context,
    required void Function(String? value) ok,
    required VoidCallback? cancle,
    required VoidCallback wrong,
    String tips = "",
  }) {
    showMHInputAlertView(
      context: context,
      title: "dialog_pwd".local(),
      placeholder: "wallet_inputpwd".local(),
      cancelPressed: cancle,
      confirmPressed: (value) => {
        lockPin(text: value, ok: ok, wrong: wrong),
      },
    );
  }

  bool lockPin({
    required String? text,
    required void Function(String? value)? ok,
    required VoidCallback? wrong,
  }) {
    if (this.pin == InstructionDataFormat.SHA1(text)) {
      LogUtil.v("pin验证成功");
      if (ok != null) {
        ok(text);
      }
      return true;
    } else {
      LogUtil.v("pin验证失败");
      if (wrong != null) {
        wrong();
      }
      return false;
    }
  }

  Future<String?>? sign({
    required String to,
    required String pin,
    required String value,
    String? jsonTran,
    required ETHSignParams ethSignParams,
  }) {
    assert(to != null, "转出地址不能为空");
    assert(pin != null, "pin不能为空");
    assert(value != null, "转账不能为空");

    if (this.chainType == MCoinType.MCoinType_ETH.index) {
      assert(ethSignParams != null, "eth签名数据不能为空");
      return this.ethsign(
        to: to,
        pin: pin,
        value: value,
        chainID: ethSignParams.chainID,
        data: ethSignParams.data,
        nonce: ethSignParams.nonce,
        decimal: ethSignParams.decimal,
        gasPrice: ethSignParams.gasPrice,
        gasLimit: ethSignParams.gasLimit,
        signType: ethSignParams.signType,
        contract: ethSignParams.contract,
      );
    }
  }

  //导出私钥
  Future<String?> exportPrv({required String pin}) async {
    assert(pin != null, "pin为空");
    try {
      String prv = this.prvKey!;
      int? type = this.chainType;
      WalletObject object = await ChannelWallet.exportPrvFrom(prv, pin, type);
      return object.prvKey;
    } catch (e) {
      LogUtil.v("exportPrv出错" + e.toString());
      return null;
    }
  }

  //导出keystore
  Future<String?> exportKeystore({required String pin}) async {
    assert(pin != null, "pin为空");
    try {
      String prv = this.prvKey!;
      int? type = this.chainType;
      WalletObject object =
          await ChannelWallet.exportKeyStoreFrom(prv, pin, type);
      return object.keyStore;
    } catch (e) {
      LogUtil.v("keyStore出错" + e.toString());
      return null;
    }
  }

  //生成方法
  static Future<MStatusCode> importWallet(
      {String content = "",
      String pin = "",
      String pintip = "",
      String walletName = "",
      MCoinType? mCoinType,
      MOriginType? mOriginType,
      MLeadType? mLeadType}) async {
    try {
      LogUtil.v(
          "importWallet $content pin $pin mCoinType $mCoinType mOriginType $mOriginType mLeadType $mLeadType");
      if (content.length == 0 || pin.length == 0) {
        return MStatusCode.MStatusCode_BaseFailere;
      }
      if (mLeadType == MLeadType.MLeadType_StandardMemo) {
        if (await ChannelMemos.checkMemoValid(content) == false) {
          return MStatusCode.MStatusCode_MemoInvalid;
        }
      }
      bool status = false;
      bool isExist = false;
      String masterPubKey = "";
      List<MHWallet> currentWallets = [];
      List<WalletObject> objects;
      List<MCollectionTokens> currentTokens = [];
      String hashPin = InstructionDataFormat.SHA1(pin);
      FlutterDatabase? database = await BaseModel.getDataBae();
      objects = await ChannelWallet.importWalletFrom(
          content.trim(), pin, mLeadType!, mCoinType!, mOriginType!);
      for (WalletObject w in objects) {
        MHWallet wallet = MHWallet.instance(w);
        wallet.originType = mOriginType.index;
        wallet.leadType = mLeadType.index;
        wallet.pin = hashPin;
        wallet.pinTip = pintip;
        wallet.descName = walletName;
        MHWallet? oldWallets = await database!.walletDao
            .findWalletByWalletID(wallet.walletID ?? "");
        for (var item in currency_List) {
          MCollectionTokens tokens = MCollectionTokens.fromJson(item);
          tokens.owner = wallet.walletAaddress;
          if (tokens.token == "ETH") {
            tokens.state = 1;
            //|| tokens.token == "ZKTR"
          } else {
            tokens.state = 0;
          }
          currentTokens.add(tokens);
          LogUtil.v("tokens " + tokens.toJson().toString());
        }

        if (oldWallets == null) {
          masterPubKey = wallet.masterPubKey!;
          status = true;
          currentWallets.add(wallet);
        } else {
          status = false;
          isExist = true;
          break;
        }
      }
      String? encMemo = "";
      if (mOriginType == MOriginType.MOriginType_Create ||
          mOriginType == MOriginType.MOriginType_Restore) {
        encMemo = await (ChannelNative.encKeyByAES128CBC(content, pin));
        if (encMemo == null || encMemo.length == 0) {
          status = false;
          LogUtil.v("加密助记词失败");
        }
      }
      if (status == true && isExist == false) {
        MHWallet? chooseWallet = await database!.walletDao.findChooseWallet();
        if (chooseWallet == null) {
          currentWallets.first.isChoose = true;
        }
        database.walletDao.insertWallets(currentWallets);
        database.tokensDao.insertTokens(currentTokens);
        if (mOriginType == MOriginType.MOriginType_Create ||
            mOriginType == MOriginType.MOriginType_Restore) {}
        return MStatusCode.MStatusCode_Success;
      } else {
        if (isExist) {
          LogUtil.v("查找到有已经导入的钱包");
          return MStatusCode.MStatusCode_Exist;
        }
        if (mLeadType == MLeadType.MLeadType_KeyStore) {
          LogUtil.v("私钥与密码不匹配");
          return MStatusCode.MStatusCode_KeystorePwdInvalid;
        }
        if (mLeadType == MLeadType.MLeadType_Prvkey) {
          LogUtil.v("生成公私钥失败");
          return MStatusCode.MStatusCode_PrvKeyInvalid;
        }
        return MStatusCode.MStatusCode_BaseFailere;
      }
    } catch (e) {
      LogUtil.v("钱包数据插入失败" + e.toString());
      return MStatusCode.MStatusCode_Failere;
    }
  }

  static String configFeeValue({
    required int? cointype,
    required String? beanValue, // sat price
    required String offsetValue, //len
  }) {
    double feeValue = 0.0;
    if (cointype == MCoinType.MCoinType_ETH.index) {
      BigInt gasValue = BigInt.tryParse(beanValue!)! * BigInt.from(10).pow(9);
      gasValue = gasValue * BigInt.tryParse(offsetValue)!;
      feeValue = gasValue / BigInt.from(10).pow(18);
    }
    LogUtil.v("手续费beanValue $beanValue  offsetValue $offsetValue 计算是 " +
        feeValue.toStringAsFixed(6));
    return feeValue.toStringAsFixed(6);
  }

  static Future<Map?> convertUTXOWithSpent({
    required int coinType,
    required List utxoList,
    required String to,
    required String from,
    required int segwit,
    required String transAmount,
    required String feeValue,
    required Function(String) newFeeBack,
  }) async {
    assert(utxoList != null, "utxo is null");

    Map rootDic = Map();
    List inputArr = [];
    List outputArr = [];
    BigInt amount = BigInt.tryParse(transAmount)! * BigInt.from(pow(10, 8));
    BigInt fee = BigInt.from(double.parse(feeValue) * pow(10, 8));
    BigInt allValue = amount + fee;
    int m, n;
    m = 1;
    n = 1;
    LogUtil.v("amount $amount fee $fee allValue $allValue");
    String coinTypeStr = Constant.getChainSymbol(coinType).toLowerCase();
    BigInt currentValue = BigInt.zero;
    try {
      String? utxoValues = await (ChannelNative.filterUTXO(
          JsonUtil.encodeObj(utxoList) ?? ,
          amount.toString(),
          fee.toString(),
          m,
          n,
          coinTypeStr));

      Map? utxoDic = JsonUtil.getObj(utxoValues);
      if (utxoDic == null) {
        return null;
      }
      LogUtil.v("utxoDic " + utxoDic.toString());
      List utxos = utxoDic["utxo"];
      String? change = utxoDic["change"]; //找零 0
      String newfee = utxoDic["fee"]; //手续费 236600
      if (newFeeBack != null) {
        newFeeBack(newfee);
      }
      String newamount = utxoDic["amount"]; //转出金额 93397300
      fee = BigInt.tryParse(newfee)!;
      amount = BigInt.tryParse(newamount)!;
      allValue = amount + fee;
      List<Map<String, dynamic>> datas = [];
      for (var item in utxos) {
        Map<String, dynamic> params = Map();
        params["tx_hash"] = item["tx_hash"] as String?;
        params["tx_pos"] = item["tx_pos"];
        params["value"] = item["value"];
        params["height"] = item["height"];
        datas.add(params);
      }

      int sequence = 4294967295;
      rootDic["lock_time"] = 0;
      rootDic["segwit"] = segwit;
      rootDic["cointype"] = coinTypeStr;
      if (coinTypeStr.toLowerCase() == "btc" ||
          coinTypeStr.toLowerCase() == "usdt") {
        rootDic["version"] = 1;
      }
      for (Map item in utxoList as Iterable<Map<dynamic, dynamic>>) {
        num a = item["value"] as num;
        currentValue = currentValue + BigInt.from(a);
        Map inputDic = Map();
        inputDic["amount"] = a;
        inputDic["index"] = item["tx_pos"];
        inputDic["prev_hash"] = item["tx_hash"];
        inputDic["sequence"] = sequence;
        inputArr.add(inputDic);
        if (currentValue >= allValue) {
          if (coinTypeStr.toLowerCase() == "usdt") {
            Map toParams = Map();
            toParams["address"] = to;
            toParams["value"] = 546;
            outputArr.add(toParams);

            Map usParams = Map();
            usParams["address"] = "";
            usParams["value"] = amount.toInt();
            outputArr.add(usParams);
          } else {
            Map toParams = Map();
            toParams["address"] = to;
            toParams["value"] = amount.toInt();
            outputArr.add(toParams);
          }
          BigInt cash = currentValue - allValue;
          if (cash > BigInt.zero) {
            Map cashParams = Map();
            cashParams["address"] = from;
            cashParams["value"] = cash.toInt();
            outputArr.add(cashParams);
          }
          break;
        }
      }
      rootDic["inputs"] = inputArr;
      rootDic["outputs"] = outputArr;
      if (inputArr.length == 0 || outputArr.length == 0) {
        return null;
      }
      return rootDic;
    } catch (e) {
      LogUtil.v("filterUTXO出错" + e.toString());
      return null;
    }
  }
}

@dao
abstract class MHWalletDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE walletID = :walletID')
  Future<MHWallet?> findWalletByWalletID(String walletID);

  @Query('SELECT * FROM ' + tableName + ' WHERE isChoose = 1')
  Future<MHWallet?> findChooseWallet();

  @Query('SELECT * FROM ' + tableName + ' WHERE didChoose = 1')
  Future<MHWallet?> finDidChooseWallet();

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE chainType = :chainType ORDER BY "index"')
  Future<List<MHWallet>> findWalletsByChainType(int chainType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE originType = :originType ORDER BY "index"')
  Future<List<MHWallet>> findWalletsByType(int originType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE walletAaddress = :walletAaddress and chainType = :chainType')
  Future<List<MHWallet>> findWalletsByAddress(
      String walletAaddress, int chainType);

  //自动生成的有问题需要自己写sql
  @Query('SELECT * FROM ' + tableName + ' WHERE :sql ' + ' ORDER BY "index"')
  Future<List<MHWallet>> findWalletsBySQL(String sql);

  @Query('SELECT * FROM ' + tableName + ' ORDER BY "index"')
  Future<List<MHWallet>> findAllWallets();

  @Query('SELECT * FROM ' + tableName)
  Stream<List<MHWallet>> findAllWalletsAsStream();

  @insert
  Future<void> insertWallet(MHWallet wallet);

  @insert
  Future<void> insertWallets(List<MHWallet> wallet);

  @update
  Future<void> updateWallet(MHWallet wallet);

  @update
  Future<void> updateWallets(List<MHWallet> wallet);

  @delete
  Future<void> deleteWallet(MHWallet wallet);

  @delete
  Future<void> deleteWallets(List<MHWallet> wallet);
}
