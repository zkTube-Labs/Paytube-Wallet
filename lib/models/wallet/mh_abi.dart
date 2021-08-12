import 'package:flutter_coinid/utils/instruction_data_format.dart';

class ETHAbiModel {
  final bool? numberType;
  final bool? addrType;
  final bool? bytesData;
  final String? value;

  ETHAbiModel({this.numberType, this.addrType, this.bytesData, this.value});

  static String abiDataWithAbiModel(List<ETHAbiModel> abis) {
    List dataArr = [];
    List multiData = [];
    int multiLen = 0;
    for (int a = 0; a < abis.length; a++) {
      ETHAbiModel model = abis[a];
      if (model.numberType == true) {
        String numValue = model.value!;
        List<String> hexString = InstructionDataFormat.intParseHex(numValue);
        List hexData = List.filled(32, "00", growable: true);
        hexData.replaceRange(
            hexData.length - hexString.length, hexData.length, hexString);
        dataArr.addAll(hexData);
      } else if (model.addrType == true) {
        String addv = model.value!;
        List<String> hexString = InstructionDataFormat.hexParseList(addv);
        List hexData = List.filled(32, "00", growable: true);
        hexData.replaceRange(
            hexData.length - hexString.length, hexData.length, hexString);
        dataArr.addAll(hexData);
      } else if (model.bytesData == true) {
      } else {}
    }
    return dataArr.join("");
  }
}
