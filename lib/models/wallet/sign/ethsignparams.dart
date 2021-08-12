import 'package:flutter_coinid/constant/constant.dart';

class ETHSignParams {
  final String nonce;
  final String gasPrice;
  final String gasLimit;
  final String? data;
  final String chainID;
  final int decimal;
  final String? contract;
  final MSignType signType;

  ETHSignParams(this.nonce, this.gasPrice, this.gasLimit, this.data,
      this.chainID, this.decimal, this.contract, this.signType);
}
