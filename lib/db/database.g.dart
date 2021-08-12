// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MHWalletDao? _walletDaoInstance;

  ContactAddressDao? _addressDaoInstance;

  NodeDao? _nodeDaoInstance;

  MCollectionTokenDao? _tokensDaoInstance;

  TransRecordModelDao? _transListDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallet_table` (`walletID` TEXT, `walletAaddress` TEXT, `pin` TEXT, `pinTip` TEXT, `createTime` TEXT, `updateTime` TEXT, `isChoose` INTEGER, `prvKey` TEXT, `pubKey` TEXT, `chainType` INTEGER, `leadType` INTEGER, `originType` INTEGER, `masterPubKey` TEXT, `descName` TEXT, PRIMARY KEY (`walletID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `nodes_table` (`content` TEXT NOT NULL, `chainType` INTEGER NOT NULL, `isChoose` INTEGER NOT NULL, `isDefault` INTEGER NOT NULL, `isMainnet` INTEGER NOT NULL, `chainID` INTEGER NOT NULL, PRIMARY KEY (`content`, `chainType`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `contactAddress_table` (`address` TEXT NOT NULL, `coinType` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`address`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tokens_table` (`owner` TEXT, `contract` TEXT, `token` TEXT, `coinType` TEXT, `state` INTEGER, `decimals` INTEGER, `price` REAL, `balance` REAL, `digits` INTEGER, PRIMARY KEY (`owner`, `token`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `translist_table` (`txid` TEXT, `toAdd` TEXT, `fromAdd` TEXT, `date` TEXT, `amount` TEXT, `remarks` TEXT, `fee` TEXT, `gasPrice` TEXT, `gasLimit` TEXT, `transStatus` INTEGER, `symbol` TEXT, `coinType` TEXT, `transType` INTEGER, `chainid` INTEGER, PRIMARY KEY (`txid`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MHWalletDao get walletDao {
    return _walletDaoInstance ??= _$MHWalletDao(database, changeListener);
  }

  @override
  ContactAddressDao get addressDao {
    return _addressDaoInstance ??=
        _$ContactAddressDao(database, changeListener);
  }

  @override
  NodeDao get nodeDao {
    return _nodeDaoInstance ??= _$NodeDao(database, changeListener);
  }

  @override
  MCollectionTokenDao get tokensDao {
    return _tokensDaoInstance ??=
        _$MCollectionTokenDao(database, changeListener);
  }

  @override
  TransRecordModelDao get transListDao {
    return _transListDaoInstance ??=
        _$TransRecordModelDao(database, changeListener);
  }
}

class _$MHWalletDao extends MHWalletDao {
  _$MHWalletDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _mHWalletInsertionAdapter = InsertionAdapter(
            database,
            'wallet_table',
            (MHWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'pinTip': item.pinTip,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'prvKey': item.prvKey,
                  'pubKey': item.pubKey,
                  'chainType': item.chainType,
                  'leadType': item.leadType,
                  'originType': item.originType,
                  'masterPubKey': item.masterPubKey,
                  'descName': item.descName
                },
            changeListener),
        _mHWalletUpdateAdapter = UpdateAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (MHWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'pinTip': item.pinTip,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'prvKey': item.prvKey,
                  'pubKey': item.pubKey,
                  'chainType': item.chainType,
                  'leadType': item.leadType,
                  'originType': item.originType,
                  'masterPubKey': item.masterPubKey,
                  'descName': item.descName
                },
            changeListener),
        _mHWalletDeletionAdapter = DeletionAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (MHWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'pinTip': item.pinTip,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'prvKey': item.prvKey,
                  'pubKey': item.pubKey,
                  'chainType': item.chainType,
                  'leadType': item.leadType,
                  'originType': item.originType,
                  'masterPubKey': item.masterPubKey,
                  'descName': item.descName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MHWallet> _mHWalletInsertionAdapter;

  final UpdateAdapter<MHWallet> _mHWalletUpdateAdapter;

  final DeletionAdapter<MHWallet> _mHWalletDeletionAdapter;

  @override
  Future<MHWallet?> findWalletByWalletID(String walletID) async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE walletID = ?1',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?),
        arguments: [walletID]);
  }

  @override
  Future<MHWallet?> findChooseWallet() async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE isChoose = 1',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?));
  }

  @override
  Future<MHWallet?> finDidChooseWallet() async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE didChoose = 1',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?));
  }

  @override
  Future<List<MHWallet>> findWalletsByChainType(int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_table WHERE chainType = ?1 ORDER BY "index"',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?),
        arguments: [chainType]);
  }

  @override
  Future<List<MHWallet>> findWalletsByType(int originType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_table WHERE originType = ?1 ORDER BY "index"',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?),
        arguments: [originType]);
  }

  @override
  Future<List<MHWallet>> findWalletsByAddress(
      String walletAaddress, int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_table WHERE walletAaddress = ?1 and chainType = ?2',
        mapper: (Map<String, Object?> row) => MHWallet(row['walletID'] as String?, row['walletAaddress'] as String?, row['pin'] as String?, row['pinTip'] as String?, row['createTime'] as String?, row['updateTime'] as String?, row['isChoose'] == null ? null : (row['isChoose'] as int) != 0, row['prvKey'] as String?, row['pubKey'] as String?, row['chainType'] as int?, row['leadType'] as int?, row['originType'] as int?, row['masterPubKey'] as String?, row['descName'] as String?),
        arguments: [walletAaddress, chainType]);
  }

  @override
  Future<List<MHWallet>> findWalletsBySQL(String sql) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_table WHERE ?1  ORDER BY "index"',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?),
        arguments: [sql]);
  }

  @override
  Future<List<MHWallet>> findAllWallets() async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_table ORDER BY "index"',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?));
  }

  @override
  Stream<List<MHWallet>> findAllWalletsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM wallet_table',
        mapper: (Map<String, Object?> row) => MHWallet(
            row['walletID'] as String?,
            row['walletAaddress'] as String?,
            row['pin'] as String?,
            row['pinTip'] as String?,
            row['createTime'] as String?,
            row['updateTime'] as String?,
            row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            row['prvKey'] as String?,
            row['pubKey'] as String?,
            row['chainType'] as int?,
            row['leadType'] as int?,
            row['originType'] as int?,
            row['masterPubKey'] as String?,
            row['descName'] as String?),
        queryableName: 'wallet_table',
        isView: false);
  }

  @override
  Future<void> insertWallet(MHWallet wallet) async {
    await _mHWalletInsertionAdapter.insert(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertWallets(List<MHWallet> wallet) async {
    await _mHWalletInsertionAdapter.insertList(
        wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallet(MHWallet wallet) async {
    await _mHWalletUpdateAdapter.update(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallets(List<MHWallet> wallet) async {
    await _mHWalletUpdateAdapter.updateList(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWallet(MHWallet wallet) async {
    await _mHWalletDeletionAdapter.delete(wallet);
  }

  @override
  Future<void> deleteWallets(List<MHWallet> wallet) async {
    await _mHWalletDeletionAdapter.deleteList(wallet);
  }
}

class _$ContactAddressDao extends ContactAddressDao {
  _$ContactAddressDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _contactAddressInsertionAdapter = InsertionAdapter(
            database,
            'contactAddress_table',
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                }),
        _contactAddressUpdateAdapter = UpdateAdapter(
            database,
            'contactAddress_table',
            ['address'],
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                }),
        _contactAddressDeletionAdapter = DeletionAdapter(
            database,
            'contactAddress_table',
            ['address'],
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ContactAddress> _contactAddressInsertionAdapter;

  final UpdateAdapter<ContactAddress> _contactAddressUpdateAdapter;

  final DeletionAdapter<ContactAddress> _contactAddressDeletionAdapter;

  @override
  Future<List<ContactAddress>> findAddressType(int coinType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM contactAddress_table WHERE coinType = ?1',
        mapper: (Map<String, Object?> row) => ContactAddress(
            row['address'] as String,
            row['coinType'] as int,
            row['name'] as String),
        arguments: [coinType]);
  }

  @override
  Future<void> insertAddress(ContactAddress model) async {
    await _contactAddressInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateAddress(ContactAddress model) async {
    await _contactAddressUpdateAdapter.update(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAddress(ContactAddress model) async {
    await _contactAddressDeletionAdapter.delete(model);
  }
}

class _$NodeDao extends NodeDao {
  _$NodeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _nodeModelInsertionAdapter = InsertionAdapter(
            database,
            'nodes_table',
            (NodeModel item) => <String, Object?>{
                  'content': item.content,
                  'chainType': item.chainType,
                  'isChoose': item.isChoose ? 1 : 0,
                  'isDefault': item.isDefault ? 1 : 0,
                  'isMainnet': item.isMainnet ? 1 : 0,
                  'chainID': item.chainID
                }),
        _nodeModelUpdateAdapter = UpdateAdapter(
            database,
            'nodes_table',
            ['content', 'chainType'],
            (NodeModel item) => <String, Object?>{
                  'content': item.content,
                  'chainType': item.chainType,
                  'isChoose': item.isChoose ? 1 : 0,
                  'isDefault': item.isDefault ? 1 : 0,
                  'isMainnet': item.isMainnet ? 1 : 0,
                  'chainID': item.chainID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NodeModel> _nodeModelInsertionAdapter;

  final UpdateAdapter<NodeModel> _nodeModelUpdateAdapter;

  @override
  Future<List<NodeModel>> queryNodeByIsChoose(bool isChoose) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nodes_table WHERE isChoose = ?1',
        mapper: (Map<String, Object?> row) => NodeModel(
            row['content'] as String,
            row['chainType'] as int,
            (row['isChoose'] as int) != 0,
            (row['isDefault'] as int) != 0,
            (row['isMainnet'] as int) != 0,
            row['chainID'] as int),
        arguments: [isChoose ? 1 : 0]);
  }

  @override
  Future<List<NodeModel>> queryNodeByChainType(int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nodes_table WHERE chainType = ?1',
        mapper: (Map<String, Object?> row) => NodeModel(
            row['content'] as String,
            row['chainType'] as int,
            (row['isChoose'] as int) != 0,
            (row['isDefault'] as int) != 0,
            (row['isMainnet'] as int) != 0,
            row['chainID'] as int),
        arguments: [chainType]);
  }

  @override
  Future<List<NodeModel>> queryNodeByContent(String content) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nodes_table WHERE content = ?1',
        mapper: (Map<String, Object?> row) => NodeModel(
            row['content'] as String,
            row['chainType'] as int,
            (row['isChoose'] as int) != 0,
            (row['isDefault'] as int) != 0,
            (row['isMainnet'] as int) != 0,
            row['chainID'] as int),
        arguments: [content]);
  }

  @override
  Future<List<NodeModel>> queryNodeByIsDefaultAndChainType(
      bool isDefault, int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nodes_table WHERE isDefault = ?1 And chainType = ?2',
        mapper: (Map<String, Object?> row) => NodeModel(
            row['content'] as String,
            row['chainType'] as int,
            (row['isChoose'] as int) != 0,
            (row['isDefault'] as int) != 0,
            (row['isMainnet'] as int) != 0,
            row['chainID'] as int),
        arguments: [isDefault ? 1 : 0, chainType]);
  }

  @override
  Future<List<NodeModel>> queryNodeByContentAndChainType(
      String content, int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nodes_table WHERE content = ?1 And chainType = ?2',
        mapper: (Map<String, Object?> row) => NodeModel(
            row['content'] as String,
            row['chainType'] as int,
            (row['isChoose'] as int) != 0,
            (row['isDefault'] as int) != 0,
            (row['isMainnet'] as int) != 0,
            row['chainID'] as int),
        arguments: [content, chainType]);
  }

  @override
  Future<void> insertNodeDatas(List<NodeModel> list) async {
    await _nodeModelInsertionAdapter.insertList(list, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertNodeData(NodeModel model) async {
    await _nodeModelInsertionAdapter.insert(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateNode(NodeModel model) async {
    await _nodeModelUpdateAdapter.update(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateNodes(List<NodeModel> models) async {
    await _nodeModelUpdateAdapter.updateList(models, OnConflictStrategy.abort);
  }
}

class _$MCollectionTokenDao extends MCollectionTokenDao {
  _$MCollectionTokenDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _mCollectionTokensInsertionAdapter = InsertionAdapter(
            database,
            'tokens_table',
            (MCollectionTokens item) => <String, Object?>{
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'state': item.state,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits
                }),
        _mCollectionTokensUpdateAdapter = UpdateAdapter(
            database,
            'tokens_table',
            ['owner', 'token'],
            (MCollectionTokens item) => <String, Object?>{
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'state': item.state,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits
                }),
        _mCollectionTokensDeletionAdapter = DeletionAdapter(
            database,
            'tokens_table',
            ['owner', 'token'],
            (MCollectionTokens item) => <String, Object?>{
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'state': item.state,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MCollectionTokens> _mCollectionTokensInsertionAdapter;

  final UpdateAdapter<MCollectionTokens> _mCollectionTokensUpdateAdapter;

  final DeletionAdapter<MCollectionTokens> _mCollectionTokensDeletionAdapter;

  @override
  Future<List<MCollectionTokens>> findTokens(String owner) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1',
        mapper: (Map<String, Object?> row) => MCollectionTokens(
            owner: row['owner'] as String?,
            contract: row['contract'] as String?,
            token: row['token'] as String?,
            coinType: row['coinType'] as String?,
            state: row['state'] as int?,
            decimals: row['decimals'] as int?,
            price: row['price'] as double?,
            balance: row['balance'] as double?,
            digits: row['digits'] as int?),
        arguments: [owner]);
  }

  @override
  Future<List<MCollectionTokens>> findStateTokens(
      String owner, int state) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1 and state = ?2',
        mapper: (Map<String, Object?> row) => MCollectionTokens(
            owner: row['owner'] as String?,
            contract: row['contract'] as String?,
            token: row['token'] as String?,
            coinType: row['coinType'] as String?,
            state: row['state'] as int?,
            decimals: row['decimals'] as int?,
            price: row['price'] as double?,
            balance: row['balance'] as double?,
            digits: row['digits'] as int?),
        arguments: [owner, state]);
  }

  @override
  Future<void> insertToken(MCollectionTokens model) async {
    await _mCollectionTokensInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTokens(List<MCollectionTokens> models) async {
    await _mCollectionTokensInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(MCollectionTokens model) async {
    await _mCollectionTokensUpdateAdapter.update(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(MCollectionTokens model) async {
    await _mCollectionTokensDeletionAdapter.delete(model);
  }
}

class _$TransRecordModelDao extends TransRecordModelDao {
  _$TransRecordModelDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _transRecordModelInsertionAdapter = InsertionAdapter(
            database,
            'translist_table',
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'symbol': item.symbol,
                  'coinType': item.coinType,
                  'transType': item.transType,
                  'chainid': item.chainid
                }),
        _transRecordModelUpdateAdapter = UpdateAdapter(
            database,
            'translist_table',
            ['txid'],
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'symbol': item.symbol,
                  'coinType': item.coinType,
                  'transType': item.transType,
                  'chainid': item.chainid
                }),
        _transRecordModelDeletionAdapter = DeletionAdapter(
            database,
            'translist_table',
            ['txid'],
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'symbol': item.symbol,
                  'coinType': item.coinType,
                  'transType': item.transType,
                  'chainid': item.chainid
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransRecordModel> _transRecordModelInsertionAdapter;

  final UpdateAdapter<TransRecordModel> _transRecordModelUpdateAdapter;

  final DeletionAdapter<TransRecordModel> _transRecordModelDeletionAdapter;

  @override
  Future<List<TransRecordModel>> queryTrxList(
      String fromAdd, String symbol, int chainid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE (fromAdd = ?1 or toAdd = ?1)  and symbol = ?2 and chainid = ?3',
        mapper: (Map<String, Object?> row) => TransRecordModel(txid: row['txid'] as String?, toAdd: row['toAdd'] as String?, fromAdd: row['fromAdd'] as String?, date: row['date'] as String?, amount: row['amount'] as String?, remarks: row['remarks'] as String?, fee: row['fee'] as String?, transStatus: row['transStatus'] as int?, symbol: row['symbol'] as String?, coinType: row['coinType'] as String?, gasLimit: row['gasLimit'] as String?, gasPrice: row['gasPrice'] as String?, transType: row['transType'] as int?, chainid: row['chainid'] as int?),
        arguments: [fromAdd, symbol, chainid]);
  }

  @override
  Future<List<TransRecordModel>> queryTrxFromTrxid(String txid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE txid = ?1',
        mapper: (Map<String, Object?> row) => TransRecordModel(
            txid: row['txid'] as String?,
            toAdd: row['toAdd'] as String?,
            fromAdd: row['fromAdd'] as String?,
            date: row['date'] as String?,
            amount: row['amount'] as String?,
            remarks: row['remarks'] as String?,
            fee: row['fee'] as String?,
            transStatus: row['transStatus'] as int?,
            symbol: row['symbol'] as String?,
            coinType: row['coinType'] as String?,
            gasLimit: row['gasLimit'] as String?,
            gasPrice: row['gasPrice'] as String?,
            transType: row['transType'] as int?,
            chainid: row['chainid'] as int?),
        arguments: [txid]);
  }

  @override
  Future<void> insertTrxList(TransRecordModel model) async {
    await _transRecordModelInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTrxLists(List<TransRecordModel> models) async {
    await _transRecordModelInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTrxList(TransRecordModel model) async {
    await _transRecordModelUpdateAdapter.update(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTrxLists(List<TransRecordModel> models) async {
    await _transRecordModelUpdateAdapter.updateList(
        models, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTrxList(TransRecordModel model) async {
    await _transRecordModelDeletionAdapter.delete(model);
  }
}
