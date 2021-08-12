// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MCollectionTokens _$MCollectionTokensFromJson(Map<String, dynamic> json) {
  return MCollectionTokens(
    owner: json['owner'] as String?,
    contract: json['contract'] as String?,
    token: json['token'] as String?,
    coinType: json['coinType'] as String?,
    state: json['state'] as int?,
    decimals: json['decimals'] as int?,
    price: (json['price'] as num?)?.toDouble(),
    balance: (json['balance'] as num?)?.toDouble(),
    digits: json['digits'] as int?,
  );
}

Map<String, dynamic> _$MCollectionTokensToJson(MCollectionTokens instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'contract': instance.contract,
      'token': instance.token,
      'coinType': instance.coinType,
      'state': instance.state,
      'decimals': instance.decimals,
      'price': instance.price,
      'balance': instance.balance,
      'digits': instance.digits,
    };
