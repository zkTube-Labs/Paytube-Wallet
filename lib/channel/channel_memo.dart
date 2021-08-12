import 'package:flutter/services.dart';
import 'package:flutter_coinid/constant/constant.dart';

class ChannelMemosObjects {
  List? cnMemos;
  List? enMemos;
  List? cnStandMemos;
  List? enStandMemos;

  ChannelMemosObjects(
      {this.cnMemos, this.enMemos, this.cnStandMemos, this.enStandMemos});

  ChannelMemosObjects.fromJson(Map<dynamic, dynamic> json) {
    cnMemos = json['cnMemos'];
    enMemos = json['enMemos'];
    cnStandMemos = json['cnStandMemos'];
    enStandMemos = json['enStandMemos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, List?>();
    data["cnMemos"] = cnMemos;
    data["enMemos"] = enMemos;
    data["cnStandMemos"] = cnStandMemos;
    data["enStandMemos"] = enStandMemos;
    return data;
  }
}

//助记词相关
class ChannelMemos {
  static const channel_memo = MethodChannel(Constant.CHANNEL_Memos);

  //创建助记词 助记词长度
  //return  map {
  // cnMemos: list
  // enMemos:  list
  // cnStandMemos: list
  // enStandMemos:  list
  // }
  static Future<ChannelMemosObjects> createWalletMemo(
      MemoCount memoCount) async {
    int count = 12;
    if (memoCount == MemoCount.MemoCount_12) {
      count = 12;
    }
    if (memoCount == MemoCount.MemoCount_18) {
      count = 18;
    }
    if (memoCount == MemoCount.MemoCount_24) {
      count = 24;
    }
    final Map result =
        await (channel_memo.invokeMethod('createWalletMemo', count));

    ChannelMemosObjects memosObjects = ChannelMemosObjects.fromJson(result);
    return Future.value(memosObjects);
  }

  //验证助记词 助记词内容
  //return bool
  static Future<bool> checkMemoValid(String memos) async {
    final dynamic result =
        await channel_memo.invokeMethod('checkMemoValid', memos);
    return Future.value(result);
  }
}
