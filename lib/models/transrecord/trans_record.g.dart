// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransRecordModel _$TransRecordModelFromJson(Map<String, dynamic> json) {
  return TransRecordModel(
    txid: json['txid'] as String?,
    toAdd: json['toAdd'] as String?,
    fromAdd: json['fromAdd'] as String?,
    date: json['date'] as String?,
    amount: json['amount'] as String?,
    remarks: json['remarks'] as String?,
    fee: json['fee'] as String?,
    transStatus: json['transStatus'] as int?,
    symbol: json['symbol'] as String?,
    coinType: json['coinType'] as String?,
    gasLimit: json['gasLimit'] as String?,
    gasPrice: json['gasPrice'] as String?,
    transType: json['transType'] as int?,
    chainid: json['chainid'] as int?,
  );
}

Map<String, dynamic> _$TransRecordModelToJson(TransRecordModel instance) =>
    <String, dynamic>{
      'txid': instance.txid,
      'toAdd': instance.toAdd,
      'fromAdd': instance.fromAdd,
      'date': instance.date,
      'amount': instance.amount,
      'remarks': instance.remarks,
      'fee': instance.fee,
      'gasPrice': instance.gasPrice,
      'gasLimit': instance.gasLimit,
      'transStatus': instance.transStatus,
      'symbol': instance.symbol,
      'coinType': instance.coinType,
      'transType': instance.transType,
      'chainid': instance.chainid,
    };
