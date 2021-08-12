import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_coinid/models/contacts/contact_address.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/node/node_model.dart';
part 'database.g.dart';

//flutter packages pub run build_runner build
//findWalletsBySQL 需要手动替换
// 'SELECT * FROM wallet_table WHERE $symbol',
// arguments: <dynamic>[symbol],

const int dbCurrentVersion = 1;

@Database(version: dbCurrentVersion, entities: [
  MHWallet,
  NodeModel,
  ContactAddress,
  MCollectionTokens,
  TransRecordModel
])
abstract class FlutterDatabase extends FloorDatabase {
  // NodeDao get nodeDao;
  MHWalletDao get walletDao;
  ContactAddressDao get addressDao;
  NodeDao get nodeDao;
  MCollectionTokenDao get tokensDao;
  TransRecordModelDao get transListDao;
}
