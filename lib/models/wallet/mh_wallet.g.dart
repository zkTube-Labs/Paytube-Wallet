// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mh_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MHWallet _$MHWalletFromJson(Map<String, dynamic> json) {
  return MHWallet(
    json['walletID'] as String?,
    json['walletAaddress'] as String?,
    json['pin'] as String?,
    json['pinTip'] as String?,
    json['createTime'] as String?,
    json['updateTime'] as String?,
    json['isChoose'] as bool?,
    json['prvKey'] as String?,
    json['pubKey'] as String?,
    json['chainType'] as int?,
    json['leadType'] as int?,
    json['originType'] as int?,
    json['masterPubKey'] as String?,
    json['descName'] as String?,
  );
}

Map<String, dynamic> _$MHWalletToJson(MHWallet instance) => <String, dynamic>{
      'walletID': instance.walletID,
      'walletAaddress': instance.walletAaddress,
      'pin': instance.pin,
      'pinTip': instance.pinTip,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'isChoose': instance.isChoose,
      'prvKey': instance.prvKey,
      'pubKey': instance.pubKey,
      'chainType': instance.chainType,
      'leadType': instance.leadType,
      'originType': instance.originType,
      'masterPubKey': instance.masterPubKey,
      'descName': instance.descName,
    };
